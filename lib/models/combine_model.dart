import 'package:cloud_firestore/cloud_firestore.dart';

class CombineModel {
  String? ustGiyim;
  String? altGiyim;
  String? disGiyim;
  String? ayakkabi;
  Timestamp? createdAt;

  CombineModel({
    this.ustGiyim,
    this.altGiyim,
    this.disGiyim,
    this.ayakkabi,
    this.createdAt,
  });

  // Firestore'a veri yazmak için JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'ustGiyim': ustGiyim,
      'altGiyim': altGiyim,
      'disGiyim': disGiyim,
      'ayakkabi': ayakkabi,
      'createdAt': createdAt,
    };
  }

  // Firestore'dan veri okurken model oluşturma
  factory CombineModel.fromJson(Map<String, dynamic> json) {
    return CombineModel(
      ustGiyim: json['ustGiyim'] as String?,
      altGiyim: json['altGiyim'] as String?,
      disGiyim: json['disGiyim'] as String?,
      ayakkabi: json['ayakkabi'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
    );
  }
}
