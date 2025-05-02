import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'presentation/controllers/add_new_card_controller.dart';
import 'presentation/controllers/add_new_product_controller.dart';
import 'presentation/controllers/add_pickup_location_controllers.dart';
import 'presentation/controllers/apply_coupon_controller.dart';
import 'presentation/controllers/categories_details_controller.dart';
import 'presentation/controllers/edit_profile_controllers.dart';
import 'presentation/controllers/exchange_order2_controller.dart';
import 'presentation/controllers/exchange_order_controller.dart';
import 'presentation/controllers/faq_page_controller.dart';
import 'presentation/controllers/home_page_controller.dart';
import 'presentation/controllers/manage_pickup_location_controllers.dart';
import 'presentation/controllers/my_cart_controller.dart';
import 'presentation/controllers/navigation_controller.dart';
import 'presentation/controllers/new_account_controller.dart';
import 'presentation/controllers/new_address_controller.dart';
import 'presentation/controllers/notification_controller.dart';
import 'presentation/controllers/order_details_controller.dart';
import 'presentation/controllers/payment_method_controller.dart';
import 'presentation/controllers/return_order2_controller.dart';
import 'presentation/controllers/return_order_controller.dart';
import 'presentation/controllers/session_controller.dart';
import 'presentation/controllers/sign_in_controller.dart';
import 'presentation/controllers/sign_up_controller.dart';
import 'presentation/controllers/sucessful_order_page_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/controllers/verify_email_controller.dart';
import 'presentation/controllers/wallet_history_controllers.dart';
import 'presentation/screens/intro_page/intro_page.dart';
import 'presentation/screens/main_app/main_app.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'yarnAccessToken');

  final bool isLoggedIn = accessToken != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EditProfileControllers()),
        ChangeNotifierProvider(create: (_) => ExchangeOrderController()),
        ChangeNotifierProvider(create: (_) => ExchangeOrder2Controller()),
        ChangeNotifierProvider(create: (_) => FaqPageController()),
        ChangeNotifierProvider(create: (_) => HomePageController()),
        ChangeNotifierProvider(create: (_) => MyCartController()),
        ChangeNotifierProvider(create: (_) => NewAccountController()),
        ChangeNotifierProvider(create: (_) => NewAddressController()),
        ChangeNotifierProvider(create: (_) => OrderDetailsController()),
        ChangeNotifierProvider(create: (_) => PaymentMethodController()),
        ChangeNotifierProvider(create: (_) => ReturnOrderController()),
        ChangeNotifierProvider(create: (_) => ReturnOrder2Controller()),
        ChangeNotifierProvider(create: (_) => SucessfulOrderPageController()),
        ChangeNotifierProvider(create: (_) => NewAccountController()),
        ChangeNotifierProvider(create: (_) => AddNewCardController()),
        ChangeNotifierProvider(create: (_) => ApplyCouponController()),
        ChangeNotifierProvider(create: (_) => CategoriesDetailsController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => SignInController()),
        ChangeNotifierProvider(create: (_) => SignUpController()),
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(create: (_) => AddNewProductControllers()),
        ChangeNotifierProvider(create: (_) => WalletHistoryControllers()),
        ChangeNotifierProvider(
            create: (_) => ManagePickupLocationControllers()),
        ChangeNotifierProvider(create: (_) => AddPickupLocationControllers()),
        ChangeNotifierProvider(
          create: (context) {
            final themeController =
                Provider.of<ThemeController>(context, listen: false);
            return SessionController(
                onToggleDarkMode: themeController.toggleDarkMode,
                isDarkMode: themeController.isDarkMode);
          },
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
            title: 'Ojawa',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: isLoggedIn
                ? MainApp(
                    onToggleDarkMode: themeController.toggleDarkMode,
                    isDarkMode: themeController.isDarkMode)
                : IntroPage(
                    onToggleDarkMode: themeController.toggleDarkMode,
                    isDarkMode: themeController.isDarkMode),
          );
        },
      ),
    );
  }
}
