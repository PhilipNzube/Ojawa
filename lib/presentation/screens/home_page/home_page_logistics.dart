import 'package:flutter/material.dart' hide CarouselController;
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_bg.dart';
import '../../../core/widgets/role_switcher_fab.dart';
import '../../controllers/home_page_controller.dart';
import 'widgets/bottom_sheets/sort_by_sheet.dart';
import '../../../core/widgets/filter_widget.dart';
import 'widgets/filter_option.dart';
import 'widgets/list.dart';
import 'widgets/second_set_user_details.dart';
import '../../../core/widgets/custom_gap.dart';

class HomePageLogistics extends StatefulWidget {
  final int selectedIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePageLogistics({
    super.key,
    required this.selectedIndex,
    required this.onToggleDarkMode,
    required this.isDarkMode,
    required this.goToOrdersPage,
    required this.goToCategoriesPage,
    required this.goToProfilePage,
    // required this.scaffoldKey
  });

  @override
  State<HomePageLogistics> createState() => _HomePageLogisticsState();
}

class _HomePageLogisticsState extends State<HomePageLogistics>
    with TickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    //final homePageController = Provider.of<HomePageController>(context);
    return ChangeNotifierProvider(
      create: (context) => HomePageController(),
      child: Consumer<HomePageController>(
          builder: (context, homePageController, child) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Flexible(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        homePageController.refreshData(context);
                      },
                      color: Theme.of(context).colorScheme.onSurface,
                      child: ListView(
                        children: [
                          CustomBg(
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 6,
                                    child: Text(
                                      'Accepting Pick-Ups',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: homePageController.isMoved,
                                    onChanged: (value) {
                                      homePageController.setIsMoved(value);
                                    }, // Toggle the dark mode
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(25),
                          Column(
                            children: [
                              SecondSetUserDetails(
                                context,
                                title: 'Total Earnings',
                                img: 'images/Total Earnings.png',
                                value: 4000000000,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Complete',
                                img: 'images/Complete.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Cancel',
                                img: 'images/Cancel2.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Pending',
                                img: 'images/Pending.png',
                                value: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (homePageController.searchResults.isNotEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          homePageController.setIsFilterActive(true);
                        },
                        child: const FilterWidget(
                            img: 'images/Filter.png', text: 'Filter'),
                      ),
                      InkWell(
                        onTap: () {
                          sortBy(context);
                        },
                        child: const FilterWidget(
                            img: 'images/sort.png', text: 'Sort By'),
                      ),
                    ],
                  ),
                ),
              if (homePageController.isFilterActive)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFFFFFFFF),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            homePageController
                                                .setIsFilterActive(false);
                                          });
                                        },
                                        child: Image.asset(
                                          'images/Cancel.png',
                                          height: 30,
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'CLEAR ALL',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: (150 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (440 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 0.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF808080),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const ListWidget(
                                              text: 'Brand', value: 1),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          const ListWidget(
                                              text: 'Size', value: 2),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          const ListWidget(
                                              text: 'Category', value: 3),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          const ListWidget(
                                              text: 'Bundles', value: 4),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          const ListWidget(
                                              text: 'Price Range', value: 5),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          const ListWidget(
                                              text: 'Discount', value: 6),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04),
                                          const ListWidget(
                                              text: 'Rating', value: 7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05),
                                SizedBox(
                                  height: (440 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const FilterOption(text: "S"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "ML"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "XL"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "XXL"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "3XL"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "4XL"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "5XL"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "6XL"),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04),
                                        const FilterOption(text: "7XL"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 5,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: (55 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF1D4ED8);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
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
                                              width: 3,
                                              color: Color(0xFF1D4ED8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Clear All',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: (55 /
                                          MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.white;
                                          }
                                          return const Color(0xFF1D4ED8);
                                        },
                                      ),
                                      foregroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return const Color(0xFF1D4ED8);
                                          }
                                          return Colors.white;
                                        },
                                      ),
                                      elevation:
                                          WidgetStateProperty.all<double>(4.0),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 3,
                                              color: Color(0xFF1D4ED8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'View 12 Results',
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
              RoleSwitcherFab(
                onPressed: homePageController.switchRoleToCustomer,
              ),
            ],
          ),
        );
      }),
    );
  }
}
