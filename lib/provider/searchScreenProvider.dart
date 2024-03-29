import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreenProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  List products = [];
  List listIds = [];

  String searchText = '';
  bool searchingNow = false;

  startSearching() {
    searchingNow = true;
    notifyListeners();
  }

  Future getAllDbWithSearch() async {
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
            if (doc
                    .data()['name']
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .contains(searchText.toLowerCase().replaceAll(' ', '')) &&
                doc.data()['active'] == true) {
              products.add(
                Prod(
                  id: doc.data()['idProd'],
                  category: doc.data()['category'],
                  nameProd: doc.data()['name'] ?? '',
                  photoProd: doc.data()['photo'] ?? '',
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
    searchingNow = false;
  }

  changeSearchText(value) {
    searchText = value;
  }
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
