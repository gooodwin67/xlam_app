import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/messageProvider.dart';
import 'package:xlam_app/provider/messagesProvider.dart';
import 'package:xlam_app/screens/main_screens/bottom_bar.dart';

class MessageScreenWidget extends StatefulWidget {
  String? chatId;
  MessageScreenWidget({super.key, required this.chatId});

  @override
  State<MessageScreenWidget> createState() => _MessageScreenWidgetState();
}

class _MessageScreenWidgetState extends State<MessageScreenWidget> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(
    //     (_) => context.read<BottomBarProvider>().setNotifyTrue());
    context
        .read<MessageProvider>()
        .getMessagesDB(widget.chatId, context.read<MainProvider>().userId);
    super.initState();
  }

  final _controller = TextEditingController();

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('messages').snapshots();

  @override
  Widget build(BuildContext context) {
    bool dataIsLoaded = context.watch<MessageProvider>().messageDataIsLoaded;
    MessageWrapBlock message = context.watch<MessageProvider>().message;
    bool myMessagesFirst = context.read<MessagesProvider>().myMessagesFirst;

    bool canSnapshot = true;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: WillPopScope(
          onWillPop: () {
            context
                .read<MessagesProvider>()
                .getChatsDB(context.read<MainProvider>().userId);
            return Future((() => true));
          },
          child: Padding(
            padding: EdgeInsets.all(mainPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<MessagesProvider>()
                        .getChatsDB(context.read<MainProvider>().userId);
                    context.pop();
                  },
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                  ),
                ),
                !dataIsLoaded
                    ? Text('')
                    : Text(
                        'Переписка с ${message.name} ',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 20),
                      ),
                // InkWell(
                //   child: Icon(
                //     Icons.power_settings_new,
                //     color: Colors.grey,
                //   ),
                // ),
                SizedBox(width: 15),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: CustomScrollView(
              reverse: true,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: !dataIsLoaded ? 0 : message.messages.length,
                    ((context, index) {
                      return StreamBuilder(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.data != null) {
                              if (!myMessagesFirst) {
                                if (snapshot.data!.docs.first.get('id2new') >
                                        0 &&
                                    canSnapshot) {
                                  canSnapshot = false;
                                  context.read<MessageProvider>().getMessagesDB(
                                      widget.chatId,
                                      context.read<MainProvider>().userId);
                                }
                              } else {
                                if (snapshot.data!.docs.first.get('id1new') >
                                        0 &&
                                    canSnapshot) {
                                  canSnapshot = false;
                                  context.read<MessageProvider>().getMessagesDB(
                                      widget.chatId,
                                      context.read<MainProvider>().userId);
                                }
                              }
                            }

                            // context.read<MessageProvider>().getMessagesDB(
                            //     widget.chatId,
                            //     context.read<MainProvider>().userId);
                            return Padding(
                              padding: EdgeInsets.all(mainPadding),
                              child: Row(
                                mainAxisAlignment: dataIsLoaded
                                    ? message.messages[index].myMessage == true
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: dataIsLoaded
                                        ? message.messages[index].myMessage ==
                                                true
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          minWidth: 150,
                                        ),
                                        padding:
                                            EdgeInsets.all(mainPadding * 2),
                                        margin: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                          color: dataIsLoaded
                                              ? message.messages[index]
                                                          .myMessage ==
                                                      true
                                                  ? mainColor.withAlpha(100)
                                                  : Color.fromARGB(
                                                      255, 233, 233, 233)
                                              : Color.fromARGB(
                                                  255, 221, 221, 221),
                                          borderRadius: message.messages[index]
                                                      .myMessage ==
                                                  true
                                              ? const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                )
                                              : const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                        ),
                                        child: !dataIsLoaded
                                            ? SpinKitWave(
                                                color: mainColor.withAlpha(50),
                                                size: 20.0)
                                            : Text(
                                                message.messages[index].text),
                                      ),
                                      !dataIsLoaded
                                          ? SpinKitWave(
                                              color: mainColor.withAlpha(50),
                                              size: 5.0)
                                          : Text(
                                              DateFormat(
                                                      "dd. MM. yyyy HH:mm:ss")
                                                  .format(message
                                                      .messages[index].time
                                                      .toDate())
                                                  .toString(),
                                              style: TextStyle(fontSize: 11),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                width: double.infinity,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                alignment: Alignment.center,
                color: Color.fromARGB(255, 80, 255, 124),
                child:
                    Text('Предложил ${message.price} за ${message.nameProd}')),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: mainPadding),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(mainPadding),
                child: TextField(
                  onChanged: (value) {
                    context.read<MessageProvider>().changeMessageText(value);
                  },
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: Color(0xFFF6F6F6),
                    prefixIcon: Icon(Icons.add),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (context.read<MessageProvider>().messageTextLegal) {
                          FocusScope.of(context).unfocus();
                          context
                              .read<MessageProvider>()
                              .setMessage()
                              .then((value) {
                            context.read<MessageProvider>().getMessagesDB(
                                widget.chatId,
                                context.read<MainProvider>().userId);
                          });
                          _controller.clear();
                        }
                      },
                      child: Icon(
                        Icons.send_rounded,
                        color:
                            !context.watch<MessageProvider>().messageTextLegal
                                ? Colors.grey
                                : mainColor,
                      ),
                    ),
                    label: Text(
                      'Написать сообщение',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
