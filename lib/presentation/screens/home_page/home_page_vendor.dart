import 'package:flutter/material.dart' hide CarouselController;
import 'package:ojawa/main.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_error_message.dart';
import '../../../core/widgets/product.dart';
import '../../../core/widgets/role_switcher_fab.dart';
import '../../controllers/home_page_controller.dart';
import '../top_categories_details/top_categories_details.dart';
import 'widgets/bottom_sheets/sort_by_sheet.dart';
import 'widgets/deal.dart';
import '../../../core/widgets/filter_widget.dart';
import 'widgets/filter_option.dart';
import 'widgets/list.dart';
import 'widgets/second_set_user_details.dart';
import 'widgets/time.dart';
import '../../../core/widgets/custom_gap.dart';
import 'widgets/user_details.dart';

class HomePageVendor extends StatefulWidget {
  final int selectedIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  // final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePageVendor({
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
  State<HomePageVendor> createState() => _HomePageVendorState();
}

class _HomePageVendorState extends State<HomePageVendor>
    with TickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    //final homePageController = Provider.of<HomePageController>(context);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (context) => HomePageController(),
      child: Consumer<HomePageController>(
          builder: (context, homePageController, child) {
        int hours = (homePageController.remainingTime ~/ 3600);
        int minutes = (homePageController.remainingTime % 3600) ~/ 60;
        int seconds = homePageController.remainingTime % 60;
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Hi, ${homePageController.userName ?? 'User'}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  'Total Sale:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'images/Naira.png',
                                      height: 20,
                                    ),
                                    const Gap(2, isHorizontal: true),
                                    Text(
                                      homePageController.walletBalance ?? '0.0',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Gap(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  UserDetails(
                                    title: 'Overall Rating',
                                    img: 'images/Overall Rating Star.png',
                                    value: 4.5,
                                  ),
                                  UserDetails(
                                    title: 'Total Products',
                                    img: 'images/Total Products.png',
                                    value: 1004,
                                  ),
                                  UserDetails(
                                    title: 'Total Orders',
                                    img: 'images/Total Orders.png',
                                    value: 500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(25),
                          Column(
                            children: [
                              SecondSetUserDetails(
                                context,
                                title: 'Confirmed',
                                img: 'images/Confirmed.png',
                                value: 4000000000,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Item On The Way',
                                img: 'images/On The Way.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Delivered',
                                img: 'images/Delivered.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Pending Delivery',
                                img: 'images/Pending Delivery.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Refunded',
                                img: 'images/Refunded.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'Scheduled',
                                img: 'images/Scheduled.png',
                                value: 5,
                              ),
                              SecondSetUserDetails(
                                context,
                                title: 'All',
                                img: 'images/All inclusive.png',
                                value: 29,
                              )
                            ],
                          ),
                          const Gap(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Earnings: \$0.00',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  'Commission Given: \$0.00',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(50),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 10.0),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBEDEE),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Deal of the day',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TopCategoriesDetails(
                                                      key: UniqueKey(),
                                                      discountOnly: true,
                                                      onToggleDarkMode: widget
                                                          .onToggleDarkMode,
                                                      isDarkMode:
                                                          widget.isDarkMode),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'View All',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF4444),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Time(
                                            hours: hours,
                                            minutes: minutes,
                                            seconds: seconds),
                                      ],
                                    ),
                                  ),
                                  const Gap(25),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: homePageController
                                            .isLoading2 // Check if loading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ) // Show loader while loading
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: homePageController
                                                .products
                                                .where((product) =>
                                                    product['hasDiscount'] ==
                                                    true) // Keep this line
                                                .map((product) {
                                              List<String> imgList = [];

                                              // Check if product['img'] is not null
                                              if (product['img'] != null) {
                                                if (product['img']
                                                    is List<String>) {
                                                  // If it's already a List<String>, use it directly
                                                  imgList = List<String>.from(
                                                      product['img']);
                                                } else if (product['img']
                                                    is String) {
                                                  // If it's a String, convert it to a List<String>
                                                  imgList = [
                                                    product['img']
                                                  ]; // Create a list with the single image
                                                }
                                              }

                                              // Append the download string to each image URL in imgList
                                              List<String> fullImgList =
                                                  imgList.map((img) {
                                                return '$img/download?project=677181a60009f5d039dd';
                                              }).toList();
                                              return Deal(
                                                itemId: product['id'],
                                                name: product['name']!,
                                                img: fullImgList,
                                                details: product['details']!,
                                                amount: product['amount']!,
                                                slashedPrice:
                                                    product['slashedPrice']!,
                                                discount: product['discount']!,
                                                starImg: product['starImg']!,
                                                rating: product['rating']!,
                                                rating2: product['rating2']!,
                                                text2: product['uptoDiscount'],
                                                onToggleDarkMode:
                                                    widget.onToggleDarkMode,
                                                isDarkMode: widget
                                                    .isDarkMode, // Discount text
                                              );
                                            }).toList(),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(50),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Text(
                                  'Top Selling Item',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TopCategoriesDetails(
                                                key: UniqueKey(),
                                                discountOnly: false,
                                                onToggleDarkMode:
                                                    widget.onToggleDarkMode,
                                                isDarkMode: widget.isDarkMode),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.62,
                              child: homePageController.isLoading2
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    )
                                  : homePageController.products.isEmpty
                                      ? CustomErrorMessage(
                                          text:
                                              'No products available at the moment.',
                                          onPressed: () => homePageController
                                              .fetchProducts(overwrite: true),
                                        )
                                      : NotificationListener<
                                          ScrollNotification>(
                                          onNotification:
                                              (ScrollNotification scrollInfo) {
                                            if (!homePageController
                                                    .isFetchingMore &&
                                                scrollInfo.metrics.pixels ==
                                                    scrollInfo.metrics
                                                        .maxScrollExtent) {
                                              // Trigger loading more products
                                              //fetchMoreProducts();
                                              return true;
                                            }
                                            return false;
                                          },
                                          child: ListView.builder(
                                            controller: homePageController
                                                .scrollController, // Attach the scroll controller
                                            scrollDirection: Axis.horizontal,
                                            itemCount: homePageController
                                                .products
                                                .length, // Set to products.length
                                            itemBuilder: (context, index) {
                                              final product = homePageController
                                                      .products[
                                                  index]; // Access product safely
                                              List<String> imgList = [];
                                              if (product['img'] != null) {
                                                if (product['img']
                                                    is List<String>) {
                                                  imgList = List<String>.from(
                                                      product['img']);
                                                } else if (product['img']
                                                    is String) {
                                                  imgList = [product['img']];
                                                }
                                              }
                                              List<String> fullImgList =
                                                  imgList.map((img) {
                                                return '$img/download?project=677181a60009f5d039dd';
                                              }).toList();

                                              return Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                margin: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: Product(
                                                  itemId: product['id'],
                                                  name: product['name']!,
                                                  img: fullImgList,
                                                  details: product['details']!,
                                                  amount: product['amount']!,
                                                  slashedPrice:
                                                      product['slashedPrice']!,
                                                  discount:
                                                      product['discount']!,
                                                  starImg: product['starImg']!,
                                                  rating: product['rating']!,
                                                  rating2: product['rating2']!,
                                                  liked:
                                                      product['isInFavorite'],
                                                  onToggleDarkMode:
                                                      widget.onToggleDarkMode,
                                                  isDarkMode: widget.isDarkMode,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            ),
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
                onPressed: () {
                  Provider.of<HomePageController>(navigatorKey.currentContext!,
                          listen: false)
                      .setCurrentRole("Customer");
                  Provider.of<HomePageController>(navigatorKey.currentContext!,
                          listen: false)
                      .setPreviousRole("Vendor");
                  Provider.of<HomePageController>(navigatorKey.currentContext!,
                          listen: false)
                      .switchRole(widget.onToggleDarkMode, widget.isDarkMode);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
