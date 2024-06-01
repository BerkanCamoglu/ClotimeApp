import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  String? category;
  String? subCategory;
  String? imageUrl;
  Timestamp? time;

  PhotoModel();

  PhotoModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    subCategory = json['subCategory'];
    imageUrl = json['imageUrl'];
    time = json['time'] as Timestamp;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category;
    data['subCategory'] = subCategory;
    data['imageUrl'] = imageUrl;
    data['time'] = time;
    return data;
  }
}
