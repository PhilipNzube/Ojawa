import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import '../screens/main_app/main_app.dart';
import 'home_page_controller.dart';
import 'navigation_controller.dart';

class SignInController extends ChangeNotifier {
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  String _selectedRole = 'Select Role';
  String _url = "";

  SignInController() {
    _roleController.text = _selectedRole;
    initializePrefs();
  }

  //public getters
  FocusNode get userNameFocusNode => _userNameFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get roleFocusNode => _roleFocusNode;
  TextEditingController get userNameController => _userNameController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get roleController => _roleController;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;

  void setRemberMe(bool value) async {
    _rememberMe = value;
    await prefs.setBool("rememberMe", _rememberMe);
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSelectedRole(String value) {
    _selectedRole = value;
    roleController.text = value;
    notifyListeners();
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('rememberMe') ?? false;
    notifyListeners();
    String? savedUserName = prefs.getString('userName');
    String? savedRole = await storage.read(key: 'userRole');

    if (_rememberMe == true) {
      if (savedUserName != null) {
        _userNameController.text = savedUserName;
        notifyListeners();
      }

      if (savedRole != null) {
        _roleController.text = savedRole;
        _selectedRole = savedRole;
        notifyListeners();
      }
    }
  }

  Future<void> submitForm(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    if (prefs == null) {
      await initializePrefs();
    }
    if (_selectedRole == "Customer") {
      _url = "customer/sign-in";
      notifyListeners();
    } else if (_selectedRole == "Vendor") {
      _url = "vendor/sign-in";
      notifyListeners();
    } else if (_selectedRole == "Logistics") {
      _url = "logistics/sign-in";
      notifyListeners();
    }
    print(_url);

    final String userName = _userNameController.text.trim();
    final String password = _passwordController.text.trim();
    final String userRole = _roleController.text.trim();

    if (userName.isEmpty || password.isEmpty || userRole == 'Select Role') {
      // Show an error message if any field is empty
      CustomSnackbar.show(
        'All fields are required.',
        isError: true,
      );

      return;
    }

    // Validate password length
    if (password.length < 6) {
      // Show an error message if password is too short
      CustomSnackbar.show(
        'Password must be at least 6 characters.',
        isError: true,
      );

      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse('https://ojawa-api.onrender.com/api/Auth/$_url'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': userName,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (response.statusCode == 200) {
        Provider.of<NavigationController>(navigatorKey.currentContext!,
                listen: false)
            .setSelectedIndex(0);
        final Map<String, dynamic> responseData =
            json.decode(response.body); // Decode the response body
        final String accessToken = responseData['token'];
        final int userId =
            responseData['userId']; // Extract userId from response

        await prefs.setString('userName', userName);
        await storage.write(key: 'userRole', value: _selectedRole);
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'userId', value: userId.toString());

        // Handle the successful response here
        CustomSnackbar.show(
          'Sign in successful!',
          isError: false,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainApp(
                key: UniqueKey(),
                onToggleDarkMode: onToggleDarkMode,
                isDarkMode: isDarkMode),
          ),
        );
        _isLoading = false;
        notifyListeners();
      } else if (response.statusCode == 400) {
        _isLoading = false;
        notifyListeners();
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String error = responseData['message'];

        CustomSnackbar.show(
          'Error: $error',
          isError: true,
        );
      } else {
        _isLoading = false;
        notifyListeners();

        CustomSnackbar.show(
          'An unexpected error occurred.',
          isError: true,
        );
      }
    } catch (error) {
      print('Error: $error');
      CustomSnackbar.show(
        'An unexpected error occurred. Check if the right login details were inputted',
        isError: true,
      );
      _isLoading = false;
      notifyListeners();
    }
  }
}
