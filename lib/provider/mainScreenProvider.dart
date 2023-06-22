import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  List products = [];
  List listIds = [];

  Future getAllDb() async {
    dataIsLoaded = false;
    listIds = [];
    products = [];
    var db = FirebaseFirestore.instance;
    await db.collection("users").get().then((value) {
      for (var doc in value.docs) {
        listIds.add(doc['id']);
      }
    });

    for (var prod in listIds) {
      await db.collection("users").doc(prod).collection('Products').get().then(
        (value) {
          for (var doc in value.docs) {
            if (doc.data()['active'] == true) {
              products.add(
                Prod(
                    nameProd: doc.data()['name'],
                    photoProd: doc.data()['photo']),
              );
            }
          }
        },
      );
    }
    dataIsLoaded = true;
    notifyListeners();
  }

  List Categories = [
    Category(nameCategory: 'Последние', iconCategory: Icons.star),
    Category(nameCategory: 'Одежда и обувь', iconCategory: Icons.settings),
    Category(nameCategory: 'Электроника', iconCategory: Icons.settings),
    Category(nameCategory: 'Для дома', iconCategory: Icons.settings),
    Category(nameCategory: 'Для детей', iconCategory: Icons.settings),
  ];
}

class Category {
  String nameCategory;
  IconData iconCategory;
  Category({
    required this.nameCategory,
    required this.iconCategory,
  });
}

class Prod {
  String nameProd;
  String photoProd;
  Prod({
    required this.nameProd,
    required this.photoProd,
  });
}
