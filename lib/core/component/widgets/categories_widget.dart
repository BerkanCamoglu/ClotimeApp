import 'package:flutter/material.dart';

class CategoriesWidget extends StatefulWidget {
  final String gender; // Kullanıcı cinsiyetini alacak
  const CategoriesWidget({super.key, required this.gender});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  Map<String, List<String>> categories = {};
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _initializeCategories();
  }

  void _initializeCategories() {
    if (widget.gender == "Kadın") {
      categories = {
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
    } else if (widget.gender == "Erkek") {
      categories = {
        "Üst Giyim": [
          "Gömlek",
          "Tişört",
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
          "Eşofman Altı",
          "Chino",
          "Kargo Pantolon"
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
          "Klasik Ayakkabı",
          "Spor Ayakkabı",
          "Bot",
          "Loafer",
          "Makosen",
          "Sandalet",
          "Terlik"
        ]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.keys.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory =
                        _selectedCategory == category ? null : category;
                  });
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: _selectedCategory == category
                        ? Colors.blue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _selectedCategory == category
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              if (_selectedCategory == category)
                Row(
                  children: categories[category]!.map((subCategory) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          subCategory,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}