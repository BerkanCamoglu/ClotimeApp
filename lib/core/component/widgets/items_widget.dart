import 'package:flutter/material.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key, required String category});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.90,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 1; i < 9; i++)
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Image.asset("assets/img/categories/$i.png"),
              ),
            ),
          ),
      ],
    );
  }
}
