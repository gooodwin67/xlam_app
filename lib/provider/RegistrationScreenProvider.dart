import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreenProvider extends ChangeNotifier {
  String login = '';
  String password = '';
  String password2 = '';
  bool passCorrect = false;

  bool isRegistering = false;

  tryRegister() async {
    print(login);
    try {
      isRegistering = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: login,
        password: password2,
      );
      isRegistering = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  editLoginReg(value) {
    login = value;

    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;
    notifyListeners();
  }

  editPasswordReg(value) {
    password = value;

    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;
    notifyListeners();
  }

  editPasswordReg2(value) {
    password2 = value;

    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;

    print(passCorrect);
    notifyListeners();
  }
}
