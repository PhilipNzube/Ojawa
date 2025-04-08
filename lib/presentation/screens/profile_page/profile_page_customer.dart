import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/auth_text_field.dart';
import '../../../core/widgets/custom_bg.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/filter.dart';
import '../../../core/widgets/logout_dialog.dart';
import '../../controllers/main_app_controllers.dart';
import '../../controllers/profile_page_controller.dart';
import '../../../main.dart';
import '../edit_profile/edit_profile_customer.dart';
import '../faq_page/faq_page.dart';
import 'widgets/profile_options.dart';

class ProfilePageCustomer extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfilePageCustomer({
    super.key,
    required this.goToProfilePage,
    required this.goToCategoriesPage,
    required this.goToOrdersPage,
    required this.onToggleDarkMode,
    required this.isDarkMode,
    // required this.scaffoldKey
  });

  @override
  _ProfilePageCustomerState createState() => _ProfilePageCustomerState();
}

class _ProfilePageCustomerState extends State<ProfilePageCustomer> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final profilePageController = Provider.of<ProfilePageController>(context);
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
                  // Header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            const Text('My Profile',
                                style: TextStyle(fontSize: 20)),
                            const Spacer(),
                            Container(
                              height:
                                  (40 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileCustomer(
                                        key: UniqueKey(),
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return const Color(0xFF1D4ED8);
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return Colors.white;
                                      }
                                      return const Color(0xFF1D4ED8);
                                    },
                                  ),
                                  elevation:
                                      WidgetStateProperty.all<double>(4.0),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2, color: Color(0xFF1D4ED8)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  Expanded(
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
                                      if (profilePageController.profileImage ==
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
                                              errorBuilder:
                                                  (context, error, stackTrace) {
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
                                              profilePageController.userName ??
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
                                            borderRadius: BorderRadius.circular(
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
                                              Image.asset('images/Wallet2.png',
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
                                                        '6,000.00',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: AbsorbPointer(
                          //     child: AuthTextField(
                          //       label: 'Name',
                          //       controller:
                          //           profilePageController.nameController,
                          //       focusNode: profilePageController.nameFocusNode,
                          //       labelFontSize: 16.0,
                          //       isPaddingActive: false,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.03),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: AbsorbPointer(
                          //     child: AuthTextField(
                          //       label: 'Email',
                          //       controller:
                          //           profilePageController.emailController,
                          //       focusNode: profilePageController.emailFocusNode,
                          //       labelFontSize: 16.0,
                          //       isPaddingActive: false,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.03),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: AbsorbPointer(
                          //     child: AuthTextField(
                          //       label: 'Phone Number',
                          //       controller:
                          //           profilePageController.phoneNumberController,
                          //       focusNode:
                          //           profilePageController.phoneNumberFocusNode,
                          //       labelFontSize: 16.0,
                          //       isPaddingActive: false,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.03),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: AbsorbPointer(
                          //     child: AuthTextField(
                          //       label: 'Location',
                          //       controller:
                          //           profilePageController.locationController,
                          //       focusNode:
                          //           profilePageController.locationFocusNode,
                          //       labelFontSize: 16.0,
                          //       isPaddingActive: false,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.03),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       'Gender',
                          //       style: TextStyle(
                          //         fontFamily: 'Poppins',
                          //         fontSize: 16.0,
                          //         fontWeight: FontWeight.bold,
                          //         color:
                          //             Theme.of(context).colorScheme.onSurface,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height:
                          //         MediaQuery.of(context).size.height * 0.03),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20.0),
                          //   child: AbsorbPointer(
                          //     child: Row(
                          //       children: [
                          //         Filter(
                          //             text: 'Male',
                          //             value: 1,
                          //             controllerMethod: profilePageController
                          //                 .setSelectedRadioValue,
                          //             controllerVariable: profilePageController
                          //                 .selectedRadioValue!),
                          //         SizedBox(
                          //             width: MediaQuery.of(context).size.width *
                          //                 0.05),
                          //         Filter(
                          //             text: 'Female',
                          //             value: 2,
                          //             controllerMethod: profilePageController
                          //                 .setSelectedRadioValue,
                          //             controllerVariable: profilePageController
                          //                 .selectedRadioValue!),
                          //         SizedBox(
                          //             width: MediaQuery.of(context).size.width *
                          //                 0.05),
                          //         Filter(
                          //             text: 'Other',
                          //             value: 3,
                          //             controllerMethod: profilePageController
                          //                 .setSelectedRadioValue,
                          //             controllerVariable: profilePageController
                          //                 .selectedRadioValue!)
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          CustomBg(
                            children: [
                              ProfileOptions(
                                title: 'Shop by Categories',
                                img: 'images/ShopCategories.png',
                                onTap: () {
                                  Provider.of<MainAppControllers>(context,
                                          listen: false)
                                      .goToCategoriesPage(context, 1);
                                },
                              ),
                              ProfileOptions(
                                title: 'My Orders',
                                img: 'images/My Orders.png',
                                onTap: () {
                                  Provider.of<MainAppControllers>(context,
                                          listen: false)
                                      .goToOrdersPage(context);
                                },
                              ),
                              const ProfileOptions(
                                title: 'Favorites',
                                img: 'images/Favorite.png',
                              ),
                            ],
                          ),
                          CustomBg(
                            children: [
                              ProfileOptions(
                                title: 'FAQ',
                                img: 'images/FAQ.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const FaqPage()),
                                  );
                                },
                              ),
                              const ProfileOptions(
                                title: 'Addresses',
                                img: 'images/Address.png',
                              ),
                              const ProfileOptions(
                                title: 'Saved Cards',
                                img: 'images/SavedCard.png',
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
                                      context, profilePageController.logout);
                                },
                              ),
                            ],
                          ),
                        ],
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
