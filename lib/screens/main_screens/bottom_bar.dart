import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('messages').snapshots();
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

        newMessages = 0;
        for (var doc in snapshot.data!.docs) {
          if (doc.id.contains(userId, 5)) {
            newMessages += int.parse(doc.get('id2new').toString());
          } else if (doc.id.contains(userId)) {
            newMessages += int.parse(doc.get('id1new').toString());
          }
        }

        return BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
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
                label: 'Messages'),
            context.read<MainProvider>().isLogin == true
                ? const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined), label: 'Account')
                : const BottomNavigationBarItem(
                    icon: Icon(Icons.person_add_alt_outlined),
                    label: 'Login/Register'),
          ],
          currentIndex: selectedItem,
          onTap: ((value) {
            context.read<BottomBarProvider>().onItemTapped(value);
            if (value == 0) {
              context
                  .read<MainScreenProvider>()
                  .getAllDb(context.read<MainScreenProvider>().activeCategory);
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
