import 'package:flutter/material.dart';

import '../../../core/component/widgets/home_appbar.dart';
import '../../../core/component/widgets/navigationbar.dart';
import '../onboard/home_page_view.dart';
import '../onboard/wardrobe_view.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    const WardrobeViewPage(),
    const HomePageView(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
