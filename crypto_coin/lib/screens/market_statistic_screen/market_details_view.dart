import 'package:crypto_coin/providers/marketStats.dart';
import 'package:crypto_coin/screens/home_screens/home_widgets/currency_dropDown.dart';
import 'package:crypto_coin/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_text.dart';
class MarketDetailsView extends StatefulWidget {

  const MarketDetailsView({super.key });

  @override
  State<MarketDetailsView> createState() => _MarketDetailsViewState();
}

class _MarketDetailsViewState extends State<MarketDetailsView> {

  String selectedCurrency = 'usd';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final marketProvider = context.read<MarketStatsProvider>();
      marketProvider.fetchMarketStatsDetails(selectedCurrency);
      marketProvider.fetchCurrency();
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 9,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()
                      {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios,color: Colors.black,)),
                  const Spacer(),
                  AppText(
                    text: 'Market Statistics',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),

                ],
              ),
            ),


            // Currency dropdown
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Consumer<MarketStatsProvider>(
                builder: (context, provider, child) {
                  return CurrencyDropdown(
                    selectedCurrency: selectedCurrency,
                    currencies: provider.currency,
                    onChanged: (currency) {
                      setState(() {
                        selectedCurrency = currency;
                      });

                      provider.fetchMarketStatsDetails(currency);
                    },
                  );
                },
              ),
            ),

            // Statistics content
            Expanded(
              child: Consumer<MarketStatsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF00D4FF)),
                    );
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final marketValue = provider.marketStats;

                  if (marketValue == null) {
                    return const Center(
                      child: Text(
                        'Market statistics unavailable!',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () => Navigator.pop(context),
                        //       child: const Icon(
                        //         Icons.arrow_back_ios,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //     const Expanded(
                        //       child: Center(
                        //         child: Text(
                        //           'Market Statistics',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 21,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 20),
                        //   ],
                        // ),

                        const SizedBox(height: 25),

                        const Text(
                          'Global Market Overview',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _statCard(
                          'Total Market Cap',
                          '${marketValue.totalMarketCap
                              .toInt()} ${selectedCurrency.toUpperCase()}',
                          Icons.account_balance,
                        ),

                        _statCard(
                          '24h Trading Volume',
                          '${marketValue.totalVolume.toStringAsFixed(
                              2)} ${selectedCurrency.toUpperCase()}',
                          Icons.bar_chart,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Market Dominance',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                'Bitcoin',
                                '${marketValue.bitcoinDominance.toStringAsFixed(
                                    2)}%',
                                Icons.currency_bitcoin,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _statCard(
                                'Ethereum',
                                '${marketValue.ethereumDominance
                                    .toStringAsFixed(2)}%',
                                Icons.currency_exchange,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        _statCard(
                          'Global Market Cap Change (USD)',
                          '${marketValue.marketCapChangePercent24hUsd
                              .toStringAsFixed(2)}%',
                          Icons.trending_up,
                        ),
                        _statCard(
                          'Active Cryptocurrencies',
                          '${marketValue.activeCryptoCurrencies}',
                          Icons.currency_exchange,
                        ),


                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// Reusable statistic card
  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      // color: const Color(0xFF302039),
      color:  AppColors().greenColor,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00D4FF),
              size: 27,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}