import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../core/widgets/error_dialog.dart';
import '../../core/widgets/no_internet_dialog.dart';
import '../../core/widgets/time_out_error_dialog.dart';
import '../../main.dart';
import '../screens/auth/sign_in_page.dart';

import '../screens/my_cart/my_cart.dart';

class HomePageController extends ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List _searchResults = [];
  bool _searchLoading = false;
  bool _isSearching = false;
  List<String> _imagePaths = [
    "images/Banner.png",
    "images/Banner.png",
    "images/Banner.png",
  ];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  Map<String, bool> _isLikedMap = {};
  int? _selectedRadioValue = 0;
  final storage = const FlutterSecureStorage();
  ValueNotifier<String?> _selectedFilter = ValueNotifier<String?>(null);
  bool _isFilterActive = false;
  int? userId;
  String? _userName;
  String? _profileImage;
  String? _email;
  String? _state;
  String? _phone;
  String? _gender;
  String? _role;
  List<Map<String, dynamic>> products = [];
  bool _isLoading = false;
  late SharedPreferences prefs;
  Timer? _timer;
  int _remainingTime = 0;
  bool _isLoading2 = false;
  bool _isRefreshing = false;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late ScrollController _scrollController;
  int pageNum = 1;
  bool _isFetchingMore = false;
  String _userRole = "";
  String _url = "";
  bool _isMoved = false;
  bool _isLoggedOut = false;
  // late Future<void> _userData;

  HomePageController() {
    initialize();
  }

  //public getters
  String? get userName => _userName;
  String? get phone => _phone;
  String? get email => _email;
  String? get profileImage => _profileImage;
  String? get state => _state;
  String? get gender => _gender;
  String? get role => _role;
  int get remainingTime => _remainingTime;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;
  bool get isLoading2 => _isLoading2;
  bool get searchLoading => _searchLoading;
  List<dynamic> get searchResults => _searchResults;
  int get current => _current;
  bool get isFetchingMore => _isFetchingMore;
  List<String> get imagePaths => _imagePaths;
  bool get isFilterActive => _isFilterActive;
  ValueNotifier<String?> get selectedFilter => _selectedFilter;
  int? get selectedRadioValue => _selectedRadioValue;
  String get userRole => _userRole;
  bool get isMoved => _isMoved;
  bool get isLoggedOut => _isLoggedOut;
  // Future<void> get userData => _userData;

  TextEditingController get searchController => _searchController;
  CarouselController get controller => _controller;
  ScrollController get scrollController => _scrollController;

  FocusNode get searchFocusNode => _searchFocusNode;

  void refreshController() {
    notifyListeners();
  }

  void setIsLoggedOut(bool value) {
    _isLoggedOut = value;
    notifyListeners();
  }

  void setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  void setCurrent(int value) {
    _current = value;
    notifyListeners();
  }

  void setIsFilterActive(bool value) {
    _isFilterActive = value;
    notifyListeners();
  }

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void setIsMoved(bool value) {
    _isMoved = value;
    notifyListeners();
  }

  void initialize() async {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    await initializePrefs();
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // _userData = fetchUserProfile();
        fetchUserProfile();
        if (products.isEmpty) {
          fetchProducts(overwrite: true);
        }
      }
    });
    _remainingTime =
        11 * 3600 + 15 * 60 + 4; // Example: 11 hours, 15 minutes, 4 seconds
    _startTimer();
    // _userData = fetchUserProfile();
    fetchUserProfile();
    fetchProducts(overwrite: true);
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    String? savedRole = await storage.read(key: 'userRole');
    if (savedRole != null) {
      _userRole = savedRole;
      notifyListeners();
    }
  }

  Future<bool> checkForToken() async {
    // Read the access token from secure storage
    final accessToken = await storage.read(key: 'accessToken');
    return accessToken != null; // Check if token exists
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        _timer?.cancel(); // Stop the timer when it reaches zero
      }
    });
  }

  void _onScroll() {
    //if (_scrollController.position.pixels >=
    //         _scrollController.position.maxScrollExtent &&
    //     !_isLoading2 &&
    //     !_isFetchingMore) {
    //   fetchMoreProducts(); // Trigger fetching more products
    // }
  }

  Future<void> fetchProducts({bool overwrite = false}) async {
    // Prevent multiple fetches by checking `_isLoading2`
    if (_isLoading2) return;

    _isLoading2 = true;
    notifyListeners();

    if (overwrite) {
      // Clear the existing products if overwriting
      products.clear();
      pageNum = 1; // Reset to the first page
    }

    await _fetchProductsForPage(pageNum);

    _isLoading2 = false;
    notifyListeners();
  }

  Future<void> fetchMoreProducts() async {
    if (_isFetchingMore) return; // Prevent multiple fetches

    _isFetchingMore = true;
    notifyListeners();

    pageNum++; // Increment the page number for the next set of products
    await _fetchProductsForPage(pageNum);

    _isFetchingMore = false;
    notifyListeners();
  }

  Future<void> _fetchProductsForPage(int page) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://ojawa-api.onrender.com/api/Products?page=$page';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        print('Response Data: $responseData');
        //_showResponseDialog(context, responseData);

        products.addAll(responseData.map((product) {
          String discount = product['hasDiscount'] == true
              ? '${product['discountRate']}% OFF'
              : '';
          String uptoDiscount = product['hasDiscount'] == true
              ? 'Upto ${product['discountRate']}% OFF'
              : '';
          return {
            'id': product['id'],
            'name': product['name'],
            'img': product['productImageUrl'],
            'details': product['description'],
            'amount': '\$${product['price']}',
            'slashedPrice': product['hasDiscount'] == true
                ? '\$${product['discountPrice']}'
                : '',
            'isInFavorite': product['isInFavorite'] ?? false,
            'discount': discount,
            'uptoDiscount': uptoDiscount,
            'starImg': 'images/Rating Icon.png',
            'rating': product['rating'].toString(),
            'rating2': '(0)',
            'hasDiscount': product['hasDiscount'],
          };
        }).toList());
        notifyListeners();
      } else {
        print('Error fetching products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
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

  Future<void> fetchUserProfile() async {
    _isLoading = false;
    notifyListeners();
    final String? accessToken = await storage.read(
        key: 'accessToken'); // Use the correct key for access token
    if (accessToken == null) {
      CustomSnackbar.show(
        'You are not logged in.',
        isError: true,
      );
      _isLoggedOut = true;
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
        _isLoggedOut = false;
        notifyListeners();
        final responseData = json.decode(response.body);

        // Access the user data from the nested "data" key
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

        _isLoading = false; // Set loading to false on error
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');

      _isLoading = false; // Set loading to false on exception
      notifyListeners();
    }
  }

  Future<void> performSearch(String query) async {
    _searchLoading = true;
    notifyListeners();
    final String? accessToken = await storage.read(key: 'accessToken');
    final url = 'https://signal.payguru.com.ng/api/search?query=$query';
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    // Perform GET request
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      _searchResults = jsonDecode(response.body);
      _searchLoading = false;
      notifyListeners();
    } else if (response.statusCode == 404) {
      _searchResults = [];
      _searchLoading = false;
      notifyListeners();
      CustomSnackbar.show(
        'No results found for the query.',
        isError: true,
      );
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      _searchResults = [];
      _searchLoading = false;
      notifyListeners();
      final errorMessage = jsonDecode(response.body)['message'];
      CustomSnackbar.show(
        errorMessage,
        isError: true,
      );
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
      _isLoggedOut = true;
      _isLoading = false;
      notifyListeners();
      return;
    }
    await storage.delete(key: 'accessToken');
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
    _isLoggedOut = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFavoriteStatus(
      BuildContext context,
      int productId,
      bool isFavorite,
      dynamic Function(bool) onToggleDarkMode,
      bool isDarkMode) async {
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
      _isLoggedOut = true;
      _isLoading = false;
      notifyListeners();
      return;
    }
    final url = 'https://ojawa-api.onrender.com/api/Favorites/$productId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode == 200) {
        print('Favorite status updated successfully.');
      } else {
        print(
            'Failed to update favorite status: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
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
        // _userData = fetchUserProfile();
        fetchUserProfile(),
        fetchProducts(overwrite: true),
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

  void loadCart(BuildContext context, dynamic Function(bool) onToggleDarkMode,
      bool isDarkMode) async {
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
      _isLoggedOut = true;
      _isLoading = false;
      notifyListeners();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCart(key: UniqueKey()),
      ),
    );
  }
}
