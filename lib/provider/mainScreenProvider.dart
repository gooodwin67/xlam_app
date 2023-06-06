import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  List Categories = [
    Category(nameCategory: 'Последние', iconCategory: Icons.star),
    Category(nameCategory: 'Одежда и обувь', iconCategory: Icons.settings),
    Category(nameCategory: 'Электроника', iconCategory: Icons.settings),
    Category(nameCategory: 'Для дома', iconCategory: Icons.settings),
    Category(nameCategory: 'Для детей', iconCategory: Icons.settings),
  ];

  List listIds = [];
  List listProds = [];
  Future getAllDb() async {
    var db = FirebaseFirestore.instance;
    await db.collection("users").get().then((value) {
      for (var doc in value.docs) {
        listIds.add(doc['id']);
      }
    });
    //print(listIds);
    for (var prod in listIds) {
      await db
          .collection("users")
          .doc(prod)
          .collection('Products')
          .get()
          .then((value) {
        //print(value.docs.length);
        for (var doc in value.docs) {
          print(doc.data());
        }
      });
    }
  }

  List Products = [
    Prod(
        nameProd: 'Диван-кровать в отличном состоянии',
        photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Ноутубк MSI X500', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Компьютерный стол', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
    Prod(nameProd: 'Термокружка', photoProd: 'assets/images/prod1.jpg'),
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
