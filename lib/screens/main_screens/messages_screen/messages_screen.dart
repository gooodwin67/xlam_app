import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/provider/messageProvider.dart';
import 'package:xlam_app/provider/messagesProvider.dart';
import 'package:xlam_app/screens/main_screens/bottom_bar.dart';

class MessagesScreenWidget extends StatefulWidget {
  const MessagesScreenWidget({super.key});

  @override
  State<MessagesScreenWidget> createState() => _MessagesScreenWidgetState();
}

class _MessagesScreenWidgetState extends State<MessagesScreenWidget> {
  @override
  void initState() {
    context
        .read<MessagesProvider>()
        .getChatsDB(context.read<MainProvider>().userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List messagesList = [];
    messagesList = context.read<MessagesProvider>().listChats;
    bool dataIsLoaded = context.watch<MessagesProvider>().messagesDataIsLoaded;
    print(messagesList.length);
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: Container(
          color: Color(0xffF3F2F8),
          child: WillPopScope(
              onWillPop: () {
                context.read<BottomBarProvider>().onItemTapped(0);
                context.read<MainScreenProvider>().getAllDb();
                ;
                context.go('/main');
                return Future((() => true));
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    floating: true,
                    pinned: false,
                    snap: false,
                    titleSpacing: 0,
                    backgroundColor: mainColor,
                    automaticallyImplyLeading: false,
                    expandedHeight: 60,
                    title: Padding(
                      padding: EdgeInsets.all(mainPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<BottomBarProvider>().onItemTapped(0);
                              context.read<MainScreenProvider>().getAllDb();
                              context.go('/main');
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            'Сообщения',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
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
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: !dataIsLoaded ? 6 : messagesList.length,
                        (context, index) {
                          return !dataIsLoaded
                              ? SpinKitWave(
                                  color: mainColor.withAlpha(50), size: 20.0)
                              : Padding(
                                  padding: EdgeInsets.only(
                                    //bottom: mainPadding / 2,
                                    top: mainPadding * 1.5,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<MessageProvider>()
                                          .getMessagesDB(
                                              '${messagesList[index].id2}-xl-${messagesList[index].id}-prod-${messagesList[index].idProd}',
                                              context
                                                  .read<MainProvider>()
                                                  .userId)
                                          .then((value) {
                                        context.go(
                                            '/main/messages/${messagesList[index].id2}-xl-${messagesList[index].id}-prod-${messagesList[index].idProd}');
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(mainPadding),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 214, 214, 214),
                                          )),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    messagesList[index].photo,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                messagesList[index].nameProd,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Spacer(),
                                              messagesList[index].newMessages >
                                                      0
                                                  ? Row(children: [
                                                      Icon(
                                                          Icons
                                                              .fiber_new_outlined,
                                                          color: mainColor),
                                                      Icon(
                                                          Icons
                                                              .message_outlined,
                                                          color: mainColor)
                                                    ])
                                                  : Icon(Icons.message_outlined,
                                                      color: Colors.grey),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: mainPadding,
                                                right: mainPadding,
                                                top: mainPadding),
                                            margin: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(
                                              // color: messagesList[index].myProd
                                              //     ? mainColor.withAlpha(80)
                                              //     : mainColor.withAlpha(150),
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(messagesList[index].name),
                                                Text('--'),
                                                Text(messagesList[index]
                                                    .newMessages
                                                    .toString()),
                                                SizedBox(width: 5),
                                                Container(
                                                  width: 100,
                                                  child: messagesList[index]
                                                          .myProd
                                                      ? Text(
                                                          'Предложил мне за',
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : Text(
                                                          'Я предложил за',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: mainColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '${messagesList[index].price} р.',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
