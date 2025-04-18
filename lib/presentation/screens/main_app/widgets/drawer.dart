import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/home_page_controller.dart';
import '../../../controllers/main_app_controllers.dart';
import '../../auth/sign_in_page.dart';
import '../../faq_page/faq_page.dart';

class MainAppDrawer extends StatelessWidget {
  final Function(BuildContext, int) goToCategoriesPage;
  final Function(BuildContext) goToOrdersPage;
  final Function(BuildContext) showLogoutDialog;
  final String? profileImage;
  final String? userName;
  final String? phone;
  // final Future<void> userData;
  final Future<bool> Function() checkForToken;
  final Function(BuildContext) goToProfilePage;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const MainAppDrawer({
    super.key,
    required this.goToCategoriesPage,
    required this.goToOrdersPage,
    required this.showLogoutDialog,
    required this.profileImage,
    required this.userName,
    required this.phone,
    // required this.userData,
    required this.checkForToken,
    required this.goToProfilePage,
    required this.onToggleDarkMode,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFEBEDEE)),
                child: _buildProfileSection(context),
              ),
              _buildListTile(
                context,
                title: 'Shop by Categories',
                imagePath: 'images/ShopCategories.png',
                onTap: () {
                  Navigator.pop(context);
                  goToCategoriesPage(
                      context,
                      Provider.of<MainAppControllers>(context, listen: false)
                          .selectedImageIndex);
                },
              ),
              _buildListTile(
                context,
                title: 'My Orders',
                imagePath: 'images/My Orders.png',
                onTap: () {
                  Navigator.pop(context);
                  goToOrdersPage(context);
                },
              ),
              _buildListTile(
                context,
                title: 'Favorites',
                imagePath: 'images/Favorite.png',
                onTap: () => Navigator.pop(context),
              ),
              _buildListTile(
                context,
                title: 'FAQ',
                imagePath: 'images/FAQ.png',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqPage()),
                  );
                },
              ),
              _buildListTile(
                context,
                title: 'Addresses',
                imagePath: 'images/Address.png',
                onTap: () => Navigator.pop(context),
              ),
              _buildListTile(
                context,
                title: 'Saved Cards',
                imagePath: 'images/SavedCard.png',
                onTap: () => Navigator.pop(context),
              ),
              _buildListTile(
                context,
                title: 'Terms and Conditions',
                imagePath: 'images/Terms.png',
                onTap: () => Navigator.pop(context),
              ),
              _buildListTile(
                context,
                title: 'Privacy Policy',
                imagePath: 'images/Privacy.png',
                onTap: () => Navigator.pop(context),
              ),
              _buildListTile(
                context,
                title: 'Log out',
                imagePath: 'images/Logout.png',
                onTap: () => showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool tokenExists = await checkForToken();
        Navigator.pop(context);
        if (tokenExists) {
          goToProfilePage(context);
        } else {
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
      },
      child: Row(children: [
        if (profileImage == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: Container(
              width: (35 / MediaQuery.of(context).size.width) *
                  MediaQuery.of(context).size.width,
              height: (35 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: Image.asset(
                'images/Profile.png',
                fit: BoxFit.cover,
              ),
            ),
          )
        else if (profileImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(55),
            child: Container(
              width: (35 / MediaQuery.of(context).size.width) *
                  MediaQuery.of(context).size.width,
              height: (35 / MediaQuery.of(context).size.height) *
                  MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: Image.network(
                profileImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                  ); // Fallback if image fails
                },
              ),
            ),
          ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FutureBuilder<void>(
            //   future: userData, // Function to check for token
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const CircularProgressIndicator(color: Colors.black);
            //     } else if (snapshot.hasData) {
            //       return Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             userName ?? "Loading...",
            //             style: const TextStyle(
            //               fontFamily: 'GolosText',
            //               fontSize: 16.0,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             ),
            //           ),
            //           Text(
            //             phone ?? "Loading...",
            //             style: const TextStyle(
            //               fontFamily: 'GolosText',
            //               fontSize: 16.0,
            //               color: Colors.black,
            //             ),
            //           ),
            //         ],
            //       );
            //     } else {
            //       return const Text(
            //         "Not Signed In",
            //         style: TextStyle(
            //           fontFamily: 'GolosText',
            //           fontSize: 16.0,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black,
            //         ),
            //       );
            //     }
            //   },
            // ),
            Consumer<HomePageController>(
              builder: (context, homePageController, child) {
                if (homePageController.isLoading) {
                  return const CircularProgressIndicator(color: Colors.black);
                } else if (homePageController.isLoggedOut == false &&
                    userName != null &&
                    phone != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? "Loading...",
                        style: const TextStyle(
                          fontFamily: 'GolosText',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        phone ?? "Loading...",
                        style: const TextStyle(
                          fontFamily: 'GolosText',
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text(
                    "Not Signed In",
                    style: TextStyle(
                      fontFamily: 'GolosText',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const Spacer(),
        const IconButton(
          icon: Icon(Icons.navigate_next, size: 30, color: Colors.black),
          onPressed: null,
        ),
      ]),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required String title,
      required String imagePath,
      required VoidCallback? onTap}) {
    return ListTile(
      leading: Image.asset(imagePath, height: 25),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'GolosText', fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
