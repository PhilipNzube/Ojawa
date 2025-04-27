import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import 'home_page_controller.dart';

class EditProfileControllers extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  int? _selectedRadioValue = 1;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _taxNameController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _storeNameFocusNode = FocusNode();
  final FocusNode _storeUrlFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _latitudeFocusNode = FocusNode();
  final FocusNode _longitudeFocusNode = FocusNode();
  final FocusNode _taxNameFocusNode = FocusNode();
  final FocusNode _taxNumberFocusNode = FocusNode();
  String _phoneNumber = '';
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
  bool _isLoading2 = false;
  final ImagePicker _picker = ImagePicker();
  final double maxWidth = 360;
  final double maxHeight = 360;
  String _userRole = "";
  String _url = "";
  late SharedPreferences prefs;

  EditProfileControllers() {
    initialize();
  }

  //public getters
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
  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;
  int? get selectedRadioValue => _selectedRadioValue;
  String? get phoneNumber => _phoneNumber;

  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get locationController => _locationController;
  TextEditingController get addressController => _addressController;
  TextEditingController get storeNameController => _storeNameController;
  TextEditingController get storeUrlController => _storeUrlController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get latitudeController => _latitudeController;
  TextEditingController get longitudeController => _longitudeController;
  TextEditingController get taxNameController => _taxNameController;
  TextEditingController get taxNumberController => _taxNumberController;

  FocusNode get firstNameFocusNode => _firstNameFocusNode;
  FocusNode get lastNameFocusNode => _lastNameFocusNode;
  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get locationFocusNode => _locationFocusNode;
  FocusNode get addressFocusNode => _addressFocusNode;
  FocusNode get storeNameFocusNode => _storeNameFocusNode;
  FocusNode get storeUrlFocusNode => _storeUrlFocusNode;
  FocusNode get descriptionFocusNode => _descriptionFocusNode;
  FocusNode get latitudeFocusNode => _latitudeFocusNode;
  FocusNode get longitudeFocusNode => _longitudeFocusNode;
  FocusNode get taxNameFocusNode => _taxNameFocusNode;
  FocusNode get taxNumberFocusNode => _taxNumberFocusNode;

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

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
    //_isLoading = true;
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
      //_isLoading = false;
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
          _phoneController.text = phone ?? '';
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
        //_isLoading = false;
        notifyListeners();
        print("Profile Loaded: ${response.body}");
        print("Profile Image URL: $_profileImage");
      } else {
        print('Error fetching profile: ${response.statusCode}');

        //_isLoading = false; // Set loading to false on error
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');

      //_isLoading = false; // Set loading to false on exception
      notifyListeners();
    }
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

  Future<void> updateProfile() async {
    final String firstname = firstNameController.text.trim();
    final String lastname = lastNameController.text.trim();

    _isLoading = true;
    notifyListeners();

    try {
      final String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("No access token found.");
      }

      final response = await http.patch(
        Uri.parse('https://dev-server.ojawa.africa/api/v1/auth/update-profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'role': Provider.of<HomePageController>(navigatorKey.currentContext!,
                  listen: false)
              .userRole,
          'avatar': "test.png",
          'firstName': firstname,
          'lastName': lastname,
        }),
      );

      final responseData = json.decode(response.body);

      print('Response Data: $responseData');
      if (response.statusCode == 200) {
        // Attempt to parse the response only if it's not empty
        if (responseData.body.isNotEmpty) {
          try {
            final Map<String, dynamic> responseBody =
                jsonDecode(responseData.body);

            CustomSnackbar.show(
              'Profile updated successfully.',
              isError: false,
            );
          } catch (e) {
            print('Error parsing JSON: $e');
            print('Raw response: ${responseData.body}');
            throw FormatException("Invalid response format");
          }
        } else {
          throw FormatException("Empty response received");
        }
      } else {
        // Handle non-200 responses
        final String responseBody = responseData.body;
        if (responseBody.isNotEmpty) {
          final Map<String, dynamic> errorResponse = jsonDecode(responseBody);
          throw Exception(errorResponse['message'] ?? 'Unknown error occurred');
        } else {
          throw Exception('Unknown error occurred');
        }
      }
    } catch (e) {
      String errorMessage = 'Something went wrong. Please try again.';

      // Handle specific errors
      if (e is FormatException) {
        errorMessage = 'Invalid response from server.';
      } else if (e is http.ClientException) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e is SocketException) {
        errorMessage =
            'Unable to connect to the server. Please try again later.';
      }

      // Log the exact error for debugging
      print('Something went wrong. Error details: $e');

      // Show a professional error message to the user
      CustomSnackbar.show(
        errorMessage,
        isError: true,
      );
    } finally {
      // Stop the loading indicator

      _isLoading = false;
      notifyListeners();
    }
  }
}
