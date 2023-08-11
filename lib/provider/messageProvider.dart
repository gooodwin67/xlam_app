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

  int id1new = 0;
  int id2new = 0;

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
    Map userData = {};
    if (myMessagesFirst) {
      await db.collection("messages").doc(allChatId).get().then((value) {
        id2new = value.data()!['id2new'] + 1;
      });
      await db.collection("messages").doc(allChatId).update({
        'firstMessages': FieldValue.arrayUnion([
          {'text': messageText, 'time': myTimeStamp}
        ]),
        'id2new': id2new
      });
    } else {
      await db.collection("messages").doc(allChatId).get().then((value) {
        id1new = value.data()!['id1new'] + 1;
      });

      await db.collection("messages").doc(allChatId).update({
        'secondMessages': FieldValue.arrayUnion([
          {'text': messageText, 'time': myTimeStamp}
        ]),
        'id1new': id1new
      });

      await db.collection("messages").doc(allChatId).get().then((value) {
        if (value.data()!['user']['active'] == false) {
          userData = value.data()!['user'];
          userData['active'] = true;
          db.collection("messages").doc(allChatId).update({'user': userData});
        }
      });
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
      if (chatId.contains(myId, 5)) {
        myMessagesFirst = false;
        if (value.data()!['id2new'] > 0) {
          id2new = 0;
          print('aaaaaa');
          db.collection('messages').doc(chatId).update({'id2new': id2new});
        }
      } else {
        myMessagesFirst = true;
        if (value.data()!['id1new'] > 0) {
          id1new = 0;
          print('bbbbbb');
          db.collection('messages').doc(chatId).update({'id1new': id1new});
        }
      }

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
