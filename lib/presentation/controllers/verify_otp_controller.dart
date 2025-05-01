import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/auth/sign_up_page.dart';
import '../screens/main_app/main_app.dart';
import 'session_controller.dart';
import 'sign_up_controller.dart';

class VerifyOtpController extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String _otpCode = "";
  bool _isLoading = false;
  bool _isLoading2 = false;

  final String email;
  final String? token;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  VerifyOtpController(
      {required this.onToggleDarkMode,
      required this.isDarkMode,
      required this.email,
      this.token});

  //public getters
  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;

  void handleOtpInputComplete(String code, BuildContext context) async {
    _otpCode = code;
    notifyListeners();
    await submitOtp(context);
  }

  Future<void> submitOtp(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'code': _otpCode}),
      );

      final responseData = json.decode(response.body);

      print('Response Status: ${response.statusCode}');
      print('Response Data: $responseData');
      print("$email,$_otpCode");

      if (response.statusCode == 200) {
        final String message = responseData['message'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainApp(
                key: UniqueKey(),
                onToggleDarkMode: onToggleDarkMode,
                isDarkMode: isDarkMode),
          ),
        );
        CustomSnackbar.show(
          message,
        );
      } else if (response.statusCode == 400) {
        _isLoading = false;
        notifyListeners();
        final String message = responseData['message'];

        CustomSnackbar.show(message, isError: true);
      } else {
        _isLoading = false;
        notifyListeners();
        CustomSnackbar.show('An unexpected error occurred.', isError: true);
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print(error);
      CustomSnackbar.show('Network error. Please try again.', isError: true);
    }
  }

  Future<void> resendEmail(BuildContext context) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    _isLoading2 = true;
    notifyListeners();

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/verify/resend'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final responseData = json.decode(response.body);

      print('Response Status: ${response.statusCode}');
      print('Response Data: $responseData');
      print(email);

      if (response.statusCode == 200) {
        final String message = responseData['message'];
        await Provider.of<SessionController>(context, listen: false).saveToken(
            accessToken!,
            Provider.of<SignUpController>(
              context,
              listen: false,
            ).selectedRole);

        CustomSnackbar.show(
          message,
        );
        _isLoading2 = false;
        notifyListeners();
      } else if (response.statusCode == 400) {
        _isLoading2 = false;
        notifyListeners();
        final String message = responseData['message'];

        CustomSnackbar.show(message, isError: true);
      } else {
        _isLoading2 = false;
        notifyListeners();
        CustomSnackbar.show('An unexpected error occurred.', isError: true);
      }
    } catch (error) {
      _isLoading2 = false;
      notifyListeners();
      print(error);
      CustomSnackbar.show('Network error. Please try again.', isError: true);
    }
  }
}
