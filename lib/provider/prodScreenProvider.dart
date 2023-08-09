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
  String myName = '';
  String myId = '';
  int dialogIsEnabled = 0;
  String allChatId = '';

  bool iLikedProd = false;

  String price = '';
  String comment = 'Не оставил комментарий';

  editPrice(value) {
    price = value;
    notifyListeners();
  }

  editComment(value) {
    if (value != '') {
      comment = value;
    } else {
      comment = 'Не оставил комментарий';
    }
  }

  clearData() {
    price = '';
    comment = 'Не оставил комментарий';
  }

  Future checkDialog(id1, id2, name2) async {
    var db = FirebaseFirestore.instance;

    await db.collection("messages").get().then((value) {
      dialogIsEnabled = 0;
      for (var doc in value.docs) {
        if (doc.id.contains(id2) && doc.id.contains(id1)) {
          if (doc.id.contains(id2, 5)) {
            dialogIsEnabled = 2;
          } else {
            dialogIsEnabled = 1;
          }
        }
      }
    });
  }

  Future setDialog(id1, id2, name2, idProd) async {
    var db = FirebaseFirestore.instance;

    if (dialogIsEnabled == 0) {
      await db.collection("users").doc(id1).get().then((value) {
        myName = value.data()!['name'];
      });
      allChatId = '$id1-xl-$id2-prod-$idProd';
      await db.collection("messages").doc('$id1-xl-$id2-prod-$idProd').set(
        {
          'user': {
            'id1': id1,
            'id2': id2,
            'name1': myName,
            'name2': name2,
            'idProd': idProd,
            'active': false,
            'price': price,
            'nameProd': docName
          },
          'firstMessages': [],
          'secondMessages': [],
        },
      );
    } else {}

    await db.collection("users").doc(myId).update({
      'likeProds': FieldValue.arrayUnion([
        {'idProd': idProd}
      ])
    });
  }

  Future setFirstMessage() async {
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp
    DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime

    var db = FirebaseFirestore.instance;
    await db.collection("messages").doc(allChatId).update({
      'firstMessages': FieldValue.arrayUnion([
        {'text': comment, 'time': myTimeStamp}
      ])
    });
    notifyListeners();
  }

  Future getAllProds(userId, prodId) async {
    dataIsLoaded = false;
    listIds = [];
    products = [];
    myId = userId;
    var db = FirebaseFirestore.instance;
    await db.collection("users").get().then((value) {
      for (var doc in value.docs) {
        listIds.add(doc['id']);
      }
    });

    await db.collection("users").doc(userId).get().then((value) {
      iLikedProd = false;
      for (var i in value.data()!['likeProds']) {
        if (i['idProd'] == prodId) {
          iLikedProd = true;
        }
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
