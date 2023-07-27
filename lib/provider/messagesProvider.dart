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
            listChats.add(MessageBlock(
              name: doc.id.contains(userId, 5)
                  ? value.data()!['user']['name1']
                  : value.data()!['user']['name2'],
              id: (doc.id.contains(userId, 5))
                  ? value.data()!['user']['id1']
                  : value.data()!['user']['id2'],
              id2: (doc.id.contains(userId, 5))
                  ? value.data()!['user']['id2']
                  : value.data()!['user']['id1'],
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
  String id2;
  MessageBlock({required this.name, required this.id, required this.id2});
}
