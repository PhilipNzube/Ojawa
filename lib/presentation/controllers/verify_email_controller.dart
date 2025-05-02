import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../screens/auth/sign_up_page.dart';
import '../screens/verify_otp/verify_otp.dart';

class VerifyEmailController extends ChangeNotifier {
  bool _isLoading = false;
  bool isLoading2 = false;
  int? _selectedRadioValue = 0;
  bool _showInitialContent = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String phoneNumber = '';

  final String email;

  VerifyEmailController({required this.email}) {
    _emailController.text = email;
  }

  //public getters
  bool get isLoading => _isLoading;
  int? get selectedRadioValue => _selectedRadioValue;

  TextEditingController get emailController => _emailController;

  FocusNode get emailFocusNode => _emailFocusNode;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  Future<void> verifyEmail(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    _isLoading = true;
    notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyOtp(
            key: UniqueKey(),
            onToggleDarkMode: onToggleDarkMode,
            isDarkMode: isDarkMode,
            email: emailController.text.trim()),
      ),
    );
    _isLoading = false;
    notifyListeners();
  }
}
