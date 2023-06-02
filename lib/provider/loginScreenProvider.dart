import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreenProvider extends ChangeNotifier {
  bool isLogining = false;
  bool isLoginCorrect = false;
  int isLoginError = 0;
  String login = '';
  String password = '';

  tryLogin() async {
    try {
      isLogining = true;
      notifyListeners();
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: login, password: password);
      isLoginCorrect = true;
      login = '';
      password = '';
      isLogining = false;
    } on FirebaseAuthException catch (e) {
      print(e.code);
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
      } else if (e.code == 'invalid-email') {
        isLoginError = 3;
        isLogining = false;
        notifyListeners();
        print('invalid-email.');
      } else if (e.code == 'unknown') {
        isLoginError = 4;
        isLogining = false;
        notifyListeners();
        print('unknown.');
      }
    }
  }

  editLogin(value) {
    login = value.toString().trim();
    isLoginError = 0;
    notifyListeners();
  }

  editPassword(value) {
    password = value.toString().trim();
    isLoginError = 0;
    notifyListeners();
  }
}
