import 'package:crypto_coin/models/coin_list_models/coin_list_model.dart';
import 'package:crypto_coin/screens/coin_details_screen/coin_details_view.dart';
import 'package:crypto_coin/utils/app_colors.dart';
import 'package:crypto_coin/utils/app_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../providers/watchlist_provider.dart';

class CoinlistItem extends StatelessWidget {
  final CoinModel coinData;
  final String currency;

  const CoinlistItem({super.key, required this.coinData,required this.currency});

  @override
  Widget build(BuildContext context) {

    final isPositive = coinData.priceChangePercentage24h>=0;

    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(
            builder: (context)
        {
          return CoinDetailsView(coinId:coinData.id,currency: currency,);
        }));
      },
      child: Card(
        color: AppColors().greenColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: coinData.image,
                width: 40,
                height: 40,
              ),
              title: AppText(text: coinData.name),
              subtitle: AppText(text: '${coinData.symbol.toUpperCase()}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(text:' ${currency.toUpperCase()} ${coinData.currentPrice.toString()}',fontWeight: FontWeight.bold,),
                  AppText(text: '${coinData.priceChangePercentage24h.toStringAsFixed(2)}%',color: isPositive? Colors.green :Colors.red,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,bottom: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(text: ' • MKT :  ${currency.toUpperCase()} ${coinData.marketCap}'),
                  Consumer<WatchlistProvider>(
                    builder: (context, provider, child) {
                      final isFavourite = provider.isInWatchlist(coinData.id);
                      return IconButton(
                        onPressed: () {
                          provider.toggleWatchlist(coinData.id);
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            isFavourite ? Icons.favorite : Icons.favorite_border,
                            color: isFavourite ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ]
                ,
              ),
            )
          ],
        ),
      ),
    );
  }
}
