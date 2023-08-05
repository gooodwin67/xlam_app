// GoRouter configuration

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/screens/login_screen/login_pass_enter_screen.dart';
import 'package:xlam_app/screens/login_screen/login_screen.dart';
import 'package:xlam_app/screens/login_screen/registration_screen.dart';
import 'package:xlam_app/screens/main_screens/account_screen/account_screen.dart';
import 'package:xlam_app/screens/main_screens/messages_screen/message_screen/message_screen.dart';
import 'package:xlam_app/screens/main_screens/messages_screen/messages_screen.dart';
import 'package:xlam_app/screens/main_screens/prod_screen/prod_screen.dart';
import 'package:xlam_app/screens/main_screens/main_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginScreenWidget();
      },
      // redirect: (context, state) async {
      //   await context.read<MainProvider>().isLogining();
      //   // if (context.read<MainProvider>().isLogin == true) {
      //   //   print('userIsLogged');
      //   //   return '/main';
      //   // } else {
      //   //   print('notLogged');
      //   //   return null;
      //   // }
      //   print('userIsLogged');
      //   return '/main';
      // },
      routes: <RouteBase>[],
    ),
    GoRoute(
        path: '/main',
        builder: (context, state) => MainScreenWidget(),
        routes: [
          GoRoute(
              path: 'login',
              builder: (BuildContext context, GoRouterState state) {
                return const LoginPassEnterScreen();
              },
              routes: [
                GoRoute(
                  path: 'registration',
                  builder: (BuildContext context, GoRouterState state) {
                    return const RegistrationScreen();
                  },
                ),
              ]),
          GoRoute(
            path: 'account',
            builder: (BuildContext context, GoRouterState state) {
              return const AccountScreenWidget();
            },
          ),
          GoRoute(
              path: 'messages',
              builder: (BuildContext context, GoRouterState state) {
                return const MessagesScreenWidget();
              },
              routes: [
                GoRoute(
                  path: ':chatId',
                  builder: (BuildContext context, GoRouterState state) {
                    return MessageScreenWidget(
                      chatId: state.pathParameters['chatId'],
                    );
                  },
                ),
              ]),
          GoRoute(
            path: ':prodId',
            builder: (BuildContext context, GoRouterState state) {
              return ProdScreenWidget(
                prodId: state.pathParameters['prodId'],
              );
            },
          ),
        ]),
  ],
);
