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
        context.read<MainProvider>().isLogin == true
            ? BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Account')
            : BottomNavigationBarItem(
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
  }
}
