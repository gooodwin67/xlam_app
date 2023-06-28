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
  List productsList = <Product>[];
  bool imageLoaded = false;
  var linkProd = '';

  Product newProduct = Product(
      active: false,
      id: '0',
      category: 0,
      name: '',
      photo: 'assets/images/prod1.jpg');

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
        .child('/${newProduct.name}-${incrementAll}-${increment}');

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
        .doc('${incrementAll}-${increment}')
        .set({
      'active': true,
      'idProd': '${incrementAll}-${increment}',
      'name': newProduct.name,
      'category': newProduct.category,
      'photo': linkProd
    });

    newProduct.name = '';
    nameIsLegal = false;
    image = null;
    imageLoaded = false;
    categoryIsLegal = false;
    print('YESSSSS');
  }

  Future getDb(userId) async {
    var db = FirebaseFirestore.instance;

    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == userId) {
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
              id: doc.data()['idProd'],
              category: doc.data()['category'],
              name: doc.data()['name'],
              active: doc.data()['active'],
              photo: doc.data()['photo'] ?? 'assets/images/prod1.jpg',
            ),
          );
        }
      }
    });

    dataIsLoaded = true;

    notifyListeners();
  }

  getName(text) {
    newProduct.name = text;
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
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 95);

    imageLoaded = true;
    newProduct.photo = image!.path;

    notifyListeners();
  }

  notifyListeners();
}

class Product {
  String id;
  num category;
  String name;
  String photo;
  bool active;
  Product({
    required this.id,
    required this.category,
    required this.name,
    required this.photo,
    required this.active,
  });
}
