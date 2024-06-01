// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    var firebaseAuth = FirebaseAuth.instance;

    Future.delayed(
      const Duration(seconds: 1),
      () async {
        var isInternet = await InternetConnectionChecker().hasConnection;
        if (isInternet == false) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/error",
            (route) => false,
          );
          return;
        }
        if (firebaseAuth.currentUser == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/loginPage",
            (route) => false,
          );
          return;
        }
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/app",
          (route) => false,
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/img/authentication/clotime.png'),
              width: 300,
              height: 300,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
