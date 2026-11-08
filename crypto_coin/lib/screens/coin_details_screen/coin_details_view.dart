import 'dart:async';
import 'package:crypto_coin/providers/coindetails_provider.dart';
import 'package:crypto_coin/utils/app_colors.dart';
import 'package:crypto_coin/utils/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../providers/watchlist_provider.dart';

class CoinDetailsView extends StatefulWidget {
  final String coinId;
  final String currency;
  CoinDetailsView({super.key, required this.coinId, required this.currency});

  @override
  State<CoinDetailsView> createState() => _CoinDetailsViewState();
}

class _CoinDetailsViewState extends State<CoinDetailsView> {
  LineBarSpot? _selectedSpot;
  Timer? _tooltipTimer;
  // final isPositive =
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final providerDetail = context.read<CoinDetailsProvider>();

      providerDetail.coinFetchDetails(widget.coinId, widget.currency);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tooltipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1C0920FF),
      // appBar: AppBar(
      //   title: const Text('Coin Details'),
      //   backgroundColor: const Color(0xFF1C0920),
      //   foregroundColor: Colors.white,
      //   centerTitle: true,
      //   leading: ,
      // ),
      body: Consumer<CoinDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            debugPrint(provider.errorMessage!);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Unable to Fetch Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          final coinDetailValue = provider.coinDetails;

          if (coinDetailValue == null) {
            return Center(child: AppText(text: 'coin details unavailable!'));
          }

          final isPositive = (coinDetailValue.priceChangePercentage24h) >= 0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const Spacer(),
                    AppText(
                      text: 'Coin Details',
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.04,
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        coinCard(
                          img: coinDetailValue.image,
                          name: coinDetailValue.name,
                          symbol: coinDetailValue.symbol,
                          marketCap: coinDetailValue.marketCap.toString(),
                          currency: widget.currency,
                          currentPrice: coinDetailValue.currentPrice,
                          changePercentage:
                              coinDetailValue.priceChangePercentage24h,
                          isPositive: isPositive,
                        ),
                        SizedBox(height: 20),
                        coinPeriodSelector(provider),
                        const SizedBox(height: 20),
                        coinChart(provider),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Details',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,

                                      children: [
                                        priceChangeItem(
                                          '1h Price Change',
                                          coinDetailValue
                                              .priceChangePercentage1h,
                                        ),
                                        priceChangeItem(
                                          '24h Price Change',
                                          coinDetailValue
                                              .priceChangePercentage24h,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        priceChangeItem(
                                          '7d Price Change',
                                          coinDetailValue
                                              .priceChangePercentage7d,
                                        ),
                                        priceChangeItem(
                                          '30d Price Change',
                                          coinDetailValue
                                              .priceChangePercentage30d,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              AppText(
                                text:
                                    'Live Price: ${coinDetailValue.currentPrice}',
                              ),
                              SizedBox(height: 8),
                              detailLookBuilder(
                                '◇ Market Cap :',
                                coinDetailValue.marketCap.toDouble(),
                              ),
                              SizedBox(height: 8),
                              detailLookBuilder(
                                '◇ Market Cap Rank :',
                                coinDetailValue.marketCapRank?.toInt(),
                              ),

                              SizedBox(height: 8),
                              detailLookBuilder(
                                '◇ Total Volume :',
                                coinDetailValue.totalVolume,
                              ),

                              SizedBox(height: 8),
                              detailLookBuilder(
                                '◇ circulating Supply :',
                                coinDetailValue.circulatingSupply,
                              ),

                              SizedBox(height: 8),
                              detailLookBuilder(
                                '◇ Total Supply :',
                                coinDetailValue.totalSupply,
                              ),
                              SizedBox(height: 8),
                              detailLookBuilder(
                                '◇ Maximum Supply :',
                                coinDetailValue.maxSupply,
                              ),
                            ],
                          ),
                        ),

                        // coinExtraDetails(),
                        // coinChart(provider),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget priceChangeItem(String title, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppText(text: title, color: Colors.black),
        AppText(
          text: '${value.toStringAsFixed(2)}%',
          color: value >= 0 ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget detailLookBuilder(String title, value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppText(text: title, color: Colors.black),
        ),
        Expanded(
          child: AppText(text: '${value}', color: Colors.black),
        ),
      ],
    );
  }

  Widget coinCard({
    String? img,
    required String name,
    required String symbol,
    required String marketCap,
    required String currency,
    required double changePercentage,
    required double currentPrice,
    required bool isPositive,
  }) {
    return Card(
      color: AppColors().greenColor,
      // clipBehavior: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: img ?? '',
                    width: 50,
                    height: 50,
                  ),
                  title: AppText(text: name, fontSize: 18),
                  subtitle: AppText(
                    text: '${symbol.toUpperCase()} ',
                    fontSize: 15,
                  ),
                  // trailing: Icon(Icons.favorite, color: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<WatchlistProvider>(
                  builder: (context, provider, child) {
                    final isFavourite = provider.isInWatchlist(widget.coinId);

                    return IconButton(
                      onPressed: () {
                        provider.toggleWatchlist(widget.coinId);
                      },
                      icon: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 9),
            child: Row(
              children: [
                AppText(text: ' • MKT: ${currency.toUpperCase()} ${marketCap}'),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,

              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text:
                      'Current Price: ${widget.currency.toUpperCase()} ${currentPrice}',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                AppText(
                  text:
                      'Change in 24h: ${changePercentage.toStringAsFixed(2)}%',
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget coinPeriodSelector(CoinDetailsProvider provider) {
    final period = {'1D': 1, '7D': 7, '30D': 30, '1Y': 365};
    return Card(
      color: Colors.grey.shade300,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: period.entries.map((entry) {
            final isSelect = provider.selectedDays == entry.value;
            return GestureDetector(
              onTap: () {
                provider.changeCurrencyChartPeriod(
                  widget.coinId,
                  entry.value,
                  widget.currency,
                );
              },
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: isSelect ? AppColors().greenColor : Colors.white,
                ),
                child: AppText(
                  text: entry.key,
                  color: isSelect ? Colors.white : Colors.black54,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget coinChart(CoinDetailsProvider provider) {
    final chartData = provider.coinChartData;

    if (chartData.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'No chart data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Convert chart data into FlSpot using index as X value.
    final spots = chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price);
    }).toList();

    final minX = spots.first.x;
    final maxX = spots.last.x;

    // Find minimum and maximum price.
    final prices = chartData.map((data) => data.price).toList();

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    // Add some space around the chart.
    final priceRange = maxPrice - minPrice;
    final padding = priceRange == 0 ? maxPrice.abs() * 0.01 : priceRange * 0.1;

    return SizedBox(
      height: 285,
      width: double.infinity,
      child: Stack(
        children: [
          LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minPrice - padding,
              maxY: maxPrice + padding,

              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),

              titlesData: const FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 65),
                ),
              ),

              borderData: FlBorderData(show: false),

              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.2,
                  barWidth: 2.5,
                  color: const Color(0xFF00D4FF),
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF00D4FF).withOpacity(0.12),
                  ),
                ),
              ],

              lineTouchData: LineTouchData(
                handleBuiltInTouches: false,
                touchCallback: (event, response) {
                  final touchedSpots = response?.lineBarSpots;

                  if (touchedSpots != null && touchedSpots.isNotEmpty) {
                    setState(() {
                      _selectedSpot = touchedSpots.first;
                    });

                    _tooltipTimer?.cancel();

                    _tooltipTimer = Timer(const Duration(seconds: 3), () {
                      if (mounted) {
                        setState(() {
                          _selectedSpot = null;
                        });
                      }
                    });
                  }
                },
              ),
            ),
          ),

          // Price tooltip.
          if (_selectedSpot != null)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF292033),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF00D4FF)),
                ),
                child: Text(
                  'Price: ${_selectedSpot!.y.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  // coinExtraDetails() {
  //   return
  // }
}
