import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreenProvider extends ChangeNotifier {
  String login = '';
  String password = '';
  String password2 = '';
  bool passCorrect = false;
  bool isRegistering = false;
  bool registerDone = false;
  int isRegisterError = 0;

  tryRegister() async {
    isRegisterError = 0;
    try {
      isRegistering = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: login,
        password: password2,
      );
      isRegistering = false;
      registerDone = true;
      isRegisterError = 0;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        isRegisterError = 1;
        isRegistering = false;
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        isRegisterError = 2;
        isRegistering = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  editLoginReg(value) {
    login = value;
    isRegisterError = 0;
    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;
    notifyListeners();
  }

  editPasswordReg(value) {
    password = value;
    isRegisterError = 0;
    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;
    notifyListeners();
  }

  editPasswordReg2(value) {
    password2 = value;
    isRegisterError = 0;
    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;

    notifyListeners();
  }
}
