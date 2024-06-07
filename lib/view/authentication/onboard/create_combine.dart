import 'package:clotimeapp/models/photo_model.dart';
import 'package:clotimeapp/view/authentication/app/app_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/combine_model.dart';

class CreateCombineView extends StatefulWidget {
  const CreateCombineView({super.key, required this.temperature});
  final double temperature;

  @override
  State<CreateCombineView> createState() => _CreateCombineViewState();
}

class _CreateCombineViewState extends State<CreateCombineView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<PhotoModel> _ust = [];
  List<PhotoModel> _alt = [];
  List<PhotoModel> _dis = [];
  List<PhotoModel> _ayakkabi = [];

  PhotoModel? selecetedUst;
  PhotoModel? selecetedAlt;
  PhotoModel? selecetedDis;
  PhotoModel? selecetedAyak;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      _isLoading = true;
      setState(() {});
      await getPhotos();
      _isLoading = false;
      setState(() {});
    });
  }

  Future<void> getPhotos() async {
    List<PhotoModel> photos = [];

    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final querySnapshot = await _firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Photos')
        .get();
    if (querySnapshot.docs.isEmpty) {
      return;
    }

    for (var item in querySnapshot.docs) {
      var model = PhotoModel.fromJson(item.data());
      photos.add(model);
    }

    _ust = photos.where((element) => element.category == "Üst Giyim").toList();
    _alt = photos.where((element) => element.category == "Alt Giyim").toList();
    _dis = photos.where((element) => element.category == "Dış Giyim").toList();
    _ayakkabi =
        photos.where((element) => element.category == "Ayakkabı").toList();

    if (widget.temperature > 15) {
      //hot
      _ust = _ust
          .where((element) => element.subCategory != "Sweatshirt")
          .where((element) => element.subCategory != "Kazak")
          .where((element) => element.subCategory != "Hırka")
          .where((element) => element.subCategory != "Ceket")
          .where((element) => element.subCategory != "Yelek")
          .toList();

      _dis = _dis
          .where((element) => element.subCategory == "Yağmurluk")
          .where((element) => element.subCategory == "Yelek")
          .toList();

      _ayakkabi = _ayakkabi
          .where((element) => element.subCategory != "Bot")
          .where((element) => element.subCategory != "Çizme")
          .toList();
      return;
    }

    if (widget.temperature < 15) {
      //cold

      _ust = _ust
          .where((element) => element.subCategory != "Tişört")
          .where((element) => element.subCategory != "Bralet")
          .toList();

      _alt = _alt
          .where((element) => element.subCategory != "Şort")
          .where((element) => element.subCategory != "Kapri")
          .where((element) => element.subCategory != "Etek")
          .toList();

      _ayakkabi = _ayakkabi
          .where((element) => element.subCategory != "Sandalet")
          .where((element) => element.subCategory != "Babet")
          .where((element) => element.subCategory != "Terlik")
          .toList();
      return;
    }
  }

  void handleUstSeleceted(PhotoModel model) {
    if (model == selecetedUst) {
      selecetedUst = null;
    } else {
      selecetedUst = model;
    }
    setState(() {});
  }

  void handleAltSeleceted(PhotoModel model) {
    if (model == selecetedAlt) {
      selecetedAlt = null;
    } else {
      selecetedAlt = model;
    }
    setState(() {});
  }

  void handleDisSeleceted(PhotoModel model) {
    if (model == selecetedDis) {
      selecetedDis = null;
    } else {
      selecetedDis = model;
    }
    setState(() {});
  }

  void handleAyakSeleceted(PhotoModel model) {
    if (model == selecetedAyak) {
      selecetedAyak = null;
    } else {
      selecetedAyak = model;
    }
    setState(() {});
  }

  Future<void> saveCombine() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Kombin Oluşturuldu'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Üst Giyim:'),
                  SizedBox(
                    height: 200,
                    child: selecetedUst == null
                        ? const Center(child: Text('Kıyafet seçilmedi'))
                        : Image.network(
                            selecetedUst!.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const Text('Alt Giyim:'),
                  SizedBox(
                    height: 200,
                    child: selecetedAlt == null
                        ? const Center(child: Text('Kıyafet seçilmedi'))
                        : Image.network(
                            selecetedAlt!.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const Text('Dış Giyim:'),
                  SizedBox(
                    height: 200,
                    child: selecetedDis == null
                        ? const Center(child: Text('Kıyafet seçilmedi'))
                        : Image.network(
                            selecetedDis!.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const Text('Ayakkabı:'),
                  SizedBox(
                    height: 200,
                    child: selecetedAyak == null
                        ? const Center(child: Text('Kıyafet seçilmedi'))
                        : Image.network(
                            selecetedAyak!.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    var model = CombineModel.fromJson(
                      {
                        'ustGiyim': selecetedUst?.imageUrl ?? '',
                        'altGiyim': selecetedAlt?.imageUrl ?? '',
                        'disGiyim': selecetedDis?.imageUrl ?? '',
                        'ayakkabi': selecetedAyak?.imageUrl ?? '',
                        'createdAt': Timestamp.now(),
                      },
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppView(),
                      ),
                    );

                    await _firestore
                        .collection("Users")
                        .doc(_auth.currentUser!.uid)
                        .collection("Combines")
                        .doc()
                        .set(model.toJson());
                  } catch (e) {
                    showAlert('Kombin kaydedilirken bir hata oluştu.');
                  }
                },
                child: const Text('Anasayfaya Git'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showAlert('Kombin kaydedilirken bir hata oluştu.');
    }
  }

  Future<dynamic> showAlert(String text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(text),
          content: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Tamam"),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kombin Oluştur'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Üst Giyim",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _ust.length,
                    itemBuilder: (context, index) {
                      final model = _ust[index];
                      return ItemCard(
                        model: model,
                        isSelected: model == selecetedUst,
                        onTap: () {
                          handleUstSeleceted(model);
                        },
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Alt Giyim",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _alt.length,
                    itemBuilder: (context, index) {
                      final model = _alt[index];
                      return ItemCard(
                        model: model,
                        isSelected: model == selecetedAlt,
                        onTap: () {
                          handleAltSeleceted(model);
                        },
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Dış Giyim",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _dis.length,
                    itemBuilder: (context, index) {
                      final model = _dis[index];
                      return ItemCard(
                        model: model,
                        isSelected: model == selecetedDis,
                        onTap: () {
                          handleDisSeleceted(model);
                        },
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Ayakkabı",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _ayakkabi.length,
                    itemBuilder: (context, index) {
                      final model = _ayakkabi[index];
                      return ItemCard(
                        model: model,
                        isSelected: model == selecetedAyak,
                        onTap: () {
                          handleAyakSeleceted(model);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await saveCombine();
                    },
                    child: const Text("Kombini Tamamla"),
                  ),
                ),
              ],
            ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.model,
    required this.isSelected,
    this.onTap,
  });

  final PhotoModel model;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: isSelected ? Colors.blue : Colors.white,
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  model.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  model.subCategory!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
