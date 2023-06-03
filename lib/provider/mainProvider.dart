import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  bool isLogin = false;
  String userId = '';
  isLogining() {
    isLogin = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userId = user.uid;
        print(user.uid);
        isLogin = true;
      }
    });
  }
}
