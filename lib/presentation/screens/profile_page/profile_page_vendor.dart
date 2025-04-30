import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/logout_dialog.dart';
import '../../controllers/main_app_controllers.dart';
import '../../controllers/profile_page_controller.dart';
import '../../controllers/session_controller.dart';
import '../add_new_product/add_new_product.dart';
import '../edit_profile/edit_profile_vendor.dart';
import '../manage_pickup_location/manage_pickup_location.dart';
import '../wallet_history/wallet_history.dart';
import 'widgets/profile_options.dart';
import '../../../core/widgets/custom_bg.dart';

class ProfilePageVendor extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfilePageVendor({
    super.key,
    required this.goToProfilePage,
    required this.goToCategoriesPage,
    required this.goToOrdersPage,
    required this.onToggleDarkMode,
    required this.isDarkMode,
    // required this.scaffoldKey
  });

  @override
  _ProfilePageVendorState createState() => _ProfilePageVendorState();
}

class _ProfilePageVendorState extends State<ProfilePageVendor> {
  @override
  Widget build(BuildContext context) {
    final sessionController = Provider.of<SessionController>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (context) => ProfilePageController(
          onToggleDarkMode: widget.onToggleDarkMode,
          isDarkMode: widget.isDarkMode),
      child: Consumer<ProfilePageController>(
          builder: (context, profilePageController, child) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        profilePageController.refreshData(context);
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      children: [
                                        if (profilePageController
                                                .profileImage ==
                                            null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            child: Container(
                                              width: (65 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              height: (65 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              color: Colors.grey,
                                              child: Image.asset(
                                                'images/Profile.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        else if (profilePageController
                                                .profileImage !=
                                            null)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            child: Container(
                                              width: (55 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                              height: (55 /
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              color: Colors.grey,
                                              child: Image.network(
                                                profilePageController
                                                    .profileImage!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey,
                                                  ); // Fallback if image fails
                                                },
                                              ),
                                            ),
                                          ),
                                        const Gap(5, isHorizontal: true),
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                profilePageController
                                                        .userName ??
                                                    'User',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                              const Gap(2),
                                              Text(
                                                profilePageController.email ??
                                                    'Loading...',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 6,
                                                right: 6,
                                                top: 10,
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                              color: isDarkMode
                                                  ? Colors.grey[900]
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // Smoother corners
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(
                                                      0.2), // Softer shadow for a clean look
                                                  spreadRadius: 2,
                                                  blurRadius: 8,
                                                  offset: const Offset(0,
                                                      2), // Position shadow for depth
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    'images/Wallet2.png',
                                                    height: 20),
                                                const Gap(
                                                  10,
                                                  isHorizontal: true,
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        'images/Naira.png',
                                                        height: 15,
                                                      ),
                                                      const Gap(2,
                                                          isHorizontal: true),
                                                      Flexible(
                                                        child: Text(
                                                          profilePageController
                                                                  .walletBalance ??
                                                              '0.0',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
                            CustomBg(
                              children: [
                                ProfileOptions(
                                  title: 'Edit Profile',
                                  img: 'images/Edit Profile.png',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfileVendor(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ProfileOptions(
                                  title: 'Orders',
                                  img: 'images/Orders2.png',
                                  onTap: () {
                                    Provider.of<MainAppControllers>(context,
                                            listen: false)
                                        .goToOrdersPage(context);
                                  },
                                ),
                                const ProfileOptions(
                                  title: 'Chat',
                                  img: 'images/Chat.png',
                                ),
                              ],
                            ),
                            CustomBg(
                              children: [
                                ProfileOptions(
                                  title: 'Wallet History',
                                  img: 'images/Wallet History.png',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WalletHistory(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ProfileOptions(
                                    title: 'Products',
                                    img: 'images/Products2.png',
                                    onTap: () {
                                      Provider.of<MainAppControllers>(context,
                                              listen: false)
                                          .goToProductsPage(context);
                                    }),
                                ProfileOptions(
                                  title: 'Add New Products',
                                  img: 'images/Add New Products.png',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddNewProduct(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ProfileOptions(
                                  title: 'Manage PickUp Location',
                                  img: 'images/Manage PickUp Location.png',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ManagePickupLocation(
                                          key: UniqueKey(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const ProfileOptions(
                                  title: 'Stock Management',
                                  img: 'images/Stock Management.png',
                                ),
                              ],
                            ),
                            const CustomBg(
                              children: [
                                ProfileOptions(
                                  title: 'Change Language',
                                  img: 'images/Change Language.png',
                                ),
                                ProfileOptions(
                                  title: 'Terms and Conditions',
                                  img: 'images/Terms and Conditions.png',
                                ),
                                ProfileOptions(
                                  title: 'Privacy Policy',
                                  img: 'images/Privacy Policy.png',
                                ),
                              ],
                            ),
                            const CustomBg(
                              children: [
                                ProfileOptions(
                                  title: 'Contact Us',
                                  img: 'images/Contact Us.png',
                                ),
                                ProfileOptions(
                                  title: 'Return Policy',
                                  img: 'images/Return Policy.png',
                                ),
                                ProfileOptions(
                                  title: 'Shipping Policy',
                                  img: 'images/Shipping Policy.png',
                                ),
                              ],
                            ),
                            CustomBg(
                              children: [
                                const ProfileOptions(
                                  title: 'Delete Account',
                                  img: 'images/Delete Account.png',
                                ),
                                ProfileOptions(
                                  title: 'Logout',
                                  img: 'images/Logout2.png',
                                  onTap: () {
                                    showLogoutDialog(
                                        context,
                                        (context) => sessionController.logout(
                                            context,
                                            widget.onToggleDarkMode,
                                            widget.isDarkMode));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
