import 'package:crypto_coin/utils/app_colors.dart';
import 'package:flutter/material.dart';


class CurrencyDropdown extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String selectedCurrency;
  final List<String> currencies;

  const CurrencyDropdown({
    super.key,
    required this.onChanged,
    required this.selectedCurrency,
    required this.currencies,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(

      decoration: InputDecoration(
        // contentPadding:  EdgeInsets.symmetric(
        //   horizontal: 5,
        //   vertical: 10,
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: AppColors().primaryColor, width: 1),
        ),
      ),


      initialValue: currencies.contains(selectedCurrency) ? selectedCurrency : null,
      items: currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Container(
            width: 100,
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 3,
              ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 5,
              //   vertical: 8,
              // ),
              child: Text(currency.toUpperCase(),style: TextStyle(color: Colors.black),)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      hint:  Text('loading..',style: TextStyle(color: Colors.black),),
      icon:Icon( Icons.filter_alt_rounded),
      borderRadius: BorderRadius.circular(12),
      focusColor: AppColors().greenColor,
      style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
    );
  }
}
