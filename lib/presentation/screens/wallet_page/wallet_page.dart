import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../../core/widgets/tab.dart';
import '../../controllers/home_page_controller.dart';
import '../../controllers/wallet_page_controller.dart';
import '../../../core/widgets/wallet_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final homePageController = Provider.of<HomePageController>(context);
    //final walletPageController = Provider.of<WalletPageController>(context);
    return ChangeNotifierProvider(
      create: (context) => WalletPageController(vsync: this),
      child: Consumer<WalletPageController>(
          builder: (context, walletPageController, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        child: const Row(
                          children: [
                            Text('Wallet',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                )),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.grey[900]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      12), // Smoother corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.2), // Softer shadow for a clean look
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(
                                          0, 2), // Position shadow for depth
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Current Balance",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 23.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const Gap(20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/Naira.png',
                                          height: 20,
                                        ),
                                        const Gap(2, isHorizontal: true),
                                        Text(
                                          homePageController.walletBalance ??
                                              '0.0',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(20),
                                    const CustomButton(
                                      width: double.infinity,
                                      text: 'Withdraw Money',
                                      bgColor: Colors.black,
                                      borderColor: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(20),
                            TabBar(
                              controller: walletPageController.walletTab,
                              tabs: const [
                                TabWidget(name: 'Fund Transfer'),
                                TabWidget(name: 'Wallet Withdraw'),
                              ],
                              labelColor:
                                  Theme.of(context).colorScheme.onSurface,
                              unselectedLabelColor: Colors.grey,
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inconsolata',
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inconsolata',
                              ),
                              labelPadding: EdgeInsets.zero,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            const Gap(20),
                            SizedBox(
                              height:
                                  (400 / MediaQuery.of(context).size.height) *
                                      MediaQuery.of(context).size.height,
                              child: TabBarView(
                                controller: walletPageController.walletTab,
                                children: const [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        WalletCard(
                                            id: '111234',
                                            date: '2025-04-01 00:00:00',
                                            openingBalance: '[PaymentAddress]',
                                            closingBalance: 'Seller',
                                            paymentStatus: 'Pending',
                                            message: 'Fund Transfer',
                                            amount: 6000),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        WalletCard(
                                            id: '111234',
                                            date: '2025-04-01 00:00:00',
                                            openingBalance: '[PaymentAddress]',
                                            closingBalance: 'Seller',
                                            paymentStatus: 'Pending',
                                            message: 'Wallet Withdraw',
                                            amount: 6000),
                                      ],
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
