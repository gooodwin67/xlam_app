import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/main.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/provider/messagesProvider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  bool _isInForeground = true;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('messages').snapshots();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int selectedItem = context.watch<BottomBarProvider>().selectedItem;
    int newMessages = 0;
    String userId = context.read<MainProvider>().userId;

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        for (var doc in snapshot.data!.docs) {
          if (doc.id.indexOf(userId) > 5 && doc.get('id2new') > 0) {
            newMessages = int.parse(doc.get('id2new').toString());
            if (!_isInForeground && newMessages > 0) {
              Noti.showBigTextNotification(
                  title: 'Title',
                  body: 'TextBody',
                  fln: flutterLocalNotificationsPlugin);
            }
          } else if (doc.id.indexOf(userId) < 5 && doc.get('id1new') > 0) {
            newMessages = int.parse(doc.get('id1new').toString());
            if (!_isInForeground) {
              Noti.showBigTextNotification(
                  title: 'Title',
                  body: 'TextBody',
                  fln: flutterLocalNotificationsPlugin);
            }
          }
        }
        return BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Главная'),
            BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.message_outlined),
                    Container(
                      width: 15,
                      height: 15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            newMessages > 0 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        newMessages.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                label: 'Сообщения'),
            context.read<MainProvider>().isLogin == true
                ? const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined), label: 'Аккаунт')
                : const BottomNavigationBarItem(
                    icon: Icon(Icons.person_add_alt_outlined),
                    label: 'Вход/Рег'),
          ],
          currentIndex: selectedItem,
          onTap: ((value) {
            context.read<BottomBarProvider>().onItemTapped(value);
            if (value == 0) {
              context.read<MainScreenProvider>().getAllDb();
              ;
              context.go('/main');
            }
            if (value == 1) {
              if (context.read<MainProvider>().isLogin == true) {
                context.go('/main/messages');
              } else {
                context.go('/main/login');
              }
            }
            if (value == 2) {
              if (context.read<MainProvider>().isLogin == true) {
                context.read<BottomBarProvider>().onItemTapped(2);
                context.go('/main/account');
              } else {
                context.go('/main/login');
              }
            }
          }),
        );
      },
    );
  }
}
