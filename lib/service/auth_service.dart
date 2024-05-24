import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> signInAnonymous() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    String? res;
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "Kullanıcı Bulunamadı!";
      } else if (e.code == "wrong-password") {
        res = "Şifre Yanlış";
      } else if (e.code == "user-disabled") {
        res = "Kullanıcı Pasif";
      } else {
        res = e.message;
      }
    }
    return res;
  }

  Future<String?> register(
      String email, String password, String fullName) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firestore.collection('Users').doc(result.user!.uid).set({
        'fullName': fullName,
        'email': email,
      });
      res = "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        res = "Email Zaten Kullanımda!";
      } else if (e.code == "weak-password") {
        res = "Şifre Güçsüz!";
      } else {
        res = e.message;
      }
    }
    return res;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  Future<String?> getFullName() async {
    final user = getCurrentUser();
    if (user != null) {
      final doc = await firestore.collection('Users').doc(user.uid).get();
      return doc['fullname'];
    }
    return null;
  }
}
