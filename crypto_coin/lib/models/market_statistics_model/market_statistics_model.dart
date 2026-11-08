class MarketStatisticsModel {
    final String currency;
    final double totalMarketCap;
    final double totalVolume;
    final double bitcoinDominance;
    final double ethereumDominance;
    final int activeCryptoCurrencies;
    final double marketCapChangePercent24hUsd;

  MarketStatisticsModel({required this.currency,
    required this.totalMarketCap, required this.totalVolume,
    required this.bitcoinDominance, required this.activeCryptoCurrencies,required this.ethereumDominance, required this.marketCapChangePercent24hUsd});


  factory MarketStatisticsModel.fromJson(Map<String,dynamic> json)
  {
    return MarketStatisticsModel(currency: json['currency'] ?? 'usd',
        totalMarketCap: (json["totalMarketCap"] as num?)?.toDouble() ?? 0.0,
        totalVolume: (json['totalVolume'] as num?)?.toDouble() ?? 0.0,
        bitcoinDominance: (json['bitcoinDominance'] as num?)?.toDouble() ?? 0.0,
        ethereumDominance: (json['ethereumDominance'] as num?)?.toDouble() ?? 0.0,
      activeCryptoCurrencies: (json['activeCryptoCurrencies'] as num?)?.toInt() ?? 0,
        marketCapChangePercent24hUsd: (json['marketCapChangePercentage24hUsd'] as num?)?.toDouble() ?? 0.0,
    );}

}