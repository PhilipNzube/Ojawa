import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/auth/sign_up_page.dart';

class VerifyOtpController extends ChangeNotifier {
  String _otpCode = "";
  bool _isLoading = false;

  final String token;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  VerifyOtpController(
      {required this.onToggleDarkMode,
      required this.isDarkMode,
      required this.token});

  //public getters
  bool get isLoading => _isLoading;

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
        Uri.parse('https://ojawa-api.onrender.com/api/Auth/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'otp': _otpCode}),
      );

      final responseData = json.decode(response.body);

      print('Response Data: $responseData');

      if (response.statusCode == 200) {
        final String message = responseData['message'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(
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
        final String status = responseData['status'];

        if (status == "Partial_Success") {
          CustomSnackbar.show(message, isError: false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(
                  key: UniqueKey(),
                  onToggleDarkMode: onToggleDarkMode,
                  isDarkMode: isDarkMode),
            ),
          );
        } else {
          CustomSnackbar.show(message, isError: true);
        }
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
}
