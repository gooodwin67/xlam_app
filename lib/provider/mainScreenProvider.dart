import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  List products = [];
  List listIds = [];
  String nameCategory = 'Последние';
  num activeCategory = 0;

  Future getAllDb(category) async {
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
            if (doc.data()['active'] == true &&
                (doc.data()['category'] == category || category == 0)) {
              products.add(
                Prod(
                    id: doc.data()['idProd'],
                    category: doc.data()['category'],
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

  changeName(index) {
    nameCategory = Categories[index].nameCategory;
    activeCategory = index;
  }

  List Categories = [
    Category(
        nameCategory: 'Последние', iconCategory: Icons.star, numCategory: 0),
    Category(
        nameCategory: 'Одежда и обувь',
        iconCategory: Icons.settings,
        numCategory: 1),
    Category(
        nameCategory: 'Электроника',
        iconCategory: Icons.settings,
        numCategory: 2),
    Category(
        nameCategory: 'Для дома', iconCategory: Icons.settings, numCategory: 3),
    Category(
        nameCategory: 'Для детей',
        iconCategory: Icons.settings,
        numCategory: 4),
  ];
}

class Category {
  String nameCategory;
  IconData iconCategory;
  num numCategory;
  Category({
    required this.nameCategory,
    required this.iconCategory,
    required this.numCategory,
  });
}

class Prod {
  num id;
  num category;
  String nameProd;
  String photoProd;
  Prod({
    required this.id,
    required this.category,
    required this.nameProd,
    required this.photoProd,
  });
}
