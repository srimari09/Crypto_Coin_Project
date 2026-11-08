import 'package:crypto_coin/screens/Faq_screen/faq_page_view.dart';
import 'package:crypto_coin/screens/coin_details_screen/coin_details_view.dart';
import 'package:crypto_coin/screens/home_screens/home_page_view.dart';
import 'package:crypto_coin/screens/market_statistic_screen/market_details_view.dart';
import 'package:crypto_coin/screens/watchlist_screen/watchlist_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
class BottomBarScreen extends StatefulWidget {
  final int selectedIndex;

   BottomBarScreen({super.key,this.selectedIndex=0});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {

  int _selectedIndex = 0;
  String selectedArea = "";
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        // _navigationStack.add(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ;
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomePageView();
      case 1:
        return  MarketDetailsView();
      case 2:
        return const WatchlistView();
      case 3:
        return const FAQView();
      default:
        return const HomePageView();
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex==0,
      onPopInvokedWithResult: ((didPop, result) {
        if(!didPop && _selectedIndex!=0)
          {
            setState(() {
              _selectedIndex=0;
            });
          }
      }),
      child: Scaffold(
          body: _getScreen(_selectedIndex),


          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: AppColors().primaryColor,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400,fontSize: 13),
            unselectedItemColor: const Color(0xCC000000),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFFFFFFF),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500,fontSize: 13),
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  selectedIcon: Icons.currency_exchange,
                  isSelected: _selectedIndex == 0,
                ),
                label: 'Home',
              ),BottomNavigationBarItem(
                icon: _buildNavIcon(
                  selectedIcon: Icons.auto_graph,

                  isSelected: _selectedIndex == 1,
                ),
                label: 'Market statistics',
              ),BottomNavigationBarItem(
                icon: _buildNavIcon(
                  selectedIcon: Icons.favorite,

                  isSelected: _selectedIndex == 2,
                ),
                label: 'watchList',
              ),BottomNavigationBarItem(
                icon: _buildNavIcon(
                  selectedIcon: Icons.details,

                  isSelected: _selectedIndex == 3,
                ),
                label: 'FAQ',
              ),

            ],
          )

      ),
    );
  }
  Widget _buildNavIcon({
    required IconData selectedIcon,
    required bool isSelected,
  }) {
    if (isSelected) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          selectedIcon,
          size: 27,
          color: AppColors().darkBlue,
        ),
      );
    } else {
      return Icon(selectedIcon,size: 27,color: Colors.grey,);
    }
  }
}


