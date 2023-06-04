import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  String userName = '';
  Future getDb(userId) async {
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

    final docRef = db.collection("users").doc("Products");
    print(docRef.collection('111'));

    notifyListeners();
  }
}
