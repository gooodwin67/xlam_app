import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier {
  int selectedItem = 0;
  //bool canNotify = true;

  onItemTapped(int index) {
    selectedItem = index;
    notifyListeners();
  }

  // setNotifyTrue() {
  //   canNotify = true;
  // }

  // setNotifyFalse() {
  //   canNotify = false;
  // }
}
