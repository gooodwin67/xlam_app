import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreenProvider extends ChangeNotifier {
  String name = '';
  String login = '';
  String password = '';
  String password2 = '';
  bool passCorrect = false;
  bool isNameCorrect = false;
  bool isCityCorrect = false;
  bool isRegistering = false;
  bool registerDone = false;
  int isRegisterError = 0;
  String city = '';

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

      var userId;

      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null) {
          userId = user.uid;
          print(user.uid);

          var db = FirebaseFirestore.instance;
          await db.collection("users").doc(user.uid).set({
            'id': user.uid,
            'name': name,
            'userProdInc': 0,
            'city': city,
          });
        }
      });

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

  editNameReg(value) {
    name = value;
    name != '' ? isNameCorrect = true : isNameCorrect = false;
    isRegisterError = 0;
    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;
    notifyListeners();
  }

  editLoginReg(value) {
    login = value;
    isRegisterError = 0;
    password2 != '' && password2 == password && login != ''
        ? passCorrect = true
        : passCorrect = false;
    notifyListeners();
  }

  editCity(value) {
    city = value;
    isRegisterError = 0;
    if (city != '')
      isCityCorrect = true;
    else
      isCityCorrect = false;

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
