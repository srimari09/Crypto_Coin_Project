import 'package:crypto_coin/providers/homepage_provider.dart';
import 'package:crypto_coin/screens/home_screens/home_widgets/currency_dropDown.dart';
import 'package:crypto_coin/utils/app_colors.dart';
import 'package:crypto_coin/widgets/coin_search_bar.dart';
import 'package:crypto_coin/widgets/coinlist_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    final providers =  context.read<HomepageProvider>();
    providers.fetchCoinList();
    providers.fetchCurrency();
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      appBar: AppBar(
        title:Text('CryptoCoin',style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,

        backgroundColor: AppColors().backgroundColor,
        foregroundColor: AppColors().greenColor,
        shape: RoundedRectangleBorder(
          side:  BorderSide.lerp(
            BorderSide(color: AppColors().greenColor, width: 1.0),
            BorderSide(color: AppColors().backgroundColor, width: 2.0),
            0.5,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CoinSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
      SizedBox(height: 10,),

      Consumer<HomepageProvider>(builder: (context,provider,child)
      {
        return CurrencyDropdown(
            selectedCurrency: provider.selectedCurrency,
            currencies: provider.currency,
        onChanged: (currency)
          {
            provider.selectCurrencyUpdate(currency);
          },
        );
      }),


      SizedBox(height: 10,),
      Expanded(
        child: Consumer<HomepageProvider>(
          builder: (context, provider, child) {

            if (provider.loadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (provider.errorMessage != null) {
              return Center(
                child: Text(provider.errorMessage!),
              );
            }
            if (provider.coins.isEmpty) {
              return const Center(
                child: Text('No coins available'),
              );}

              final displayCoinsList = provider.coins.where((coin) {
              final query = searchQuery.toLowerCase().trim();

              return coin.name.toLowerCase().contains(query) ||
                  coin.symbol.toLowerCase().contains(query);
            }).toList();



            if (displayCoinsList.isEmpty) {
              return const Center(
                child: Text('No coins matching'),
              );
            }

            return ListView.builder(
              itemCount: searchQuery.trim().isEmpty
                  ? (displayCoinsList.length > 15
                  ? 15
                  : displayCoinsList.length)
                  : displayCoinsList.length,

              itemBuilder: (context, index) {
                final coinsData = displayCoinsList[index];
                return CoinlistItem(
                  coinData: coinsData,
                  currency: provider.selectedCurrency,
                );
              },
            );
          },
        ),
        ),
      ],
      ),
      ),
    );
  }
}
