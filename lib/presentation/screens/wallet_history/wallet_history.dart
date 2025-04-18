import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_gap.dart';
import '../../controllers/home_page_controller.dart';
import '../../controllers/wallet_history_controllers.dart';
import 'widgets/history_cards.dart';

class WalletHistory extends StatefulWidget {
  const WalletHistory({super.key});

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final homePageController = Provider.of<HomePageController>(context);
    final walletHistoryController =
        Provider.of<WalletHistoryControllers>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
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
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text('Wallet History',
                              style: TextStyle(fontSize: 20)),
                          const Spacer(),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
                              color:
                                  isDarkMode ? Colors.grey[900] : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(12), // Smoother corners
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
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                const Gap(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                CustomButton(
                                  width: double.infinity,
                                  isLoading: walletHistoryController.isLoading,
                                  text: 'Withdraw Balance',
                                  bgColor: Colors.black,
                                  borderColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(40),
                        const HistoryCards(
                            id: '111234',
                            date: '2025-04-01 00:00:00',
                            paymentAddress: '[PaymentAddress]',
                            paymentType: 'Seller',
                            paymentStatus: 'Pending',
                            remark: '',
                            amount: 6000),
                        const HistoryCards(
                            id: '22234',
                            date: '2025-04-01 00:00:00',
                            paymentAddress: '[PaymentAddress]',
                            paymentType: 'Seller',
                            paymentStatus: 'Approved',
                            remark: '',
                            amount: 2000),
                        const HistoryCards(
                            id: '55534',
                            date: '2025-04-01 00:00:00',
                            paymentAddress: '[PaymentAddress]',
                            paymentType: 'Seller',
                            paymentStatus: 'Declined',
                            remark: '',
                            amount: 4000)
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
  }
}
