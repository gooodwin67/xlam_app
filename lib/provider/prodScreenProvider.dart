import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProdScreenProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  List products = [];
  List listIds = [];
  String nameUser = 'name';
  String idUser = 'idUser';
  String docId = '';
  String docPhoto = '';
  String docName = '';
  bool myProd = false;

  Future getAllProds(userId, prodId) async {
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
              if (prod == userId) {
                myProd = true;
                print('мое');
              } else {
                print(userId);
                myProd = false;
              }
              // NameUser = doc.data()['nameUser'].toString();
              docId = doc.data()['idProd'].toString();
              // docPhoto = doc.data()['photo'].toString();
              docName = doc.data()['name'].toString();
              products.add(
                Prod(
                    idUser: doc.data()['idUser'] ?? 'idUser',
                    nameUser: doc.data()['nameUser'] ?? 'nameUser',
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

  Future deleteProduct(prodId) async {
    dataIsLoaded = false;
    notifyListeners();
    var db = FirebaseFirestore.instance;
    await db.collection("users").get().then((value) {
      for (var doc in value.docs) {
        listIds.add(doc['id']);
      }
    });

    for (var prod in listIds) {
      await db
          .collection("users")
          .doc(prod)
          .collection('Products')
          .doc(docId)
          .delete()
          .then(
        (doc) {
          print("Document deleted");
        },
        onError: (e) => print("Error updating document $e"),
      );
    }
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('products')
        .child('/${docName}-${docId}');
    await ref.delete();
  }
}

class Prod {
  String idUser;
  String nameUser;
  String id;
  String nameProd;
  String photoProd;
  Prod({
    required this.idUser,
    required this.nameUser,
    required this.id,
    required this.nameProd,
    required this.photoProd,
  });
}
