import 'package:crypto_coin/utils/app_colors.dart';
import 'package:flutter/material.dart';
class CoinSearchBar extends StatelessWidget {

  final ValueChanged<String> onChanged;

   CoinSearchBar({super.key,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.green,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: AppColors().lightBlue,
        hintText: 'search coins',
        filled: true,
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.tune_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none
        )
      ),
    );
  }
}
