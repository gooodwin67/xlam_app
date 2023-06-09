import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
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
    context.read<MessageProvider>().getMessagesDB(widget.chatId);
    super.initState();
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool dataIsLoaded = context.watch<MessageProvider>().messageDataIsLoaded;
    MessageWrapBlock message = context.watch<MessageProvider>().message;
    bool myMessagesFirst = context.read<MessagesProvider>().myMessagesFirst;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.all(mainPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => context.pop(),
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
              InkWell(
                child: Icon(
                  Icons.power_settings_new,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      body: RefreshIndicator(
        onRefresh: () {
          context.read<MessageProvider>().getMessagesDB(widget.chatId);
          setState(() {});
          return Future((() => true));
        },
        child: SafeArea(
            child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: CustomScrollView(
                reverse: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: !dataIsLoaded ? 15 : message.messages.length,
                      ((context, index) {
                        return Padding(
                          padding: EdgeInsets.all(mainPadding),
                          child: Row(
                            mainAxisAlignment: dataIsLoaded
                                ? message.messages[index].myMessage == true
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(mainPadding * 2),
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  color: dataIsLoaded
                                      ? message.messages[index].myMessage ==
                                              true
                                          ? mainColor.withAlpha(100)
                                          : Color.fromARGB(255, 233, 233, 233)
                                      : Color.fromARGB(255, 221, 221, 221),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: !dataIsLoaded
                                    ? SpinKitWave(
                                        color: mainColor.withAlpha(50),
                                        size: 20.0)
                                    : Text(message.messages[index].text),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: mainPadding),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(mainPadding),
                  color: mainColor,
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
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      prefixIcon: Icon(Icons.add),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (context
                              .read<MessageProvider>()
                              .messageTextLegal) {
                            FocusScope.of(context).unfocus();
                            context
                                .read<MessageProvider>()
                                .setMessage(myMessagesFirst);
                            _controller.clear();
                            context
                                .read<MessageProvider>()
                                .getMessagesDB(widget.chatId);
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
                        borderSide: BorderSide(
                            // color: context
                            //         .read<AccountProvider>()
                            //         .nameIsLegal
                            //     ? Colors.transparent
                            //     : Colors.red,
                            width: 0),
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
      ),
    );
  }
}
