
import 'dart:math';

import 'package:crypto_coin/models/coin_list_models/coin_list_model.dart';
import 'package:crypto_coin/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class HomepageProvider extends  ChangeNotifier
{

   final ApiService _apiService = ApiService();

   //coin list
    List<CoinModel> coins =[];

    //currency det
   List<String> currency = [];
    String selectedCurrency = "usd";

    String? errorMessage;
    bool loadingState = false;

    //fetchcoinlist
    Future<void> fetchCoinList() async
    {
        loadingState = true;
        errorMessage=null;
        notifyListeners();
        try{
          coins = await _apiService.getCoinData(currency: selectedCurrency);
          print('Data length: ${coins.length}');
          print('Data fetch successfully: ${coins}');
        }
        catch(err)
      {
        errorMessage = err.toString();
        debugPrint('Error in Fetching CoinList: $err');
      }finally{
          loadingState=false;
          notifyListeners();
        }
    }

    //fetchcurrency for filter
    Future<void> fetchCurrency() async
    {
      loadingState = true;
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
        loadingState=false;
        notifyListeners();
      }
    }

    //change selected curr
   Future<void> selectCurrencyUpdate(String currency)
   async{
     selectedCurrency = currency;
     notifyListeners();
     await fetchCoinList();
   }
}