import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

import '../../../core/component/widgets/home_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddClothesView extends StatefulWidget {
  const AddClothesView({super.key});

  @override
  State<AddClothesView> createState() => _AddClothesViewState();
}

class _AddClothesViewState extends State<AddClothesView> {
  final String userGender =
      "erkek"; // Bu değişkeni gerçek kullanıcının cinsiyet bilgisine göre ayarlayın.
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  final Map<String, List<String>> categories = {
    "Üst Giyim": [
      "Bluz",
      "Tişört",
      "Gömlek",
      "Sweatshirt",
      "Kazak",
      "Hırka",
      "Ceket",
      "Yelek",
      "Büstiyer",
      "Bralet"
    ],
    "Alt Giyim": [
      "Pantolon",
      "Jean",
      "Etek",
      "Şort",
      "Tayt",
      "Kapri",
      "Eşofman Altı"
    ],
    "Dış Giyim": [
      "Palto",
      "Mont",
      "Trençkot",
      "Kaban",
      "Parka",
      "Yağmurluk",
      "Ceket",
      "Yelek"
    ],
    "Ayakkabı": [
      "Topuklu Ayakkabı",
      "Düz Ayakkabı",
      "Spor Ayakkabı",
      "Bot",
      "Çizme",
      "Sandalet",
      "Babet",
      "Terlik"
    ],
  };

  String? selectedCategory;
  String? selectedSubcategory;
  File? _image;
  String? downloadUrl;

  Map<String, List<String>> getFilteredCategories() {
    if (userGender == "erkek") {
      return {
        "Üst Giyim": [
          "Tişört",
          "Gömlek",
          "Sweatshirt",
          "Kazak",
          "Hırka",
          "Ceket",
          "Yelek"
        ],
        "Alt Giyim": [
          "Pantolon",
          "Jean",
          "Şort",
          "Tayt",
          "Kapri",
          "Eşofman Altı"
        ],
        "Dış Giyim": [
          "Palto",
          "Mont",
          "Trençkot",
          "Kaban",
          "Parka",
          "Yağmurluk",
          "Ceket",
          "Yelek"
        ],
        "Ayakkabı": [
          "Düz Ayakkabı",
          "Spor Ayakkabı",
          "Bot",
          "Çizme",
          "Sandalet",
          "Babet",
          "Terlik"
        ]
      };
    } else {
      return {
        "Üst Giyim": [
          "Bluz",
          "Tişört",
          "Gömlek",
          "Sweatshirt",
          "Kazak",
          "Hırka",
          "Ceket",
          "Yelek",
          "Büstiyer",
          "Bralet"
        ],
        "Alt Giyim": [
          "Pantolon",
          "Jean",
          "Etek",
          "Şort",
          "Tayt",
          "Kapri",
          "Eşofman Altı"
        ],
        "Dış Giyim": [
          "Palto",
          "Mont",
          "Trençkot",
          "Kaban",
          "Parka",
          "Yağmurluk",
          "Ceket",
          "Yelek"
        ],
        "Ayakkabı": [
          "Topuklu Ayakkabı",
          "Düz Ayakkabı",
          "Spor Ayakkabı",
          "Bot",
          "Çizme",
          "Sandalet",
          "Babet",
          "Terlik"
        ]
      };
    }
  }

  Future<void> onSubmit() async {
    if (selectedCategory != null &&
        selectedSubcategory != null &&
        _image != null) {
      final storageRef = firebaseStorage
          .ref()
          .child('user_photos')
          .child(firebaseAuth.currentUser!.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await firebaseFirestore
          .collection("Users")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("Photos")
          .doc()
          .set(
        {
          "category": selectedCategory,
          "subCategory": selectedSubcategory,
          "time": Timestamp.now(),
          "imageUrl": downloadUrl,
        },
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen önce fotoğraf yükleyin."),
        ),
      );
    }
  }

  Future<void> getImageFromGalery() async {
    var galeryPicture = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (galeryPicture == null) return;

    var croppedFile = await ImageCropper().cropImage(
      sourcePath: galeryPicture.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio4x3,
      ],
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Clotime App',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.ratio4x3,
        lockAspectRatio: true,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Clotime App',
      ),
    );

    if (croppedFile == null) return;

    _image = File(croppedFile.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = getFilteredCategories();

    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAnimatedDropdown(
              hint: "Kategori Seçin",
              value: selectedCategory,
              items: filteredCategories.keys.toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                  selectedSubcategory = null;
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedCategory != null)
              _buildAnimatedDropdown(
                hint: "Alt Kategori Seçin",
                value: selectedSubcategory,
                items: filteredCategories[selectedCategory]!,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubcategory = newValue;
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory != null && selectedSubcategory != null) {
                  getImageFromGalery();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen kategori ve alt kategori seçin."),
                    ),
                  );
                }
              },
              child: const Text("Fotoğraf Seç"),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4C53A5)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: _image == null
                  ? const Center(
                      child: Text(
                        "Fotoğraf yükleyiniz",
                        style: TextStyle(color: Color(0xFF4C53A5)),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(_image!, fit: BoxFit.fitHeight),
                    ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Kıyafeti Ekle"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF4C53A5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF4C53A5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF4C53A5)),
          ),
        ),
        hint: Text(hint, style: const TextStyle(color: Color(0xFF4C53A5))),
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: Color(0xFF4C53A5))),
          );
        }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4C53A5)),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Color(0xFF4C53A5), fontSize: 16),
      ),
    );
  }
}
