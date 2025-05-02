import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import '../screens/main_app/main_app.dart';
import '../screens/verify_email/verify_email.dart';
import 'home_page_controller.dart';
import 'navigation_controller.dart';
import 'session_controller.dart';

class SignInController extends ChangeNotifier {
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get roleFocusNode => _roleFocusNode;

  TextEditingController get userNameController => _userNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get roleController => _roleController;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  String get selectedRole => _selectedRole;

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

    final session = Provider.of<SessionController>(
      navigatorKey.currentContext!,
      listen: false,
    );
    final userInfo = await session.getUserInfo(prefs);

    _roleController.text = userInfo.selectedRole.isNotEmpty
        ? userInfo.selectedRole
        : "Select Role";
    _selectedRole = userInfo.selectedRole.isNotEmpty
        ? userInfo.selectedRole
        : "Select Role";
    notifyListeners();

    if (_rememberMe == true && userInfo.email.isNotEmpty) {
      _emailController.text = userInfo.email;
      notifyListeners();
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
    final String email = emailController.text.trim();
    final String userRole = _roleController.text.trim();

    if (email.isEmpty || password.isEmpty || userRole == 'Select Role') {
      // Show an error message if any field is empty
      CustomSnackbar.show(
        'All fields are required.',
        isError: true,
      );

      return;
    }

    // Validate password length
    if (password.length < 8) {
      // Show an error message if password is too short
      CustomSnackbar.show(
        'Password must be at least 8 characters.',
        isError: true,
      );

      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      print('Response Data: $responseData');
      print('Response Data: ${response.statusCode}');

      if (response.statusCode == 200) {
        Provider.of<NavigationController>(navigatorKey.currentContext!,
                listen: false)
            .setSelectedIndex(0);
        final Map<String, dynamic> responseData =
            json.decode(response.body); // Decode the response body
        final String accessToken = responseData['data']['accessToken'];
        final String message = responseData['message'];

        //await storage.write(key: 'userRole', value: _selectedRole);
        await Provider.of<SessionController>(navigatorKey.currentContext!,
                listen: false)
            .saveToken(accessToken, _selectedRole);
        if (Provider.of<SessionController>(navigatorKey.currentContext!,
                    listen: false)
                .isAuthenticated ==
            true) {
          // Handle the successful response here
          CustomSnackbar.show(
            message,
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
        } else {
          _isLoading = false;
          notifyListeners();
        }
      } else if (response.statusCode == 403) {
        _isLoading = false;
        notifyListeners();
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String error = responseData['message'];
        if (error == "Please verify your email.") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmail(
                  key: UniqueKey(),
                  email: email,
                  onToggleDarkMode: onToggleDarkMode,
                  isDarkMode: isDarkMode),
            ),
          );
          CustomSnackbar.show(
            error,
            isError: true,
          );
        } else {
          CustomSnackbar.show(
            error,
            isError: true,
          );
        }
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _isLoading = false;
        notifyListeners();

        CustomSnackbar.show(
          responseData['message'],
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
