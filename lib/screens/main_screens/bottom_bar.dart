import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedItem = context.watch<BottomBarProvider>().selectedItem;

    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined), label: 'Messages'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined), label: 'Account'),
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
          // context
          //     .read<AccountProvider>()
          //     .getDb(context.read<MainProvider>().userId);
          context.go('/main/messages');
        }
        if (value == 2) {
          context
              .read<AccountProvider>()
              .getDb(context.read<MainProvider>().userId);
          context.go('/main/account');
        }
      }),
    );
  }
}
