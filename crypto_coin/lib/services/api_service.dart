import 'package:crypto_coin/models/coin_list_models/coin_list_model.dart';
import 'package:crypto_coin/models/coindetails_model/coin_chart_model.dart';
import 'package:crypto_coin/models/coindetails_model/coin_details_model.dart';
import 'package:crypto_coin/models/market_statistics_model/market_statistics_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {

  String get baseUrl{
    if(kIsWeb)
      {
        return 'http://localhost:3000';
      }
    switch(defaultTargetPlatform)
        {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';

      case TargetPlatform.iOS:
        return 'http://localhost:3000';

      default:
        return 'http://localhost:3000';
    }
  }



 late final Dio _dioObj = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  //fetch coin data
  Future<List<CoinModel>> getCoinData({String currency = 'usd'}) async {
    try {
      final response = await _dioObj.get(
        '/api/coins',
        queryParameters: {'currency': currency},
      );
      debugPrint('API STATUS: ${response.statusCode}');
      debugPrint('API RESPONSE: ${response.data}');

      if (response.statusCode == 200) {
        final dynamic body = response.data;

        List<dynamic> coinData;

        if (body is List) {
          // Backend directly returns an array
          coinData = body;
        } else if (body is Map) {
          // Backend returns an object containing an array
          final dynamic result = body['data'] ?? body['coins'];

          if (result is List) {
            coinData = result;
          } else {
            throw Exception('Unexpected API response structure: ${body.keys}');
          }
        } else {
          throw Exception('Invalid API response format');
        }

        final coins = coinData.map((json) {
          return CoinModel.fromJson(Map<String, dynamic>.from(json as Map));
        }).toList();

        debugPrint('Parsed coins: ${coins.length}');

        return coins;
      }

      throw Exception('Failed to fetch cryptocurrency data');
    } on DioException catch (e) {
      debugPrint('DIO ERROR: ${e.message}');
      debugPrint('SERVER RESPONSE: ${e.response?.data}');

      throw Exception(
        e.response?.data is Map
            ? e.response?.data['message'] ?? e.message
            : e.response?.data?.toString() ?? e.message,
      );
    }
  }

  //get currency
  Future<List<String>> getCurrencies() async {
    try {
      final response = await _dioObj.get('/api/currencies');

      if (response.statusCode == 200) {
        final data = response.data;
        print('_________________RESPONSE: ${data}_____');
        debugPrint('Currency response: $data');
        debugPrint('Response status: ${response.statusCode}');
        return List<String>.from(data);
      }
      throw Exception('Failed to fetch currencies');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? e.message ?? 'Unable to load currencies',
      );
    }
  }

  //get coinDetails
  Future<CoinDetailsModel> getCoinDetails(
    String coinId,
    String currency,
  ) async {
    try {
      final response = await _dioObj.get('/api/coins/$coinId');
      if (response.statusCode == 200) {
        print('______RESPONSE________${response.data}');
        debugPrint('MARKET DATA: ${response.data['market_data']}');
        debugPrint('IMAGE: ${response.data['image']}');
        debugPrint('MARKET CAP RANK: ${response.data['market_cap_rank']}');

        return CoinDetailsModel.fromJson(response.data, currency);
      }
      throw Exception('Failed to fetch details');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'unable to fetch coin details',
      );
    }
  }

  //get coinchart
  Future<List<CoinChartModel>> getCoinChart(
    String coinId,
    int selectDays,
    String currency,
  ) async {
    try {
      final response = await _dioObj.get(
        '/api/coins/$coinId/chart',
        queryParameters: {'days': selectDays, 'currency': currency},
      );
      if (response.statusCode == 200) {
        final List<dynamic> prices = response.data['prices'];
        print(response.data.runtimeType);
        print(response.data['prices'].runtimeType);
        print(response.data['prices'][0]);
        print(response.data['prices'][0].runtimeType);
        return prices
            .map((price) => CoinChartModel.fromJson(price))
            .toList();
      }
      throw Exception('Failed to fetch details');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'unable to fetch chart details',
      );
    }
  }

  Future<MarketStatisticsModel> fetchMarketStats(String currency)async
  {
    try{
      final response = await _dioObj.get('/api/market-stats/currency',
      queryParameters: {
        'currency': currency
      }
      );
       if(response.statusCode==200) {
         return MarketStatisticsModel.fromJson(response.data);
       }
      throw Exception('Failed to fetch market statistic');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.message ??
            'Unable to fetch market statistic',
      );
    }
  }

}
