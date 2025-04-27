import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/auth/sign_in_page.dart';

class ForgotPasswordPageController extends ChangeNotifier {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _tokenFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _password2FocusNode = FocusNode();

  bool _isLoading = false;
  bool _isLoading2 = false;
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;

  late TabController _tabController;

  TickerProvider vsync;

  ForgotPasswordPageController({required this.vsync}) {
    initialize();
  }

  //public getters
  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;

  TextEditingController get emailController => _emailController;
  TextEditingController get tokenController => _tokenController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get password2Controller => _password2Controller;

  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get tokenFocusNode => _tokenFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get password2FocusNode => _password2FocusNode;

  void initialize() {
    _initializePrefs();
    _tabController = TabController(length: 2, vsync: vsync);
    notifyListeners();
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> resetPasswordRequest() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      CustomSnackbar.show(
        'Email is required.',
        isError: true,
      );

      return;
    }

    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('https://dev-server.ojawa.africa/api/v1/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      CustomSnackbar.show(
        'Reset link sent successfully.',
        isError: false,
      );
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      CustomSnackbar.show(
        'Error: ${responseData['message']}',
        isError: true,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    final String email = emailController.text.trim();
    final String token = tokenController.text.trim();
    final String password = passwordController.text.trim();
    final String passwordConfirmation = password2Controller.text.trim();

    if (email.isEmpty ||
        token.isEmpty ||
        password.isEmpty ||
        passwordConfirmation.isEmpty) {
      CustomSnackbar.show(
        'All fields are required.',
        isError: true,
      );

      return;
    }

    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      CustomSnackbar.show(
        'Please enter a valid email address.',
        isError: true,
      );

      return;
    }

    if (password.length < 6) {
      CustomSnackbar.show(
        'Password must be at least 6 characters.',
        isError: true,
      );

      return;
    }

    if (password != passwordConfirmation) {
      CustomSnackbar.show(
        'Passwords do not match.',
        isError: true,
      );

      return;
    }

    _isLoading2 = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('https://dev-server.ojawa.africa/api/v1/passowrd/reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'token': token,
        //'password_confirmation': passwordConfirmation,
      }),
    );
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      CustomSnackbar.show(
        'Password reset successful.',
        isError: false,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode),
        ),
      );
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      CustomSnackbar.show(
        'Error: ${responseData['message']}',
        isError: true,
      );
    }

    _isLoading2 = false;
    notifyListeners();
  }
}
