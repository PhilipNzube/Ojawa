import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/order.dart';
import '../../controllers/orders_page_controller.dart';
import 'widgets/bottom_sheets/filter_by_sheet.dart';
import '../../../main.dart';

class OrdersPageCustomer extends StatefulWidget {
  final Function goToCategoriesPage;
  final Function goToOrdersPage;
  final Function goToProfilePage;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(bool) onToggleDarkMode;
  final bool isDarkMode;

  const OrdersPageCustomer(
      {super.key,
      required this.goToOrdersPage,
      required this.goToCategoriesPage,
      required this.goToProfilePage,
      required this.scaffoldKey,
      required this.onToggleDarkMode,
      required this.isDarkMode});

  @override
  _OrdersPageCustomerState createState() => _OrdersPageCustomerState();
}

class _OrdersPageCustomerState extends State<OrdersPageCustomer> {
  @override
  Widget build(BuildContext context) {
    //final ordersPageController = Provider.of<OrdersPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => OrdersPageController(
          onToggleDarkMode: widget.onToggleDarkMode,
          isDarkMode: widget.isDarkMode),
      child: Consumer<OrdersPageController>(
          builder: (context, ordersPageController, child) {
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
                                widget.scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            const Text('Orders',
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
                                  filterBy(
                                    context,
                                    ordersPageController.setSelectedRadioValue,
                                    ordersPageController.setSelectedRadioValue2,
                                    ordersPageController.selectedRadioValue!,
                                    ordersPageController.selectedRadioValue2!,
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'images/sort.png',
                                      height: 22,
                                      color: const Color(0xFF1D4ED8),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    const Text(
                                      "Filter",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.0,
                                        color: Color(0xFF1D4ED8),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: ordersPageController.searchController,
                      focusNode: ordersPageController.searchFocusNode,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Search Order',
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
                            if (ordersPageController
                                .searchController.text.isNotEmpty) {
                              ordersPageController.performSearch(
                                  ordersPageController.searchController.text
                                      .trim());
                            }
                          },
                        ),
                        suffixIcon: ordersPageController.isSearching
                            ? IconButton(
                                icon: Icon(Icons.close,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface), // White close icon
                                onPressed: () {
                                  ordersPageController.searchController.clear();
                                  ordersPageController.setIsSearching(false);
                                },
                              )
                            : null,
                      ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      onChanged: (value) {
                        ordersPageController.setIsSearching(true);
                      },
                    ),
                  ),
                  if (ordersPageController.isSearching) ...[
                    if (ordersPageController.searchLoading) ...[
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onSurface,
                          ), // Use primary color
                          strokeWidth: 4.0,
                        ),
                      )
                    ] else ...[
                      if (ordersPageController.searchResults.isNotEmpty) ...[
                        ListView.builder(
                          itemCount: ordersPageController.searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                ordersPageController.searchResults[index]
                                        ['title'] ??
                                    'No Title',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                ordersPageController.searchResults[index]
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
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/NoOrderFound.png',
                                  height: 200,
                                ),
                                const SizedBox(height: 20),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'No Orders Found!',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromARGB(113, 0, 0, 0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'Currently, you do not have any orders. When you order something, it will appear here',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(113, 0, 0, 0),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: (60 /
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return Colors.white;
                                            }
                                            return const Color(0xFF1D4ED8);
                                          },
                                        ),
                                        foregroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return const Color(0xFF1D4ED8);
                                            }
                                            return Colors.white;
                                          },
                                        ),
                                        elevation:
                                            WidgetStateProperty.all<double>(
                                                4.0),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Start Shopping',
                                        style: TextStyle(
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
                        ),
                      ]
                    ]
                  ] else ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            OrderWidget(
                              img: 'images/OrderReceived.png',
                              type: 'Order Received',
                              date: '21st December, 2024',
                              prodImg: "images/Img4.png",
                              prodDetails:
                                  "Allen Solly Regular fit cotton shirt",
                              prodSize: "L",
                              prodColor: "Black",
                              goToOrdersPage: widget.goToOrdersPage,
                              onToggleDarkMode: widget.onToggleDarkMode,
                              isDarkMode: widget.isDarkMode,
                            ),
                            OrderWidget(
                              img: 'images/OrderCancelled.png',
                              type: 'Order Cancelled',
                              date: '21st December, 2024',
                              prodImg: "images/Img4.png",
                              prodDetails:
                                  "Allen Solly Regular fit cotton shirt",
                              prodSize: "L",
                              prodColor: "Black",
                              goToOrdersPage: widget.goToOrdersPage,
                              onToggleDarkMode: widget.onToggleDarkMode,
                              isDarkMode: widget.isDarkMode,
                            ),
                            OrderWidget(
                              img: 'images/OrderDelivered.png',
                              type: 'Order Deleivered',
                              date: '21st December, 2024',
                              prodImg: "images/Img4.png",
                              prodDetails:
                                  "Allen Solly Regular fit cotton shirt",
                              prodSize: "L",
                              prodColor: "Black",
                              goToOrdersPage: widget.goToOrdersPage,
                              onToggleDarkMode: widget.onToggleDarkMode,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
