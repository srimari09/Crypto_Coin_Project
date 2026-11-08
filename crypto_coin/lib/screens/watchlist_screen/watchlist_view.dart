import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_coin/providers/watchlist_provider.dart';
import 'package:crypto_coin/screens/coin_details_screen/coin_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistView extends StatefulWidget {
  final String currency;

  const WatchlistView({
    super.key,
    this.currency = 'usd',
  });

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  static const Color lightBlue = Color(0xFF00D4FF);
  static const Color darkBackground = Color(0xFF1C0920);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<WatchlistProvider>()
          .fetchWatchlistCoins(widget.currency);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        title: const Text(
          'My Watchlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: lightBlue),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        provider.fetchWatchlistCoins(widget.currency),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.watchlistCoins.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    color: lightBlue,
                    size: 65,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your Watchlist is Empty',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your favourite coins to track them here.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.watchlistCoins.length,
            itemBuilder: (context, index) {
              final coin = provider.watchlistCoins[index];

              return Card(
                color: const Color(0xFF302036),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoinDetailsView(
                          coinId: coin.id,
                          currency: widget.currency,
                        ),
                      ),
                    );
                  },
                  leading: CachedNetworkImage(
                    imageUrl: coin.image,
                    width: 40,
                    height: 40,
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.currency_bitcoin),
                  ),
                  title: Text(
                    coin.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    coin.symbol.toUpperCase(),
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.currency.toUpperCase()} ${coin.currentPrice}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: coin.priceChangePercentage24h >= 0
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          provider.toggleWatchlist(coin.id);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}