import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../service/auth_service.dart';
import '../login/login_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late String _weatherDescription;
  late double _temperature;
  late String _fullName;

  @override
  void initState() {
    super.initState();
    _weatherDescription = '';
    _temperature = 0.0;
    _fullName = 'Kullanıcı Yok';
    _fetchWeatherData();
    _fetchCurrentUser();
  }

  Future<void> _fetchWeatherData() async {
    var apiKey = '27c27d34388760ec47244e792852e995';
    var city = 'Sivas';
    var apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var weatherDescription = data['weather'][0]['description'];
      var temperature = (data['main']['temp'] - 273.15).toDouble();
      setState(() {
        _weatherDescription = weatherDescription;
        _temperature = temperature;
      });
    }
  }
  

  Future<void> _fetchCurrentUser() async {
    final fullName = await AuthService().getFullName();
    setState(() {
      _fullName = fullName ?? 'Kullanıcı Yok';
    });
  }

  Future<void> _logout() async {
    await AuthService().signOut();
    await Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF4C53A5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Weather: $_weatherDescription',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Temperature: ${_temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 50),
                backgroundColor: Color.fromARGB(255, 109, 114, 169),
              ),
              onPressed: () {},
              child: const Text(
                "Kombin Oluştur",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Hoşgeldin: $_fullName',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              child: const Text("Logout"),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
