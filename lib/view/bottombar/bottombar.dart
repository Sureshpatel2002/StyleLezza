import 'package:flutter/material.dart';
import 'package:stylelezza/utils/app_colors.dart';
import 'package:stylelezza/view/cart/cart_screen.dart';
import 'package:stylelezza/view/fav/fav_screen.dart';
import 'package:stylelezza/view/home/home_screen.dart';
import 'package:stylelezza/view/profile/profile_screen.dart';

import '../../utils/constant_padding.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _selectedIndex = 0;

  // List of screens for each index
  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const FavScreen(),
    const ProfileScreen(),
  ];

  // Function to handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom BottomAppBar for bottom navigation
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: ResponsivePadding.getPagePadding(context) ,
            right: ResponsivePadding.getPagePadding(context),
            bottom: ResponsivePadding.getPagePadding(context)),
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.primaryMainColor,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: BottomAppBar(
            height: 70,
            
            padding: EdgeInsets.all(0),
            color: Colors.transparent, // No background color
            elevation: 0, // No shadow
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    
                    icon: Container(
                      
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        
                         color: _selectedIndex == 0 ? AppColors.whiteColor : null,
                        borderRadius:const BorderRadius.all(Radius.circular(50))),
                     
                      child: Icon(
                        size: 30,
                        _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                        color: _selectedIndex == 0
                            ? AppColors.buttonColor
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    
                    icon: Container(
                       width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        
                         color: _selectedIndex == 1 ? AppColors.whiteColor : null,
                        borderRadius:const BorderRadius.all(Radius.circular(50))),
                     
                      child: Icon(
                        size: 24,
                        _selectedIndex == 1
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: _selectedIndex == 1
                            ? AppColors.buttonColor
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () => _onItemTapped(1),
                  ),
                  IconButton(
                   
                    icon: Container(
                       width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        
                         color: _selectedIndex == 2 ? AppColors.whiteColor : null,
                        borderRadius:const BorderRadius.all(Radius.circular(50))),
                     
                      child: Icon(
                        size: 24,
                        _selectedIndex == 2
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: _selectedIndex == 2
                            ? AppColors.buttonColor
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                  IconButton(
                    
                    icon: Container(
                       width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        
                         color: _selectedIndex == 3 ? AppColors.whiteColor : null,
                        borderRadius:const BorderRadius.all(Radius.circular(50))),
                     
                      child: Icon(
                        size: 24,
                        _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                        color: _selectedIndex == 3
                            ? AppColors.buttonColor
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // Display the selected screen
      body: _screens[_selectedIndex],
    );
  }
}
