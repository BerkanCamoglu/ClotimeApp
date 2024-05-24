// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _SignUpState();
}

class _SignUpState extends State<RegisterView> {
  late String email, password, fullname;
  String? gender; // Cinsiyet değişkeni
  final formkey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * .25,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/img/login.png"))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Clotime'a Hoşgeldiniz ",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      customSizedBox(),
                      fullNameTextField(),
                      customSizedBox(),
                      emailTextField(),
                      customSizedBox(),
                      passwordTextField(),
                      customSizedBox(),
                      genderRadioButtons(), // Cinsiyet seçimi
                      customSizedBox(),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (formkey.currentState!.validate() &&
                                gender != null) {
                              try {
                                formkey.currentState!.save();
                                var userResult = await firebaseAuth
                                    .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                var newUser = UserModel(
                                  uid: userResult.user!.uid,
                                  email: email,
                                  fullname: fullname,
                                  gender: gender!,
                                  photos: [],
                                );

                                await firebaseFirestore
                                    .collection("Users")
                                    .doc(newUser.uid)
                                    .set(newUser.toJson());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Kullanıcı Başarıyla Oluşturuldu , Giriş Sayfasına Yönlendiriliyorsunuz..."),
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/loginPage",
                                );
                              } catch (e) {
                                log(e.toString());
                              }
                            }
                          },
                          child: const Text(
                            "Hesap Oluştur",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      customSizedBox(),
                      Center(
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/loginPage"),
                          child: const Text(
                            "Giriş Sayfasına Geri Dön",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField fullNameTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurun";
        } else {}
        return null;
      },
      onSaved: (value) {
        fullname = value!;
      },
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Ad Soyad"),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurun";
        } else {}
        return null;
      },
      onSaved: (value) {
        email = value!;
      },
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Email"),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurun";
        } else {}
        return null;
      },
      onSaved: (value) {
        password = value!;
      },
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: customInputDecoration("Parola"),
    );
  }

  Widget genderRadioButtons() {
    return Column(
      children: [
        ListTile(
          title: const Text(
            'Erkek',
            style: TextStyle(color: Colors.white),
          ),
          leading: Radio<String>(
            value: 'Erkek',
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Kadın',
            style: TextStyle(color: Colors.white),
          ),
          leading: Radio<String>(
            value: 'Kadın',
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 20,
      );

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
    );
  }
}
