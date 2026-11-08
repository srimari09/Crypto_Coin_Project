import 'package:crypto_coin/providers/coindetails_provider.dart';
import 'package:crypto_coin/providers/homepage_provider.dart';
import 'package:crypto_coin/providers/marketStats.dart';
import 'package:crypto_coin/providers/watchlist_provider.dart';
import 'package:crypto_coin/screens/watchlist_screen/watchlist_view.dart';
import 'package:crypto_coin/widgets/app_nav_bar.dart' show BottomBarScreen;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomepageProvider()),
        ChangeNotifierProvider(create: (_)=>CoinDetailsProvider()),
        ChangeNotifierProvider(create: (_)=>MarketStatsProvider()),
        ChangeNotifierProvider(create: (_)=>WatchlistProvider())
        // ChangeNotifierProvider(create: (_)=>Fav())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BottomBarScreen(),
      ),
    );
  }
}
