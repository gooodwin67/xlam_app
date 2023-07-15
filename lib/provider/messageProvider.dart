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
  String allChatId = '';
  String messageText = '';
  bool messageTextLegal = false;

  changeMessageText(value) {
    if (value != '') {
      messageTextLegal = true;
    } else {
      messageTextLegal = false;
    }

    messageText = value;
  }

  Future setMessage(myMessagesFirst) async {
    print(myMessagesFirst);
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp
    DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime

    var db = FirebaseFirestore.instance;
    if (myMessagesFirst) {
      await db.collection("messages").doc(allChatId).update({
        'firstMessages': FieldValue.arrayUnion([
          {'text': messageText, 'time': myTimeStamp}
        ])
      });
    } else {
      await db.collection("messages").doc(allChatId).update({
        'secondMessages': FieldValue.arrayUnion([
          {'text': messageText, 'time': myTimeStamp}
        ])
      });
    }
    messageTextLegal = false;
    notifyListeners();
  }

  Future getMessagesDB(chatId) async {
    listAllMessages = [];
    listMyMessages = [];
    listHimMessages = [];
    messageDataIsLoaded = false;

    var db = FirebaseFirestore.instance;

    await db.collection("messages").get().then((value) async {
      for (var doc in value.docs) {
        if (doc.id.contains(chatId)) {
          allChatId = doc.id;

          await db.collection('messages').doc(doc.id).get().then((value) {
            if (!doc.id.contains(chatId, 5)) {
              listMyMessages = value.data()!['secondMessages'].map((e) {
                return MessageBlock(
                    text: e['text'], time: e['time'], myMessage: true);
              }).toList();
              listHimMessages = value.data()!['firstMessages'].map((e) {
                return MessageBlock(
                    text: e['text'], time: e['time'], myMessage: false);
              }).toList();
            } else {
              listMyMessages = value.data()!['firstMessages'].map((e) {
                return MessageBlock(
                    text: e['text'], time: e['time'], myMessage: true);
              }).toList();
              listHimMessages = value.data()!['secondMessages'].map((e) {
                return MessageBlock(
                    text: e['text'], time: e['time'], myMessage: false);
              }).toList();
            }

            listAllMessages = listMyMessages + listHimMessages;
            listAllMessages.sort(((a, b) {
              return b.time.seconds - a.time.seconds;
            }));

            message = MessageWrapBlock(
              name: doc.id.contains(chatId, 5)
                  ? value.data()!['user']['name2']
                  : value.data()!['user']['name1'],
              id: doc.id.contains(chatId, 5)
                  ? value.data()!['user']['id2']
                  : value.data()!['user']['id1'],
              messages: listAllMessages,
            );
          });
        }
      }

      // var millis = listAllMessages[0].time.seconds * 1000;
      // var dt = DateTime.fromMillisecondsSinceEpoch(millis);
      // var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00

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
