import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_error_message.dart';
import '../../../core/widgets/product.dart';
import '../../../core/widgets/role_switcher_fab.dart';
import '../../controllers/home_page_controller.dart';
import '../top_categories_details/top_categories_details.dart';
import 'widgets/bottom_sheets/sort_by_sheet.dart';
import 'widgets/category.dart';
import 'widgets/deal.dart';
import '../../../core/widgets/filter_widget.dart';
import 'widgets/filter_option.dart';
import 'widgets/list.dart';
import 'widgets/time.dart';
import '../../../main.dart';

class HomePageCustomer extends StatefulWidget {
  final int selectedIndex;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePageCustomer(
      {super.key,
      required this.selectedIndex,
      required this.onToggleDarkMode,
      required this.isDarkMode,
      required this.goToOrdersPage,
      required this.goToCategoriesPage,
      required this.goToProfilePage,
      required this.scaffoldKey});

  @override
  State<HomePageCustomer> createState() => _HomePageCustomerState();
}

class _HomePageCustomerState extends State<HomePageCustomer>
    with TickerProviderStateMixin, RouteAware {
  @override
  Widget build(BuildContext context) {
    //final homePageController = Provider.of<HomePageController>(context);
    return ChangeNotifierProvider(
      create: (context) => HomePageController(),
      child: Consumer<HomePageController>(
          builder: (context, homePageController, child) {
        int hours = (homePageController.remainingTime ~/ 3600);
        int minutes = (homePageController.remainingTime % 3600) ~/ 60;
        int seconds = homePageController.remainingTime % 60;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            title: homePageController.isSearching
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              homePageController.setIsSearching(false);
                              homePageController.searchController.clear();
                            });
                          },
                          child: Image.asset(
                            'images/Back.png',
                            height: 55,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          widget.scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        'images/notification.png',
                        height: 22,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                      InkWell(
                        onTap: () {
                          homePageController.loadCart(context,
                              widget.onToggleDarkMode, widget.isDarkMode);
                        },
                        child: Image.asset(
                          'images/bag.png',
                          height: 22,
                        ),
                      ),
                    ],
                  ),
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: homePageController.searchController,
                      focusNode: homePageController.searchFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'What are you looking for?',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search,
                              color: Color(0xFF008000)),
                          onPressed: () {
                            if (homePageController
                                .searchController.text.isNotEmpty) {
                              homePageController.performSearch(
                                  homePageController.searchController.text
                                      .trim());
                            }
                          },
                        ),
                        suffixIcon: homePageController.isSearching
                            ? IconButton(
                                icon: Icon(Icons.close,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                onPressed: () {
                                  homePageController.searchController.clear();
                                  homePageController.setIsSearching(false);
                                },
                              )
                            : null,
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      onChanged: (value) {
                        setState(() {
                          homePageController.setIsSearching(true);
                        });
                      },
                    ),
                  ),
                  if (homePageController.isSearching) ...[
                    if (homePageController.searchLoading) ...[
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onSurface,
                          ), // Use primary color
                          strokeWidth: 4.0,
                        ),
                      )
                    ] else ...[
                      if (homePageController.searchResults.isNotEmpty) ...[
                        ListView.builder(
                          itemCount: homePageController.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                homePageController.searchResults[index]
                                        ['title'] ??
                                    'No Title',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                homePageController.searchResults[index]
                                        ['description'] ??
                                    'No Description',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            );
                          },
                        )
                      ] else ...[
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/NotFound.png',
                                    height: 300,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No results to display',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                    ]
                  ] else ...[
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          homePageController.refreshData(context);
                        },
                        color: Theme.of(context).colorScheme.onSurface,
                        child: ListView(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Categories',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      widget.goToCategoriesPage(context, 0);
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      widget.goToCategoriesPage(context, 0);
                                    },
                                    child: const Category(
                                        img: 'images/Fashion.png',
                                        text: 'Fashion'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      widget.goToCategoriesPage(context, 1);
                                    },
                                    child: const Category(
                                        img: 'images/Electronics.png',
                                        text: 'Electronics'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      widget.goToCategoriesPage(context, 2);
                                    },
                                    child: const Category(
                                        img: 'images/Appliances.png',
                                        text: 'Appliances'),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      widget.goToCategoriesPage(context, 3);
                                    },
                                    child: const Category(
                                        img: 'images/Beauty.png',
                                        text: 'Beauty'),
                                  ),
                                  // Category(img:'images/Furniture.png', text:'Furniture'),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  enlargeCenterPage: false,
                                  viewportFraction: 1.0,
                                  enableInfiniteScroll: false,
                                  initialPage: 0,
                                  onPageChanged: (index, reason) {
                                    homePageController.setCurrent(index);
                                  },
                                ),
                                carouselController:
                                    homePageController.controller,
                                items:
                                    homePageController.imagePaths.map((item) {
                                  return Image.asset(
                                    item,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  );
                                }).toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                homePageController.imagePaths.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Image.asset(
                                    homePageController.current == index
                                        ? "images/Elipses_active.png"
                                        : "images/Elipses.png",
                                    width: (10 /
                                            MediaQuery.of(context).size.width) *
                                        MediaQuery.of(context).size.width,
                                    height: (10 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
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
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04),
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 16.0, horizontal: 10.0),
                                    //   decoration: const BoxDecoration(
                                    //     color: Color(0xFFFFFFFF),
                                    //     borderRadius: BorderRadius.all(
                                    //       Radius.circular(5.0),
                                    //     ),
                                    //   ),
                                    //   child: Column(
                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                    //     children: [
                                    //       deal('images/Img1.png', 'Running shoes',
                                    //           'Upto 40% OFF'),
                                    //       deal('images/Img2.png', 'Sneakers',
                                    //           '40-60% OFF'),
                                    //       deal('images/Img3.png', 'Wrist Watches',
                                    //           'Upto 40% OFF'),
                                    //       deal('images/Img4.png',
                                    //           'Bluetooth Speakers', '40-60% OFF'),
                                    //     ],
                                    //   ),
                                    // ),

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
                                                  discount:
                                                      product['discount']!,
                                                  starImg: product['starImg']!,
                                                  rating: product['rating']!,
                                                  rating2: product['rating2']!,
                                                  text2:
                                                      product['uptoDiscount'],
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
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Hot Selling Footwear',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
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
                                                  discountOnly: false,
                                                  onToggleDarkMode:
                                                      widget.onToggleDarkMode,
                                                  isDarkMode:
                                                      widget.isDarkMode),
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
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       hot(
                            //           'images/Img1.png',
                            //           'Adidas white sneakers for men',
                            //           '\$68',
                            //           '\$136',
                            //           '50% OFF',
                            //           'images/Rating Icon.png',
                            //           '4.8',
                            //           '(692)'),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.62,
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
                                            onNotification: (ScrollNotification
                                                scrollInfo) {
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
                                                    details:
                                                        product['details']!,
                                                    amount: product['amount']!,
                                                    slashedPrice: product[
                                                        'slashedPrice']!,
                                                    discount:
                                                        product['discount']!,
                                                    starImg:
                                                        product['starImg']!,
                                                    rating: product['rating']!,
                                                    rating2:
                                                        product['rating2']!,
                                                    liked:
                                                        product['isInFavorite'],
                                                    onToggleDarkMode:
                                                        widget.onToggleDarkMode,
                                                    isDarkMode:
                                                        widget.isDarkMode,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Recommended for you',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
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
                                                  discountOnly: false,
                                                  onToggleDarkMode:
                                                      widget.onToggleDarkMode,
                                                  isDarkMode:
                                                      widget.isDarkMode),
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
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       hot(
                            //           'images/Img2.png',
                            //           'Allen Solly Regular fit cotton shirt',
                            //           '\$35',
                            //           '\$40.25',
                            //           '15% OFF',
                            //           'images/Rating Icon.png',
                            //           '4.4',
                            //           '(412)'),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.62,
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
                                            onNotification: (ScrollNotification
                                                scrollInfo) {
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
                                                  .length, // Set to products.length, no extra item for loader
                                              itemBuilder: (context, index) {
                                                final product = homePageController
                                                        .products[
                                                    index]; // Access product at current index
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
                                                    details:
                                                        product['details']!,
                                                    amount: product['amount']!,
                                                    slashedPrice: product[
                                                        'slashedPrice']!,
                                                    discount:
                                                        product['discount']!,
                                                    starImg:
                                                        product['starImg']!,
                                                    rating: product['rating']!,
                                                    rating2:
                                                        product['rating2']!,
                                                    liked:
                                                        product['isInFavorite'],
                                                    onToggleDarkMode:
                                                        widget.onToggleDarkMode,
                                                    isDarkMode:
                                                        widget.isDarkMode,
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
              // RoleSwitcherFab(
              //   onPressed: () {
              //     Provider.of<HomePageController>(navigatorKey.currentContext!,
              //             listen: false)
              //         .switchRoleToCustomer(
              //             widget.onToggleDarkMode, widget.isDarkMode);
              //   },
              // ),
            ],
          ),
        );
      }),
    );
  }
}
