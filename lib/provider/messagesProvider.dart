import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesProvider extends ChangeNotifier {
  List listChats = [];
  bool messagesDataIsLoaded = false;
  bool myMessagesFirst = false;

  Future getChatsDB(userId) async {
    listChats = [];
    messagesDataIsLoaded = false;
    var db = FirebaseFirestore.instance;

    await db.collection("messages").get().then((value) async {
      for (var doc in value.docs) {
        if (doc.id.contains(userId)) {
          doc.id.contains(userId, 5)
              ? myMessagesFirst = false
              : myMessagesFirst = true;

          await db.collection('messages').doc(doc.id).get().then((value) {
            if (!myMessagesFirst || value.data()!['user']['active'] == true) {
              listChats.add(MessageBlock(
                name: doc.id.contains(userId, 5)
                    ? value.data()!['user']['name1']
                    : value.data()!['user']['name2'],
                myProd: doc.id.contains(userId, 5) ? true : false,
                id: value.data()!['user']['id2'],
                id2: value.data()!['user']['id1'],
                price: value.data()!['user']['price'] ?? '',
                nameProd: value.data()!['user']['nameProd'] ?? '',
                photo: value.data()!['user']['photo'] ?? '',
                idProd: value.data()!['user']['idProd'],
                newMessages: doc.id.contains(userId, 5)
                    ? value.data()!['id2new']
                    : value.data()!['id1new'],
              ));
            }
          });
        }
      }
      messagesDataIsLoaded = true;
      notifyListeners();
    });
  }
}

class MessageBlock {
  String name;
  String id;
  String id2;
  String price = '';
  String idProd;
  String nameProd;
  String photo;
  bool myProd;
  int newMessages = 0;
  MessageBlock({
    required this.name,
    required this.id,
    required this.id2,
    required this.price,
    required this.idProd,
    required this.nameProd,
    required this.photo,
    required this.myProd,
    required this.newMessages,
  });
}
