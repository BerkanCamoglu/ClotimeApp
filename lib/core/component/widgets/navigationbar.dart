import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      onTap: onItemTapped,
      height: 50,
      color: const Color(0xFF4C53A5),
      items: const [
        Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.home,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.settings,
          size: 30,
          color: Colors.white,
        ),
      ],
      index: selectedIndex,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}
