import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  bool isLogin = false;
  isLogining() {
    isLogin = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        isLogin = true;
      }
    });
  }
}
