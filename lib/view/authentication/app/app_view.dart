import 'package:clotimeapp/models/user_model.dart';
import 'package:clotimeapp/view/authentication/onboard/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int _selectedIndex = 1;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        final userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser.uid)
            .get();

        if (userData.exists) {
          setState(() {
            _currentUser = UserModel.fromJson(userData.data()!);
            _isLoading = false;
          });
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    List<Widget> pages = [
      const WardrobeViewPage(),
      const HomePageView(),
      SettingsPage(
          user:
              _currentUser!), // SettingsPage'i geçiş yaparken kullanıcı verisini geçiyoruz
    ];

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
