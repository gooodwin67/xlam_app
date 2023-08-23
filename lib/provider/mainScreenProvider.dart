import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  List products = [];
  List listIds = [];
  String nameCategory = 'Последние';
  num activeCategory = 0;
  String activeCity = 'Все города';

  Future getAllDb() async {
    dataIsLoaded = false;
    notifyListeners();
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
                (doc.data()['city'] == activeCity ||
                    activeCity == 'Все города') &&
                (doc.data()['category'] == activeCategory ||
                    activeCategory == 0)) {
              print(activeCategory);
              products.add(
                Prod(
                  id: doc.data()['idProd'],
                  category: doc.data()['category'],
                  nameProd: doc.data()['name'],
                  photoProd: doc.data()['photo'],
                  city: doc.data()['city'] ?? '',
                ),
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

  changeActieCity(city) {
    activeCity = city;
  }

  List Categories = [
    Category(
        nameCategory: 'Последние', iconCategory: Icons.star, numCategory: 0),
    Category(
        nameCategory: 'Одежда и обувь',
        iconCategory: Icons.checkroom_outlined,
        numCategory: 1),
    Category(
        nameCategory: 'Электроника',
        iconCategory: Icons.dvr_outlined,
        numCategory: 2),
    Category(
      nameCategory: 'Для дома',
      iconCategory: Icons.home_outlined,
      numCategory: 3,
    ),
    Category(
        nameCategory: 'Для детей',
        iconCategory: Icons.child_care_outlined,
        numCategory: 4),
    Category(
        nameCategory: 'Хобби и отдых',
        iconCategory: Icons.sports_baseball_outlined,
        numCategory: 5),
    Category(
        nameCategory: 'Красота и здоровье',
        iconCategory: Icons.healing_outlined,
        numCategory: 6),
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
  String id;
  num category;
  String nameProd;
  String photoProd;
  String city;
  Prod({
    required this.id,
    required this.category,
    required this.nameProd,
    required this.photoProd,
    required this.city,
  });
}
