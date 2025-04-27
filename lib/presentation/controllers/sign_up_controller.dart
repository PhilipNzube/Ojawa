import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'dart:async';

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import '../screens/main_app/main_app.dart';
import '../screens/verify_email/verify_email.dart';
import 'home_page_controller.dart';
import 'navigation_controller.dart';

class SignUpController extends ChangeNotifier {
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _displayNameFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _storeNameFocusNode = FocusNode();
  final FocusNode _storeWebsiteUrlFocusNode = FocusNode();
  final FocusNode _storeDescriptionFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _password2FocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeWebsiteUrlController =
      TextEditingController();
  final TextEditingController _storeDescriptionController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  bool dropDownTapped = false;

  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  bool _isLoading = false;
  String phoneNumber = '';
  String localPhoneNumber = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedGender = 'Male';
  String _profileImage = '';
  final double maxWidth = 360;
  final double maxHeight = 360;
  final ImagePicker _picker = ImagePicker();
  String _selectedRole = 'Select Role';
  String _url = "";

  SignUpController() {
    _roleController.text = _selectedRole;
    initializePrefs();
  }

  //public getters
  GlobalKey<FormState> get formKey => _formKey;
  String get profileImage => _profileImage;
  String get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;

  FocusNode get firstNameFocusNode => _firstNameFocusNode;
  FocusNode get lastNameFocusNode => _lastNameFocusNode;
  FocusNode get fullNameFocusNode => _fullNameFocusNode;
  FocusNode get userNameFocusNode => _userNameFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get addressFocusNode => _addressFocusNode;
  FocusNode get cityFocusNode => _cityFocusNode;
  FocusNode get stateFocusNode => _stateFocusNode;
  FocusNode get countryFocusNode => _countryFocusNode;
  FocusNode get storeNameFocusNode => _storeNameFocusNode;
  FocusNode get storeWebsiteUrlFocusNode => _storeWebsiteUrlFocusNode;
  FocusNode get storeDescriptionFocusNode => _storeDescriptionFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get password2FocusNode => _password2FocusNode;
  FocusNode get roleFocusNode => _roleFocusNode;

  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get fullNameController => _fullNameController;
  TextEditingController get userNameController => _userNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get addressController => _addressController;
  TextEditingController get cityController => _cityController;
  TextEditingController get stateController => _stateController;
  TextEditingController get countryController => _countryController;
  TextEditingController get storeNameController => _storeNameController;
  TextEditingController get storeWebsiteUrlController =>
      _storeWebsiteUrlController;
  TextEditingController get storeDescriptioController =>
      _storeDescriptionController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get password2Controller => _password2Controller;
  TextEditingController get roleController => _roleController;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void resetSelectedRole() {
    _selectedRole = 'Select Role';
    notifyListeners();
  }

  void setSelectedRole(String value) {
    _selectedRole = value;
    roleController.text = value;
    notifyListeners();
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final decodedImage =
          await decodeImageFromList(imageFile.readAsBytesSync());

      if (decodedImage.width > maxWidth || decodedImage.height > maxHeight) {
        var cropper = ImageCropper();
        CroppedFile? croppedImage = await cropper.cropImage(
            sourcePath: imageFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                lockAspectRatio: false,
              ),
              IOSUiSettings(
                minimumAspectRatio: 1.0,
              ),
            ]);

        if (croppedImage != null) {
          _profileImage = croppedImage.path;
          notifyListeners();
        }
      } else {
        _profileImage = pickedFile.path;
        notifyListeners();
      }
    }
  }

  Future<void> registerUser(BuildContext context,
      dynamic Function(bool) onToggleDarkMode, bool isDarkMode) async {
    if (_selectedRole == "Customer") {
      _url = "customer/sign-up";
      notifyListeners();
    } else if (_selectedRole == "Vendor") {
      _url = "vendor/sign-up";
      notifyListeners();
    } else if (_selectedRole == "Logistics") {
      _url = "logistics/sign-up";
      notifyListeners();
    }
    print(_url);
    if (prefs == null) {
      await initializePrefs();
    }
    final String firstname = firstNameController.text.trim();
    final String lastname = lastNameController.text.trim();
    final String fullname = fullNameController.text.trim();
    final String username = userNameController.text.trim();
    final String email = emailController.text.trim();
    final String country = countryController.text.trim();
    final String address = addressController.text.trim();
    final String city = cityController.text.trim();
    final String state = stateController.text.trim();
    final String storename = storeNameController.text.trim();
    final String storeWebsiteUrl = storeWebsiteUrlController.text.trim();
    final String storeDescription = storeDescriptioController.text.trim();
    final String password = passwordController.text.trim();
    final String passwordConfirmation = password2Controller.text.trim();
    final String userRole = _roleController.text.trim();

    // if (state.isEmpty ||
    //     username.isEmpty ||
    //     email.isEmpty ||
    //     phoneNumber.isEmpty ||
    //     password.isEmpty ||
    //     passwordConfirmation.isEmpty ||
    //     userRole == 'Select Role') {
    //   CustomSnackbar.show(
    //     'All fields are required.',
    //     isError: true,
    //   );

    //   return;
    // }

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

    if (!_formKey.currentState!.validate()) {
      // Show a message if validation fails
      CustomSnackbar.show(
        'Please provide a valid phone number.',
        isError: true,
      );
      return;
    }
    // if (phoneNumber.length < 11) {
    //   _showCustomSnackBar(
    //     context,
    //     'Phone number must be at least 11 characters.',
    //     isError: true,
    //   );
    //
    //   return;
    // }

    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'phone': localPhoneNumber,
        'country': {"code": "NG", "name": "Nigeria", "mobileExt": "+234"},
        'role': _selectedRole,
      }),
    );

    final responseData = json.decode(response.body);

    print('Response Data: $responseData');

    if (response.statusCode == 200) {
      Provider.of<NavigationController>(navigatorKey.currentContext!,
              listen: false)
          .setSelectedIndex(0);
      final String accessToken = responseData['token'];
      final int userId = responseData['value']; // Extract userId from response

      await prefs.setString('userName', username);
      await storage.write(key: 'userRole', value: _selectedRole);
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(
          key: 'userId', value: userId.toString()); // Store userId as a string

      // Handle successful response
      CustomSnackbar.show(
        'Sign up successful!',
        isError: false,
      );

      // Navigate to the main app or another page
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
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String error = responseData['message'];

      if (error ==
          "Email account has not been verified. Kindly complete verification to sign up") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmail(
                key: UniqueKey(),
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
      _isLoading = false;
      notifyListeners();
      // Handle other unexpected responses
      CustomSnackbar.show(
        'Error: ${responseData['message']}',
        isError: true,
      );
    }
  }
}
