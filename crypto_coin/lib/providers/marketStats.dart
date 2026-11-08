import 'package:crypto_coin/models/market_statistics_model/market_statistics_model.dart';
import 'package:crypto_coin/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MarketStatsProvider extends ChangeNotifier{
  MarketStatisticsModel? marketStats;
  bool isLoading= false;
  String? errorMessage;
  List<String> currency = [];

  final ApiService _apiService  = ApiService();

  Future<void> fetchMarketStatsDetails(String currency) async
  {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
       marketStats =await _apiService.fetchMarketStats(currency);
    } catch (e) {
      errorMessage = e.toString();
      throw Exception(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  //fetchcurrency for filter
  Future<void> fetchCurrency() async
  {
    isLoading = true;
    errorMessage=null;
    notifyListeners();

    try{
      currency = await _apiService.getCurrencies();
      print('Data length: ${currency.length}');
      print('Data fetch successfully: ${currency}');
    }
    catch(e)
    {
      errorMessage =e.toString();
      debugPrint('Error in Fetching Currency: $e');
    }finally{
      isLoading=false;
      notifyListeners();
    }
  }

}