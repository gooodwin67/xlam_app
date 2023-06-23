import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdScreenProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  List products = [];
  List listIds = [];

  Future getAllProds(prodId) async {
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
            if (doc.data()['idProd'].toString() == prodId.toString()) {
              products.add(
                Prod(
                    id: doc.data()['idProd'],
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
}

class Prod {
  num id;
  String nameProd;
  String photoProd;
  Prod({
    required this.id,
    required this.nameProd,
    required this.photoProd,
  });
}
