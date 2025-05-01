import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../data/model/user_info.dart';
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

  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  // SessionController({
  //   required this.onToggleDarkMode,
  //   required this.isDarkMode,
  // }) {
  //   initializeSession();
  // }

  SessionController({
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> initializeSession() async {
    await initializePrefs();
    final token = await storage.read(key: 'accessToken');

    if (token != null && !JwtDecoder.isExpired(token)) {
      _decodedToken = JwtDecoder.decode(token);
      _isAuthenticated = true;
      print('Decoded JWT Payload: $_decodedToken');
      await _saveUserInfoFromToken();
    } else {
      await logoutAndRedirect(
          message: 'You have been logged out. Session expired');
    }

    notifyListeners();
  }

  Future<void> saveToken(String token, String selectedRole) async {
    await initializePrefs();
    await storage.write(key: 'accessToken', value: token);
    _decodedToken = JwtDecoder.decode(token);
    _isAuthenticated = true;
    print('Decoded JWT Payload: $_decodedToken');

    final rawRoles = List<String>.from(_decodedToken?['roles'] ?? []);
    final formattedRoles = rawRoles
        .map((role) => role.replaceFirstMapped(
            RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase()))
        .toList();

    if (formattedRoles.contains(selectedRole)) {
      final userInfo = UserInfo.fromDecodedToken(_decodedToken!, selectedRole);

      for (var entry in userInfo.toPrefsMap().entries) {
        await prefs.setString(entry.key, entry.value);
      }

      print(
          "Saved user info → ${userInfo.username}, ${userInfo.email}, $selectedRole");
    } else {
      CustomSnackbar.show(
          'You do not have permission to use the selected role. Please choose a valid role assigned to your account.',
          isError: true);
      print('Selected role "$selectedRole" not found in user roles');
      return;
    }

    notifyListeners();
  }

  Future<void> _saveUserInfoFromToken() async {
    if (_decodedToken == null) return;

    final selectedRole = prefs.getString('user_selected_role') ?? 'User';

    final userInfo = UserInfo.fromDecodedToken(_decodedToken!, selectedRole);

    for (var entry in userInfo.toPrefsMap().entries) {
      await prefs.setString(entry.key, entry.value);
    }

    print(
        "Saved user info → ${userInfo.username}, ${userInfo.email}, $selectedRole");
  }

  Future<UserInfo> getUserInfo(SharedPreferences prefs) async {
    if (_decodedToken != null) {
      final selectedRole = prefs.getString('user_selected_role') ?? 'User';
      return UserInfo.fromDecodedToken(_decodedToken!, selectedRole);
    } else {
      final Map<String, String?> userPrefs = {
        'user_first_name': prefs.getString('user_first_name'),
        'user_last_name': prefs.getString('user_last_name'),
        'user_email': prefs.getString('user_email'),
        'user_phone': prefs.getString('user_phone'),
        'user_country': prefs.getString('user_country'),
        'user_roles': prefs.getString('user_roles'),
        'user_selected_role': prefs.getString('user_selected_role'),
        'user_username': prefs.getString('user_username'),
      };

      return UserInfo.fromPrefs(userPrefs);
    }
  }

  Future<void> logout(BuildContext context, Function(bool) onToggleDarkMode,
      bool isDarkMode) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    Navigator.pop(navigatorKey.currentContext!);

    if (accessToken == null) {
      CustomSnackbar.show('You are not logged in.', isError: true);
      return;
    }

    CustomSnackbar.show('Logging out...');
    try {
      final response = await http.post(
        Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        CustomSnackbar.show('Logged out successfully!', isError: false);
        await _clearUserSession();
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => SignInPage(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode,
            ),
          ),
        );
        Provider.of<HomePageController>(navigatorKey.currentContext!,
                listen: false)
            .setIsLoggedOut(true);
      } else {
        final responseData = json.decode(response.body);
        CustomSnackbar.show(
            responseData['message'] ?? 'Unexpected logout error.',
            isError: true);
      }
    } catch (_) {
      CustomSnackbar.show('Failed to connect. Check your internet.',
          isError: true);
    } finally {
      Provider.of<HomePageController>(navigatorKey.currentContext!,
              listen: false)
          .setIsLoading(false);
    }
  }

  Future<void> logoutAndRedirect({String? message}) async {
    await _clearUserSession();

    if (message != null) {
      CustomSnackbar.show(message, isError: true);
    }

    // Navigator.pushReplacement(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (_) => SignInPage(
    //       key: UniqueKey(),
    //       onToggleDarkMode: onToggleDarkMode,
    //       isDarkMode: isDarkMode,
    //     ),
    //   ),
    // );
  }

  Future<void> _clearUserSession() async {
    await prefs.clear();
    await storage.deleteAll();
    _decodedToken = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  bool isTokenExpired() {
    final token = _decodedToken;
    if (token == null) return true;
    return JwtDecoder.isExpired(token['exp'].toString());
  }
}
