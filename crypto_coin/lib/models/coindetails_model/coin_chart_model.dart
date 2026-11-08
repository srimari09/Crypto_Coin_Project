class CoinChartModel {
  final DateTime timestamp;
  final double price;

  CoinChartModel({
    required this.timestamp,
    required this.price,
  });

  factory CoinChartModel.fromJson(List<dynamic> jsonPrice) {
    return CoinChartModel(
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        int.parse(jsonPrice[0].toString()),
      ),
      price: double.parse(jsonPrice[1].toString()),
    );
  }
}