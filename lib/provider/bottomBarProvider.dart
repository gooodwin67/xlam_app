import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier {
  int selectedItem = 0;

  onItemTapped(int index) {
    selectedItem = index;
    notifyListeners();
  }
}
