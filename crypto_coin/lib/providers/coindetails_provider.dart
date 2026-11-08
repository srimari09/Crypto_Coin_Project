import 'package:crypto_coin/models/coindetails_model/coin_chart_model.dart';
import 'package:crypto_coin/models/coindetails_model/coin_details_model.dart';
import 'package:crypto_coin/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class CoinDetailsProvider extends ChangeNotifier{
  final ApiService _apiService = ApiService();

  CoinDetailsModel? coinDetails;
  List<CoinChartModel> coinChartData = [];
  int selectedDays = 7;

  bool isLoading = false;
  String? errorMessage;

  Future<void> coinFetchDetails(String coinId, String currency) async
  {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
        coinDetails = await _apiService.getCoinDetails(coinId, currency);
        coinChartData = await _apiService.getCoinChart(coinId, selectedDays, currency);
    }
    catch(e)
    {
      errorMessage = e.toString();
    }finally
    {
     isLoading = false;
     notifyListeners();
    }
  }

  Future<void> changeCurrencyChartPeriod(
      String coinId,
      int selectDays,
      String currency,
      ) async {
    selectedDays = selectDays;
    errorMessage = null;

    try {
      coinChartData = await _apiService.getCoinChart(
        coinId,
        selectDays,
        currency,
      );
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

}