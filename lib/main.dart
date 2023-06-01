import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/provider/RegistrationScreenProvider.dart';
import 'package:xlam_app/provider/loginScreenProvider.dart';
import 'package:xlam_app/screens/login_screen/login_pass_enter_screen.dart';
import 'package:xlam_app/screens/login_screen/login_screen.dart';
import 'package:xlam_app/screens/login_screen/registration_screen.dart';
import 'package:xlam_app/screens/main_screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginScreenProvider()),
      ChangeNotifierProvider(create: (_) => RegistrationScreenProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreenWidget(),
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPassEnterScreen();
          },
        ),
        GoRoute(
          path: 'registration',
          builder: (BuildContext context, GoRouterState state) {
            return const RegistrationScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => MainScreenWidget(),
    ),
  ],
);
