import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  Future getDb() async {
    var db = FirebaseFirestore.instance;
    // var aa = await db.collection('users').get();
    // print(aa.toString());

    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }
}
