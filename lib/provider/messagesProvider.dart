import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesProvider extends ChangeNotifier {
  List listChats = [];
  bool messagesDataIsLoaded = false;

  Future getChatsDB(userId) async {
    listChats = [];
    messagesDataIsLoaded = false;
    var db = FirebaseFirestore.instance;

    await db.collection("messages").get().then((value) async {
      for (var doc in value.docs) {
        if (doc.id.contains(userId)) {
          await db.collection('messages').doc(doc.id).get().then((value) {
            listChats.add(MessageBlock(
              name: value.data()!['user']['name'],
              id: value.data()!['user']['id'],
            ));
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
  MessageBlock({required this.name, required this.id});
}
