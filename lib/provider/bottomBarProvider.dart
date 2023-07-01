import 'package:flutter/material.dart';

class BottomBarProvider extends ChangeNotifier {
  int selectedItem = 0;

  onItemTapped(int index) {
    selectedItem = index;
    notifyListeners();
  }
}
