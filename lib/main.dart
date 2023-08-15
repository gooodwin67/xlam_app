import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/provider/RegistrationScreenProvider.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/loginScreenProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/provider/messageProvider.dart';
import 'package:xlam_app/provider/messagesProvider.dart';
import 'package:xlam_app/provider/prodScreenProvider.dart';
import 'package:xlam_app/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'provider/searchScreenProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginScreenProvider()),
      ChangeNotifierProvider(create: (_) => RegistrationScreenProvider()),
      ChangeNotifierProvider(create: (_) => MainProvider()),
      ChangeNotifierProvider(create: (_) => MainScreenProvider()),
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => ProdScreenProvider()),
      ChangeNotifierProvider(create: (_) => BottomBarProvider()),
      ChangeNotifierProvider(create: (_) => MessagesProvider()),
      ChangeNotifierProvider(create: (_) => MessageProvider()),
      ChangeNotifierProvider(create: (_) => SearchScreenProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        // channelGroups: [
        //   NotificationChannelGroup(
        //       channelGroupKey: 'basic_channel_group',
        //       channelGroupName: 'Basic group')
        // ],
        debug: true);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Mulish',
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
