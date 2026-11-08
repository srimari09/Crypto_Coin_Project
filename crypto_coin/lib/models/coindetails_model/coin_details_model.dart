class CoinDetailsModel {
    final String id;
    final String symbol;
    final String name;
    final String image;
    final String description;

    final int? marketCapRank;

    final double priceChangePercentage24h;
    final double priceChangePercentage1h;
    final double priceChangePercentage30d;
    final double priceChangePercentage7d;
    final double priceChangePercentage1y;

    final double currentPrice;
    final double totalSupply;
    final double circulatingSupply;
    final double marketCap;
    final double? maxSupply;
    final double totalVolume;



  CoinDetailsModel({required this.id, required this.symbol, required this.name, required this.image, required this.description,
    required this.marketCapRank,
     required this.priceChangePercentage24h, required this.currentPrice, required this.totalSupply, required this.circulatingSupply, required this.marketCap,  this.maxSupply, required this.totalVolume, required this.priceChangePercentage1h, required this.priceChangePercentage30d, required this.priceChangePercentage7d, required this.priceChangePercentage1y,});


    factory CoinDetailsModel.fromJson(Map<String, dynamic> json,String selectedCurrency) {
      final marketData = json['market_data'] ?? {};

      return CoinDetailsModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        symbol: json['symbol'] ?? '',
        image: json['image']?['large'] ?? '',

        marketCapRank: (json['market_cap_rank'] as num?)?.toInt() ?? 0,
        priceChangePercentage24h:
        (marketData['price_change_percentage_24h'] ?? 0).toDouble(),
        priceChangePercentage1h: (marketData['price_change_percentage_1h'] ?? 0)
            .toDouble(),
        priceChangePercentage7d: (marketData['price_change_percentage_7d'] ?? 0)
            .toDouble(),
        priceChangePercentage30d: (marketData['price_change_percentage_30d'] ??
            0).toDouble(),
        priceChangePercentage1y:
        (marketData['price_change_percentage_1y'] ?? 0).toDouble(),


        currentPrice: (marketData['current_price']?[selectedCurrency] ?? 0)
            .toDouble(),
        marketCap:
        (marketData['market_cap']?[selectedCurrency] ?? 0).toDouble(),
        totalVolume:
        (marketData['total_volume']?[selectedCurrency] ?? 0).toDouble(),
        circulatingSupply:
        (marketData['circulating_supply'] ?? 0).toDouble(),
        totalSupply:
        (marketData['total_supply'] ?? 0).toDouble(),
        maxSupply: marketData['max_supply']?.toDouble(),
        description: json['description']?['en']?.toString() ?? '',
      );
    }
}