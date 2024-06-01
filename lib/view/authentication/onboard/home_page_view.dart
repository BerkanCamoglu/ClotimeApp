import 'dart:async';
import 'dart:convert';
import 'package:clotimeapp/models/combine_model.dart';
import 'package:clotimeapp/view/authentication/onboard/create_combine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../service/auth_service.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String _weatherDescription = '';
  double _temperature = 0.0;
  String _fullName = 'Kullanıcı Yok';
  String _currentTime = '';
  Timer? _timer;

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatTime(DateTime.now());
    _fetchWeatherData();
    _fetchCurrentUser();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      if (mounted) {
        setState(() {
          _weatherDescription = weatherDescription;
          _temperature = temperature;
        });
      }
    }
  }

  Future<void> _fetchCurrentUser() async {
    final fullName = await AuthService().getFullName();
    if (mounted) {
      setState(() {
        _fullName = fullName ?? 'Kullanıcı Yok';
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = _formatTime(DateTime.now());
        });
      }
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const AlwaysScrollableScrollPhysics(),
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
                    _currentTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hava Durumu: $_weatherDescription',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Sıcaklık: ${_temperature.toStringAsFixed(1)}°C',
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
          Text(
            'Hoşgeldin: $_fullName',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(150, 50),
              backgroundColor: const Color.fromARGB(255, 109, 114, 169),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCombineView(
                    temperature: _temperature,
                  ),
                ),
              );
            },
            child: const Text(
              "Kombin Oluştur",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: firestore
                .collection("Users")
                .doc(auth.currentUser!.uid)
                .collection("Combines")
                .orderBy("createdAt", descending: false)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Bir Hata Oluştu"),
                );
              }
              var docs = snapshot.data!.docs;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var model = CombineModel.fromJson(docs[index].data());
                  return SizedBox(
                    width: 390,
                    height: 390,
                    child: Stack(
                      children: [
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 1,
                          ),
                          children: [
                            Image.network(
                              fit: BoxFit.fill,
                              model.ustGiyim.toString(),
                            ),
                            Image.network(
                              fit: BoxFit.fill,
                              model.altGiyim.toString(),
                            ),
                            Image.network(
                              fit: BoxFit.fill,
                              model.disGiyim.toString(),
                            ),
                            Image.network(
                              fit: BoxFit.fill,
                              model.ayakkabi.toString(),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            "Oluşturulduğu Tarih \n${DateFormat("dd/MM/yyyy").format(
                              model.createdAt!.toDate(),
                            )}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
