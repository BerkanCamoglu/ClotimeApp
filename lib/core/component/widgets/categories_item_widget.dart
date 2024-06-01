import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryItemsView extends StatelessWidget {
  final String category;

  const CategoryItemsView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: StreamBuilder(
        stream: firebaseFirestore
            .collection('Users')
            .doc(firebaseAuth.currentUser?.uid)
            .collection("Photos")
            .where('category', isEqualTo: category)
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
                      height: 100,
                      width: double.infinity,
                    ),
                    Text(doc['name']),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
