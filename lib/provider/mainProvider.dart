import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  bool isLogin = false;
  String userId = '';
  String userCity = '';
  isLogining() async {
    isLogin = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userId = user.uid;
        print(userId);
        isLogin = true;
      }
    });

    var db = FirebaseFirestore.instance;

    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == userId) {
          userCity = doc.data()['city'];
        }
      }
    });
  }
}
