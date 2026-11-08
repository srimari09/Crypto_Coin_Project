
import 'package:crypto_coin/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FAQView extends StatelessWidget {
  const FAQView({super.key});

  // static const Color lightBlue = Color(0xFF00D4FF);
  static  Color lightBlue = AppColors().lightBlue;
  static  Color darkBackground = AppColors().lightBlue;
  // static const Color darkBackground = Color(0xFF1C0920);

  final List<Map<String, String>> faqs = const [
    {
      'question': 'What is CryptoCoin?',
      'answer':
      'CryptoCoin is a cryptocurrency research app that helps users explore coin prices, market statistics, charts and watchlists.'
    },
    {
      'question': 'Where does CryptoCoin get its data?',
      'answer':
      'CryptoCoin retrieves live cryptocurrency market data from the CoinGecko API through its backend service.'
    },
    {
      'question': 'What is Market Capitalization?',
      'answer':
      'Market capitalization is the total value of a cryptocurrency. It is calculated by multiplying the current price by the circulating supply.'
    },
    {
      'question': 'What is 24-hour Trading Volume?',
      'answer':
      'It represents the total value of a cryptocurrency traded during the last 24 hours.'
    },
    {
      'question': 'What is Bitcoin Dominance?',
      'answer':
      'Bitcoin dominance represents Bitcoin market capitalization as a percentage of the total cryptocurrency market capitalization.'
    },
    {
      'question': 'What does 24-hour price change mean?',
      'answer':
      'It shows the percentage increase or decrease in a cryptocurrency price over the last 24 hours.'
    },
    {
      'question': 'What is Circulating Supply?',
      'answer':
      'Circulating supply is the number of coins currently available in the market.'
    },
    {
      'question': 'How can I view price history?',
      'answer':
      'Open a coin from the Home screen to view its price chart. You can select different time periods to explore historical prices.'
    },
    {
      'question': 'How does the Watchlist work?',
      'answer':
      'You can add your favourite cryptocurrencies to the Watchlist and access them easily later.'
    },
    {
      'question': 'Why do cryptocurrency prices change?',
      'answer':
      'Cryptocurrency prices fluctuate due to market demand, supply, trading activity, news and other market conditions.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().lightBlue,
      appBar: AppBar(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        title: const Text(
          'Need To Know !',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];

          return Card(
            color: const Color(0xFF302036),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                iconColor: lightBlue,
                collapsedIconColor: lightBlue,
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
