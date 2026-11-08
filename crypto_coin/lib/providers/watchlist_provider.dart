import 'package:crypto_coin/models/coin_list_models/coin_list_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class WatchlistProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<String> watchlistIds = [];
  List<CoinModel> watchlistCoins = [];

  bool isLoading = false;
  String? errorMessage;

  bool isInWatchlist(String coinId) {
    return watchlistIds.contains(coinId);
  }

  Future<void> loadSavedIds() async {
    final prefs = await SharedPreferences.getInstance();

    watchlistIds = prefs.getStringList('watchlist_ids') ?? [];

    notifyListeners();
  }

  Future<void> toggleWatchlist(String coinId) async {
      if (watchlistIds.contains(coinId)) {
        watchlistIds.remove(coinId);

        watchlistCoins.removeWhere(
              (coin) => coin.id == coinId,
        );
      } else {
      watchlistIds.add(coinId);
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('watchlist_ids', watchlistIds);

    notifyListeners();
  }

  Future<void> fetchWatchlistCoins(String currency) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await loadSavedIds();

      if (watchlistIds.isEmpty) {
        watchlistCoins = [];
        return;
      }

      final allCoins = await _apiService.getCoinData(
        currency: currency,
      );

      watchlistCoins = allCoins
          .where((coin) => watchlistIds.contains(coin.id))
          .toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}