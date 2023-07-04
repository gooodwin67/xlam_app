// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageProvider extends ChangeNotifier {
  List listAllMessages = [];
  List listMyMessages = [];
  List listHimMessages = [];
  bool messageDataIsLoaded = false;
  MessageWrapBlock message =
      MessageWrapBlock(name: 'name', id: 'id', messages: []);

  Future getMessagesDB(chatId) async {
    listAllMessages = [];
    listMyMessages = [];
    listHimMessages = [];
    messageDataIsLoaded = false;

    var db = FirebaseFirestore.instance;

    await db.collection("messages").get().then((value) async {
      for (var doc in value.docs) {
        if (doc.id.contains(chatId)) {
          await db.collection('messages').doc(doc.id).get().then((value) {
            listMyMessages = value.data()!['myMessages'].map((e) {
              return MessageBlock(
                  text: e['text'], time: e['time'], myMessage: true);
            }).toList();

            listHimMessages = value.data()!['secondMessages'].map((e) {
              return MessageBlock(
                  text: e['text'], time: e['time'], myMessage: false);
            }).toList();
            listAllMessages = listMyMessages + listHimMessages;
            listAllMessages.sort(((a, b) {
              return a.time.seconds - b.time.seconds;
            }));

            message = MessageWrapBlock(
              name: value.data()!['user']['name'],
              id: value.data()!['user']['id'],
              messages: listAllMessages,
            );
          });
        }
      }

      var millis = listAllMessages[0].time.seconds * 1000;
      var dt = DateTime.fromMillisecondsSinceEpoch(millis);
      var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00

      print(listAllMessages);
      messageDataIsLoaded = true;
      notifyListeners();
    });
  }
}

class MessageWrapBlock {
  String name;
  String id;
  List messages;
  MessageWrapBlock(
      {required this.name, required this.id, required this.messages});
}

class MessageBlock {
  String text;
  Timestamp time;
  bool myMessage;
  MessageBlock({
    required this.text,
    required this.time,
    required this.myMessage,
  });
}