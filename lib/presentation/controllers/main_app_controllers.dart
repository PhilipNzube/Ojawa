import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import '../screens/auth/sign_in_page.dart';
import 'navigation_controller.dart';

class MainAppControllers extends ChangeNotifier {
  int _selectedIndex = 0;
  final List<bool> _hasNotification = [false, false, false, false];
  DateTime? currentBackPressTime;
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  int? _userId;
  String? _userName;
  String? _profileImage;
  String? _email;
  String? _state;
  String? _phone;
  String? _gender;
  String? _role;
  bool _isLoading = false;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  int _selectedImageIndex = 0;
  String _userRole = "";

  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  MainAppControllers(
      {required this.onToggleDarkMode, required this.isDarkMode}) {
    initializePrefs();
    initialize();
  }

  //public getters
  String? get userName => _userName;
  String? get phone => _phone;
  int get selectedIndex => _selectedIndex;
  String? get profileImage => _profileImage;
  int get selectedImageIndex => _selectedImageIndex;
  String get userRole => _userRole;

  void initialize() async {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        //fetchUserProfile();
      }
    });
    // fetchUserProfile();
  }

  Future<void> initializePrefs() async {
    String? savedRole = await storage.read(key: 'userRole');
    if (savedRole != null) {
      _userRole = savedRole;
      //_userRole = "Vendor";
      notifyListeners();
      // print("From MainAppController: Done");
      // CustomSnackbar.show(
      //   'From MainAppController: Done',
      // );
    } else {
      _userRole = "Customer";
      notifyListeners();
      // CustomSnackbar.show(
      //   'From MainAppController: Not Done',
      // );
    }
  }

  Future<int?> getUserId() async {
    try {
      String? userIdString = await storage.read(key: 'userId');
      if (userIdString != null) {
        return int.tryParse(userIdString);
      }
    } catch (error) {
      print('Error retrieving userId: $error');
    }
    return null;
  }

  Future<void> fetchUserProfile() async {
    _userId = await getUserId();
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Users/$_userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userData = responseData['data'];
        _userName = userData['username'];
        _email = userData['email'];
        _state = userData['state'];
        _phone = userData['phone'];
        _gender = userData['gender'];
        _role = userData['role'];
        final profilePictureUrl =
            userData['profilePictureUrl']?.toString().trim();

        _profileImage =
            (profilePictureUrl != null && profilePictureUrl.isNotEmpty)
                ? '$profilePictureUrl/download?project=66e4476900275deffed4'
                : '';
        _isLoading = false;
        notifyListeners();

        print("Profile Loaded: ${response.body}");
        print("Profile Image URL: $_profileImage");
      } else {
        print('Error fetching profile: ${response.statusCode}');

        _isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkForToken() async {
    final accessToken = await storage.read(key: 'accessToken');
    return accessToken != null;
  }

  void goToCategoriesPage(BuildContext context, int selectedImageIndex) {
    _selectedIndex = 1;
    _selectedImageIndex = selectedImageIndex;
    notifyListeners();
    if (userRole == "Customer") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Vendor") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Logistics") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 5);
    }
  }

  void goToOrdersPage(BuildContext context) {
    if (userRole == "Customer") {
      _selectedIndex = 2;
    } else if (userRole == "Vendor") {
      _selectedIndex = 1;
    }
    notifyListeners();
    if (userRole == "Customer") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Vendor") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Logistics") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 5);
    }
  }

  void goToProfilePage(BuildContext context) {
    _selectedIndex = 3;
    notifyListeners();
    if (userRole == "Customer") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Vendor") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Logistics") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 5);
    }
  }

  void goToProductsPage(BuildContext context) {
    _selectedIndex = 2;
    notifyListeners();
    if (userRole == "Customer") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Vendor") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 3);
    } else if (userRole == "Logistics") {
      Provider.of<NavigationController>(context, listen: false)
          .changeTab(_selectedIndex, context, onToggleDarkMode, isDarkMode, 5);
    }
  }

  Future<void> logoutCall(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    _isLoading = true;
    notifyListeners();

    logout(context, onToggleDarkMode, isDarkMode);

    _isLoading = false;
    notifyListeners();
  }

  void logout(BuildContext context, dynamic Function(bool) onToggleDarkMode,
      bool isDarkMode) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      Navigator.pop(navigatorKey.currentContext!);
      CustomSnackbar.show(
        'You are not logged in.',
        isError: true,
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SignInPage(
      //         key: UniqueKey(),
      //         onToggleDarkMode: onToggleDarkMode,
      //         isDarkMode: isDarkMode),
      //   ),
      // );

      _isLoading = false;
      notifyListeners();
      return;
    }
    await storage.delete(key: 'userRole');
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'userId');
    await prefs.remove('userName');
    // await prefs.remove('user');

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => SignInPage(
            key: UniqueKey(),
            onToggleDarkMode: onToggleDarkMode,
            isDarkMode: isDarkMode),
      ),
    );
    _isLoading = false;
    notifyListeners();
  }
}
