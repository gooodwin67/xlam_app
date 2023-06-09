// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';

class AccountProvider extends ChangeNotifier {
  bool dataIsLoaded = false;
  bool nameIsLegal = false;
  bool categoryIsLegal = false;
  String userName = '';
  String userId = '';
  List productsList = <Product>[];
  bool imageLoaded = false;
  var linkProd = '';

  clearDataFromBottomSheet() {
    dataIsLoaded = false;
    nameIsLegal = false;
    categoryIsLegal = false;
    imageLoaded = false;
    image = null;
  }

  Product newProduct = Product(
      active: false,
      id: '0',
      idUser: '0',
      nameUser: 'nameUser',
      category: 0,
      nameProd: '',
      photoProd: 'assets/images/prod1.jpg');

  Future setDb(userId) async {
    num increment = 0;
    num incrementAll = 0;
    var db = FirebaseFirestore.instance;
    await db.collection("users").doc(userId).get().then((value) {
      increment = value.data()!['userProdInc'] + 1;
    });
    await db.collection("users").doc(userId).update({'userProdInc': increment});

    await db.collection("ids").doc('increment').get().then((value) {
      incrementAll = value.data()!['inc'] + 1;
    });
    await db.collection("ids").doc('increment').update({'inc': incrementAll});

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('products')
        .child('/${newProduct.nameProd}-$incrementAll-$increment');

    try {
      await ref.putFile(File(image!.path));
      linkProd = await ref.getDownloadURL();
    } catch (e) {
      print(e);
    }

    await db
        .collection("users")
        .doc(userId)
        .collection('Products')
        .doc('$incrementAll-$increment')
        .set({
      'active': true,
      'idProd': '$incrementAll-$increment',
      'idUser': userId,
      'nameUser': userName,
      'name': newProduct.nameProd,
      'category': newProduct.category,
      'photo': linkProd
    });

    newProduct.nameProd = '';
    nameIsLegal = false;
    image = null;
    imageLoaded = false;
    categoryIsLegal = false;
  }

  Future getDb(userId) async {
    var db = FirebaseFirestore.instance;

    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == userId) {
          userName = doc.data()['name'];
          userId = doc.data()['id'];
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
              id: doc.data()['idProd'],
              idUser: doc.data()['idUser'],
              nameUser: doc.data()['nameUser'],
              category: doc.data()['category'],
              nameProd: doc.data()['name'],
              active: doc.data()['active'],
              photoProd: doc.data()['photo'] ?? 'assets/images/prod1.jpg',
            ),
          );
        }
      }
    });

    dataIsLoaded = true;

    notifyListeners();
  }

  getName(text) {
    newProduct.nameProd = text;
    if (text != '') {
      nameIsLegal = true;
      notifyListeners();
    } else {
      nameIsLegal = false;
      notifyListeners();
    }
  }

  changeCategory(value) {
    categoryIsLegal = true;
    newProduct.category = value;
    notifyListeners();
  }

  XFile? image;

  Future getImage(ImageSource media) async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(
        source: media, maxWidth: 600, maxHeight: 600, imageQuality: 95);

    if (image != null) {
      newProduct.photoProd = image!.path;
    }

    imageLoaded = true;

    notifyListeners();
  }

  notifyListeners();
}

class Product {
  String id;
  String idUser;
  String nameUser;
  num category;
  String nameProd;
  String photoProd;
  bool active;
  Product({
    required this.id,
    required this.idUser,
    required this.nameUser,
    required this.category,
    required this.nameProd,
    required this.photoProd,
    required this.active,
  });
}
