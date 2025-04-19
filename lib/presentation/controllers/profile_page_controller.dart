import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../core/widgets/error_dialog.dart';
import '../../core/widgets/no_internet_dialog.dart';
import '../../core/widgets/time_out_error_dialog.dart';
import '../../main.dart';
import '../screens/auth/sign_in_page.dart';
import 'home_page_controller.dart';

class ProfilePageController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List searchResults = [];
  bool searchLoading = false;
  bool _isSearching = false;
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  int? _selectedRadioValue = 1;
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  int? userId;
  String? _fullName;
  String? _userName;
  String? _profileImage;
  String? _email;
  String? _address;
  String? _city;
  String? _state;
  String? _storeName;
  String? _storeWebsiteUrl;
  String? _storeDescription;
  String? _walletBalance;
  String? _phone;
  String? _gender;
  String? _role;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _userRole = "";
  String _url = "";

  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  ProfilePageController(
      {required this.onToggleDarkMode, required this.isDarkMode}) {
    initialize();
  }

  //public getters
  bool get isLoading => _isLoading;
  String? get fullName => _fullName;
  String? get userName => _userName;
  String? get phone => _phone;
  String? get email => _email;
  String? get profileImage => _profileImage;
  String? get address => _address;
  String? get city => _city;
  String? get state => _state;
  String? get storeName => _storeName;
  String? get storeWebsiteUrl => _storeWebsiteUrl;
  String? get storeDescription => _storeDescription;
  String? get walletBalance => _walletBalance;
  String? get gender => _gender;
  String? get role => _role;
  int? get selectedRadioValue => _selectedRadioValue;
  String get userRole => _userRole;

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get locationController => _locationController;

  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get phoneNumberFocusNode => _phoneNumberFocusNode;
  FocusNode get locationFocusNode => _locationFocusNode;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void initialize() async {
    await initializePrefs();
    fetchUserProfile();
  }

  Future<int?> getUserId() async {
    try {
      // Retrieve the userId from storage
      String? userIdString =
          await storage.read(key: 'userId'); // Use the correct key for userId
      if (userIdString != null) {
        return int.tryParse(userIdString); // Convert the string to an integer
      }
    } catch (error) {
      print('Error retrieving userId: $error');
    }
    return null; // Return null if userId is not found or an error occurs
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? savedRole = await storage.read(key: 'userRole');
    if (savedRole != null) {
      _userRole = savedRole;
      notifyListeners();
    }
  }

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    notifyListeners();
    final String? accessToken = await storage.read(
        key: 'accessToken'); // Use the correct key for access token
    if (accessToken == null) {
      /*
      CustomSnackbar.show(
        'You are not logged in.',
        isError: true,
      );
      */
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (_userRole == "Customer") {
      _url = "customer";
      notifyListeners();
    } else if (_userRole == "Vendor") {
      _url = "vendors";
      notifyListeners();
    } else if (_userRole == "Logistics") {
      _url = "logistics";
      notifyListeners();
    }
    userId =
        await getUserId(); // Assuming this retrieves the userId from Flutter Secure Storage
    final url =
        'https://ojawa-api.onrender.com/api/Users/$_url/$userId'; // Update the URL to the correct endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'text/plain',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        notifyListeners();
        final responseData = json.decode(response.body);

        // Access the user data from the nested "data" key
        final userData = responseData['data'];
        if (_userRole == "Customer") {
          _userName = userData['username'];
          _email = userData['email'];
          _state = userData['state'];
          _phone = userData['phone'];
          _gender = userData['gender'];

          _nameController.text = userName ?? '';
          _emailController.text = email ?? '';
          _phoneNumberController.text = phone ?? '';
          _locationController.text = state ?? '';

          if (gender != null) {
            if (gender!.toLowerCase() == 'male') {
              _selectedRadioValue = 1;
            } else if (gender!.toLowerCase() == 'female') {
              _selectedRadioValue = 2;
            } else {
              _selectedRadioValue = 3; // Other
            }
          }
          notifyListeners();
        } else if (_userRole == "Vendor") {
          _fullName = userData['fullName'];
          _userName = userData['username'];
          _email = userData['email'];
          _phone = userData['phone'];
          _address = userData['address'];
          _city = userData['city'];
          _state = userData['state'];
          _storeName = userData['storeName'];
          _storeWebsiteUrl = userData['storeWebsiteUrl'];
          _storeDescription = userData['storeDescription'];
          _walletBalance = userData['walletBalance'].toString();
          notifyListeners();
        } else if (_userRole == "Logistics") {
          _fullName = userData['fullName'];
          // _userName = userData['username'];
          _userName = userData['fullName'];
          _email = userData['email'];
          _phone = userData['phone'];
          _walletBalance = userData['walletBalance'].toString();
          notifyListeners();
        }
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

        _isLoading = false; // Set loading to false on error
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');

      _isLoading = false; // Set loading to false on exception
      notifyListeners();
    }
  }

  Future<void> logoutCall(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    logout(context);

    _isLoading = false;
    notifyListeners();
  }

  void logout(BuildContext context) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      CustomSnackbar.show(
        'You are not logged in.',
        isError: true,
      );
      // await prefs.remove('user');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(
              key: UniqueKey(),
              onToggleDarkMode: onToggleDarkMode,
              isDarkMode: isDarkMode),
        ),
      );

      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = true;
    await storage.delete(key: 'accessToken');
    // await prefs.remove('user');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(
            key: UniqueKey(),
            onToggleDarkMode: onToggleDarkMode,
            isDarkMode: isDarkMode),
      ),
    );
  }

  Future<void> refreshData(BuildContext context) async {
    _isRefreshing = true;
    notifyListeners();

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        showNoInternetDialog(context, refreshData);

        _isRefreshing = false;
        notifyListeners();
        return;
      }

      await Future.any([
        Future.delayed(const Duration(seconds: 15), () {
          throw TimeoutException('The operation took too long.');
        }),
        fetchUserProfile(),
      ]);
    } catch (e) {
      if (e is TimeoutException) {
        showTimeoutDialog(context, refreshData);
      } else {
        showErrorDialog(context, e.toString());
      }
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }
}
