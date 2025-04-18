import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_back_handler.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../../../core/widgets/logout_dialog.dart';
// import '../../../main.dart';
import '../../controllers/home_page_controller.dart';
import '../../controllers/main_app_controllers.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/notification_controller.dart';
import '../cash_page/cash_page.dart';
import '../categories_page/categories_page.dart';
import '../home_page/home_page_customer.dart';
import '../home_page/home_page_logistics.dart';
import '../home_page/home_page_vendor.dart';
import '../my_delivery/my_delivery.dart';
import '../orders_page/orders_page_customer.dart';
import '../orders_page/orders_page_vendor.dart';
import '../products_page/products_page.dart';
import '../profile_page/profile_page_customer.dart';
import '../profile_page/profile_page_logistics.dart';
import '../profile_page/profile_page_vendor.dart';
import '../wallet_page/wallet_page.dart';
import 'widgets/drawer.dart';

class MainApp extends StatefulWidget {
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const MainApp(
      {super.key, required this.onToggleDarkMode, required this.isDarkMode});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  @override
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    //final homePageController = Provider.of<HomePageController>(context);
    final navController = Provider.of<NavigationController>(context);
    //final mainAppController = Provider.of<MainAppControllers>(context);
    final notificationController = Provider.of<NotificationController>(context);
    return ChangeNotifierProvider(
      create: (context) => MainAppControllers(
          onToggleDarkMode: widget.onToggleDarkMode,
          isDarkMode: widget.isDarkMode),
      child: Consumer<MainAppControllers>(
          builder: (context, mainAppController, child) {
        return ChangeNotifierProvider(
          create: (context) => HomePageController(),
          child: Consumer<HomePageController>(
              builder: (context, homePageController, child) {
            return CustomBackHandler(
              child: Scaffold(
                key: scaffoldKey,
                drawer: mainAppController.userRole == "Customer"
                    ? MainAppDrawer(
                        goToCategoriesPage:
                            mainAppController.goToCategoriesPage,
                        goToOrdersPage: mainAppController.goToOrdersPage,
                        showLogoutDialog: (context) => showLogoutDialog(
                            context,
                            (context) => homePageController.logoutCall(context,
                                widget.onToggleDarkMode, widget.isDarkMode)),
                        profileImage: homePageController.profileImage,
                        userName: homePageController.userName,
                        phone: homePageController.phone,
                        // userData: homePageController.userData,
                        checkForToken: mainAppController.checkForToken,
                        goToProfilePage: mainAppController.goToProfilePage,
                        onToggleDarkMode: widget.onToggleDarkMode,
                        isDarkMode: widget.isDarkMode,
                      )
                    : null,
                body: SafeArea(
                  child: IndexedStack(
                    index: navController.selectedIndex,
                    children: [
                      if (mainAppController.userRole == "Customer") ...[
                        HomePageCustomer(
                          selectedIndex: mainAppController.selectedIndex,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          scaffoldKey: scaffoldKey,
                        ),
                        CategoriesPage(
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          // scaffoldKey: scaffoldKey,
                          selectedImageIndex:
                              mainAppController.selectedImageIndex,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                        ),
                        OrdersPageCustomer(
                            goToCategoriesPage:
                                mainAppController.goToCategoriesPage,
                            goToOrdersPage: mainAppController.goToOrdersPage,
                            goToProfilePage: mainAppController.goToProfilePage,
                            scaffoldKey: scaffoldKey,
                            onToggleDarkMode: widget.onToggleDarkMode,
                            isDarkMode: widget.isDarkMode),
                        ProfilePageCustomer(
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                          scaffoldKey: scaffoldKey,
                        ),
                      ] else if (mainAppController.userRole == "Vendor") ...[
                        HomePageVendor(
                          selectedIndex: mainAppController.selectedIndex,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          // scaffoldKey: scaffoldKey,
                        ),
                        OrdersPageVendor(
                            goToCategoriesPage:
                                mainAppController.goToCategoriesPage,
                            goToOrdersPage: mainAppController.goToOrdersPage,
                            goToProfilePage: mainAppController.goToProfilePage,
                            // scaffoldKey: scaffoldKey,
                            onToggleDarkMode: widget.onToggleDarkMode,
                            isDarkMode: widget.isDarkMode),
                        ProductsPage(
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          // scaffoldKey: scaffoldKey,
                          selectedImageIndex:
                              mainAppController.selectedImageIndex,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                        ),
                        ProfilePageVendor(
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                          // scaffoldKey: scaffoldKey,
                        ),
                      ] else if (mainAppController.userRole == "Logistics") ...[
                        HomePageLogistics(
                          selectedIndex: mainAppController.selectedIndex,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          // scaffoldKey: scaffoldKey,
                        ),
                        const MyDelivery(),
                        const WalletPage(),
                        const CashPage(),
                        ProfilePageLogistics(
                          goToCategoriesPage:
                              mainAppController.goToCategoriesPage,
                          goToOrdersPage: mainAppController.goToOrdersPage,
                          goToProfilePage: mainAppController.goToProfilePage,
                          onToggleDarkMode: widget.onToggleDarkMode,
                          isDarkMode: widget.isDarkMode,
                          // scaffoldKey: scaffoldKey,
                        ),
                      ]
                    ],
                  ),
                ),
                bottomNavigationBar: CustomBottomNav(
                  hasNotification: notificationController.hasNotificationList,
                  onToggleDarkMode: widget.onToggleDarkMode,
                  isDarkMode: widget.isDarkMode,
                  userRole: mainAppController.userRole,
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
