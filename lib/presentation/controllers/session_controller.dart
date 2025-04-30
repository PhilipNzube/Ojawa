import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import 'package:flutter/material.dart' hide CarouselController;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import '../screens/auth/sign_in_page.dart';

import 'home_page_controller.dart';

class SessionController extends ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  Map<String, dynamic>? _decodedToken;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get decodedToken => _decodedToken;

  Future<void> initializeSession() async {
    final token = await storage.read(key: 'accessToken');
    if (token != null && !JwtDecoder.isExpired(token)) {
      _decodedToken = JwtDecoder.decode(token);
      print('Decoded JWT Payload: $decodedToken');
      _isAuthenticated = true;
    } else {
      _decodedToken = null;
      _isAuthenticated = false;
      await prefs.remove('userEmail');
      await prefs.remove('userRole');
      await storage.delete(key: 'accessToken');
    }
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'accessToken', value: token);
    _decodedToken = JwtDecoder.decode(token);
    print('Decoded JWT Payload: $decodedToken');
    _isAuthenticated = true;
    // Save user info after decoding the token
    //await _saveUserInfoFromToken();
    notifyListeners();
  }

  Future<void> _saveUserInfoFromToken() async {
    if (_decodedToken != null) {
      final String userName = _decodedToken?['userName'] ?? '';
      final String email = _decodedToken?['email'] ?? '';

      // Store the values in preferences and secure storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      //await prefs.setString('userName', userName);

      print("User info saved: $userName, $email");
    }
  }

  Future<void> logout(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    Navigator.pop(navigatorKey.currentContext!);
    if (accessToken == null) {
      CustomSnackbar.show(
        'You are not logged in.',
        isError: true,
      );

      return;
    }
    CustomSnackbar.show(
      'Logging out...',
    );
    try {
      final response = await http.post(
        Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      print('Response Status: ${response.statusCode}');
      print('Response Data: $responseData');

      if (response.statusCode == 200) {
        CustomSnackbar.show(
          'Logged out successfully!',
          isError: false,
        );

        await prefs.remove('userEmail');
        await prefs.remove('userRole');
        await storage.delete(key: 'userRole');
        await storage.delete(key: 'accessToken');

        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => SignInPage(
                key: UniqueKey(),
                onToggleDarkMode: onToggleDarkMode,
                isDarkMode: isDarkMode),
          ),
        );
        Provider.of<HomePageController>(navigatorKey.currentContext!,
                listen: false)
            .setIsLoggedOut(true);
      } else if (response.statusCode == 400) {
        final String message = responseData['message'] ?? 'Unauthorized';
        CustomSnackbar.show(
          message,
          isError: true,
        );
      } else {
        CustomSnackbar.show(
          'An unexpected error occurred. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        'Failed to connect to the server. Please check your internet connection.',
        isError: true,
      );
    } finally {
      Provider.of<HomePageController>(navigatorKey.currentContext!,
              listen: false)
          .setIsLoading(false);
    }
  }

  bool isTokenExpired() {
    if (_decodedToken == null) return true;
    final token = _decodedToken!;
    return JwtDecoder.isExpired(token['exp'].toString());
  }

  String? getUserRole() => prefs.getString('userRole');
  String? getUserEmail() => prefs.getString('userEmail');
}
