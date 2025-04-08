import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/widgets/custom_snackbar.dart';
import '../../core/widgets/error_dialog.dart';
import '../../core/widgets/no_internet_dialog.dart';
import '../../core/widgets/time_out_error_dialog.dart';

class MyCartController extends ChangeNotifier {
  bool _isLoading = false;
  int? _selectedRadioValue = 0;
  bool _isCouponEnabled = false;

  List<Map<String, dynamic>> _cartItems = [];
  final storage = const FlutterSecureStorage();
  double _sumPrice = 0.0;
  double _sumDiscount = 0.0;
  double _totalWithDiscount = 0.0;
  double _total = 0.0;

  bool _isRefreshing = false;

  MyCartController() {
    initialize();
  }

  //public getters
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  double get total => _total;
  double get sumDiscount => _sumDiscount;
  bool get isCouponEnabled => _isCouponEnabled;
  double get totalWithDiscount => _totalWithDiscount;
  int? get selectedRadioValue => _selectedRadioValue;

  void setSelectedRadioValue(int value) {
    _selectedRadioValue = value;
    notifyListeners();
  }

  void initialize() {
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    _isLoading = true;
    notifyListeners();
    final String? accessToken = await storage.read(key: 'accessToken');
    const String url = 'https://ojawa-api.onrender.com/api/Carts';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'text/plain',
        },
      );

      final responseData = json.decode(response.body);
      print('Response Data: $responseData');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Extract `cartItems` from the response
        final cartData = responseData['data']; // Access `data` key first
        final cartItemsData =
            cartData['cartItems'] as List<dynamic>; // Get `cartItems`

        _cartItems = cartItemsData.map((item) {
          return {
            'id': item['cartItemId'],
            'productId': item['productId'],
            'quantity': item['quantity'],
            'discount': item['discountRate'],
            'details': item['productName'],
            'amount': item['price'],
            'slashedPrice': item['discountPrice'],
            'img': item['imageUrl'] ??
                '', // Add this if the API provides image URLs
          };
        }).toList();
        _isLoading = false;
        notifyListeners();
        calculateCartSummary();
      } else {
        _isLoading = false;
        notifyListeners();
        CustomSnackbar.show(
          'Failed to load cart items',
          isError: true,
        );
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      print('An error occurred: $error');

      CustomSnackbar.show(
        'An error occurred',
        isError: true,
      );
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    final String url = 'https://ojawa-api.onrender.com/api/Carts/$cartItemId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      final responseData = json.decode(response.body);
      print('Response Data: $responseData');
      if (response.statusCode == 200) {
        _cartItems.removeWhere((item) => item['id'] == cartItemId);
        calculateCartSummary();
        notifyListeners();
        CustomSnackbar.show(
          'Item removed from cart',
          isError: false,
        );
      } else {
        CustomSnackbar.show(
          'Failed to remove item from cart.',
          isError: true,
        );
      }
    } catch (error) {
      print('An error occurred: $error');
      CustomSnackbar.show(
        'An error occurred',
        isError: true,
      );
    }
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    final String? accessToken = await storage.read(key: 'accessToken');
    const String url = 'https://ojawa-api.onrender.com/api/Carts';
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'productId': productId,
          'quantity': newQuantity,
        }),
      );
      final responseData = json.decode(response.body);
      print('Response Data: $responseData');
      if (response.statusCode == 200) {
        // Update the quantity in the local list

        final index =
            _cartItems.indexWhere((item) => item['productId'] == productId);
        if (index != -1) {
          _cartItems[index]['quantity'] = newQuantity;
        }
        notifyListeners();
        CustomSnackbar.show(
          'Quantity updated successfully',
          isError: false,
        );
      } else {
        CustomSnackbar.show(
          'Failed to update quantity.',
          isError: true,
        );
      }
    } catch (error) {
      print('An error occurred: $error');
      CustomSnackbar.show(
        'An error occurred',
        isError: true,
      );
    }
  }

  void calculateCartSummary() {
    _sumPrice = _cartItems.fold(0.0, (sum, item) => sum + item['amount']);
    _sumDiscount = _cartItems.fold(0.0, (sum, item) => sum + item['discount']);
    _totalWithDiscount = _cartItems.fold(
        0.0, (sum, item) => sum + (item['amount'] - item['discount']));
    _total = _sumPrice + 8;

    print('Sum of Prices: $_sumPrice');
    print('Sum of Discounts: $_sumDiscount');
    print('Total (Prices + 8): $_total');
    print('Total with Discounts Applied: $_totalWithDiscount');
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
        fetchCartItems(),
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
