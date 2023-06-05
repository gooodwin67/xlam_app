// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  String userName = '';
  List productsList = <Product>[];

  Future getDb(userId) async {
    dataIsLoaded = false;
    var db = FirebaseFirestore.instance;
    // var aa = await db.collection('users').get();
    // print(aa.toString());

    await db.collection("users").get().then((event) {
      //print(event.docs);
      for (var doc in event.docs) {
        //print("${doc.id} => ${doc.data()}");

        if (doc.id == userId) {
          //print(doc.data()['name']);
          userName = doc.data()['name'];
        }
      }
    });

    await db
        .collection("users")
        .doc(userId)
        .collection('Products')
        .get()
        .then((value) {
      productsList = <Product>[];
      for (var doc in value.docs) {
        if (doc.data()['active']) {
          productsList.add(
            Product(
                id: doc.data()['id'],
                name: doc.data()['name'],
                active: doc.data()['active']),
          );
        }
      }
      notifyListeners();
    });
    dataIsLoaded = true;
    notifyListeners();
  }
}

class Product {
  String id;
  String name;
  String photo = 'assets/images/prod1.jpg';
  bool active;
  Product({
    required this.id,
    required this.name,
    required this.active,
  });
}
