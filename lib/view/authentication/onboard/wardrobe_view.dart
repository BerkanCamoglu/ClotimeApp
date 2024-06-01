import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/component/widgets/categories_widget.dart';
import '../add-clothes/add_clothes_view.dart';

class WardrobeViewPage extends StatefulWidget {
  const WardrobeViewPage({super.key});

  @override
  State<WardrobeViewPage> createState() => _WardrobeViewPageState();
}

class _WardrobeViewPageState extends State<WardrobeViewPage> {
  String? _userGender;
  String? _selectedSubCategory;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserGender();
  }

  Future<void> _loadUserGender() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    final userDoc =
        await _firebaseFirestore.collection('Users').doc(user.uid).get();
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
                if (_userGender != null)
                  CategoriesWidget(
                    gender: _userGender!,
                    onSubCategorySelected: _onSubCategorySelected,
                  ),
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
                if (_selectedSubCategory != null)
                  _buildClothesGrid(_selectedSubCategory!)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSubCategorySelected(String subCategory) {
    setState(() {
      _selectedSubCategory = subCategory;
    });
  }

  Widget _buildClothesGrid(String category) {
    return StreamBuilder(
      stream: _firebaseFirestore
          .collection('Users')
          .doc(_firebaseAuth.currentUser?.uid)
          .collection("Photos")
          .where('subCategory', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Text("No items found.");
        }

        final documents = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final doc = documents[index];
            return Card(
              child: Column(
                children: [
                  Image.network(
                    doc['imageUrl'],
                    fit: BoxFit.cover,
                    height: 182,
                    width: double.infinity,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
