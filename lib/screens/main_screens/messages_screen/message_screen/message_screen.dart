import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/messageProvider.dart';
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

  @override
  Widget build(BuildContext context) {
    bool dataIsLoaded = context.watch<MessageProvider>().messageDataIsLoaded;
    MessageWrapBlock message = context.watch<MessageProvider>().message;
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
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: !dataIsLoaded ? 2 : message.messages.length,
              ((context, index) {
                return Padding(
                  padding: EdgeInsets.all(mainPadding),
                  child: Container(
                    padding: EdgeInsets.all(mainPadding * 2),
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: mainColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: !dataIsLoaded
                        ? SpinKitWave(
                            color: mainColor.withAlpha(50), size: 20.0)
                        : Row(
                            mainAxisAlignment:
                                message.messages[index].myMessage == true
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                            children: [
                              Text(message.messages[index].text),
                            ],
                          ),
                  ),
                );
              }),
            ),
          )
        ],
      )),
    );
  }
}
