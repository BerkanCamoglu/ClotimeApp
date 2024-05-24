class UserModel {
  String uid;
  String email;
  String fullname;
  String gender;
  List<String> photos;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullname,
    required this.gender,
    required this.photos,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      fullname: json['fullname'],
      gender: json['gender'],
      photos: List<String>.from(json['photos']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'gender': gender,
      'photos': photos,
    };
  }
}
