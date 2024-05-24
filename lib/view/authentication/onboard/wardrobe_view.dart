import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../core/component/widgets/categories_widget.dart';
import '../add-clothes/add_clothes_view.dart';

class WardrobeViewPage extends StatefulWidget {
  const WardrobeViewPage({super.key});

  @override
  State<WardrobeViewPage> createState() => _WardrobeViewPageState();
}

class _WardrobeViewPageState extends State<WardrobeViewPage> {
  String? _userGender; // Kullanıcı cinsiyetini tutacak değişken
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadUserGender();
  }

  Future<void> _loadUserGender() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return;

    final userDoc =
        await firebaseFirestore.collection('Users').doc(user.uid).get();
    setState(() {
      _userGender = userDoc['gender'];
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    backgroundColor: const Color(0xFF4C53A5),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddClothesView(),
                      ),
                    );
                  },
                  child: const Text(
                    "Kıyafet Ekle",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: const Text(
                    "Kategoriler",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                if (_userGender != null) CategoriesWidget(gender: _userGender!),
                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: const Text(
                    "Kıyafetlerim",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: firebaseFirestore
                      .collection('Users')
                      .doc(firebaseAuth.currentUser?.uid)
                      .collection("Photos")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('Fotoğraf bulunamadı');
                    }

                    var data = snapshot.data!.docs;
                    return GridView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: data.map((doc) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(doc['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text(doc['category'].toString()),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
