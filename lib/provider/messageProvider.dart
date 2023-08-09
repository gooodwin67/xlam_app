// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageProvider extends ChangeNotifier {
  List listAllMessages = [];
  List listMyMessages = [];
  List listHimMessages = [];
  bool messageDataIsLoaded = false;
  MessageWrapBlock message = MessageWrapBlock(
      name: 'name', id: 'id', messages: [], price: '', nameProd: '');
  String allChatId = '';
  String messageText = '';
  bool messageTextLegal = false;
  bool myMessagesFirst = false;

  changeMessageText(value) {
    if (value != '') {
      messageTextLegal = true;
    } else {
      messageTextLegal = false;
    }

    messageText = value;
  }

  Future setMessage() async {
    //print(myMessagesFirst);
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
        ]),
      });

      Map userData = {};

      await db.collection("messages").doc(allChatId).get().then((value) {
        userData = value.data()!['user'];
        userData['active'] = true;
      });

      await db.collection("messages").doc(allChatId).update({'user': userData});
    }
    messageTextLegal = false;
    notifyListeners();
  }

  Future getMessagesDB(chatId, myId) async {
    listAllMessages = [];
    listMyMessages = [];
    listHimMessages = [];
    messageDataIsLoaded = false;
    String himId = '';
    chatId.contains(myId, 5)
        ? himId = chatId.split('-')[0]
        : himId = chatId.split('-')[2];
    allChatId = chatId;

    var db = FirebaseFirestore.instance;

    await db.collection('messages').doc(chatId).get().then((value) {
      chatId.contains(myId, 5)
          ? myMessagesFirst = false
          : myMessagesFirst = true;

      if (!chatId.contains(himId, 5)) {
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

      if (listAllMessages.length > 0) {
        listAllMessages.sort(((a, b) {
          return b.time.seconds - a.time.seconds;
        }));
      }

      message = MessageWrapBlock(
        name: chatId.contains(himId, 5)
            ? value.data()!['user']['name2']
            : value.data()!['user']['name1'],
        id: chatId.contains(himId, 5)
            ? value.data()!['user']['id2']
            : value.data()!['user']['id1'],
        messages: listAllMessages,
        price: value.data()!['user']['price'],
        nameProd: value.data()!['user']['nameProd'] ?? '',
      );

      // await db.collection("messages").get().then((value) async {
      //   for (var doc in value.docs) {
      //     if (doc.id.contains(himId) && doc.id.contains(myId)) {
      //       allChatId = doc.id;

      //       doc.id.contains(myId, 5)
      //           ? myMessagesFirst = false
      //           : myMessagesFirst = true;

      //       await db.collection('messages').doc(doc.id).get().then((value) {
      //         if (!doc.id.contains(himId, 5)) {
      //           listMyMessages = value.data()!['secondMessages'].map((e) {
      //             return MessageBlock(
      //                 text: e['text'], time: e['time'], myMessage: true);
      //           }).toList();

      //           listHimMessages = value.data()!['firstMessages'].map((e) {
      //             return MessageBlock(
      //                 text: e['text'], time: e['time'], myMessage: false);
      //           }).toList();
      //         } else {
      //           listMyMessages = value.data()!['firstMessages'].map((e) {
      //             return MessageBlock(
      //                 text: e['text'], time: e['time'], myMessage: true);
      //           }).toList();

      //           listHimMessages = value.data()!['secondMessages'].map((e) {
      //             return MessageBlock(
      //                 text: e['text'], time: e['time'], myMessage: false);
      //           }).toList();
      //         }

      //         listAllMessages = listMyMessages + listHimMessages;

      //         if (listAllMessages.length > 0) {
      //           listAllMessages.sort(((a, b) {
      //             return b.time.seconds - a.time.seconds;
      //           }));
      //         }

      //         message = MessageWrapBlock(
      //             name: doc.id.contains(himId, 5)
      //                 ? value.data()!['user']['name2']
      //                 : value.data()!['user']['name1'],
      //             id: doc.id.contains(himId, 5)
      //                 ? value.data()!['user']['id2']
      //                 : value.data()!['user']['id1'],
      //             messages: listAllMessages,
      //             price: value.data()!['user']['price']);
      //       });
      //     }
      //   }

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
  String price;
  String nameProd;
  MessageWrapBlock(
      {required this.name,
      required this.id,
      required this.messages,
      required this.price,
      required this.nameProd});
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
