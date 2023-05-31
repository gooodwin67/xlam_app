import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreenProvider extends ChangeNotifier {
  bool isLogining = false;
  bool isLoginCorrect = false;
  int isLoginError = 0;
  login() async {
    try {
      isLogining = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'sn67@inbox.ru', password: 'vlesu1525yes');
      isLoginCorrect = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        isLoginError = 1;
        isLogining = false;
        notifyListeners();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        isLoginError = 2;
        isLogining = false;
        notifyListeners();
        print('Wrong password provided for that user.');
      }
    }
  }
}
