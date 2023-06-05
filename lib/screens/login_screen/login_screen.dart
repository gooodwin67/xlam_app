import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xlam_app/constants/constants.dart';

class LoginScreenWidget extends StatelessWidget {
  const LoginScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLoginScreen();
  }
}

class MainLoginScreen extends StatelessWidget {
  const MainLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(mainPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text('Жалко выкинуть',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),
                Text('Сервис продажи и дарения ненужных вещей',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: mainPadding * 7.5),
                  child: Image.asset('assets/images/login-img.jpg',
                      width: double.infinity),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
                  child: ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(mainColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Войти',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
                  child: ElevatedButton(
                    onPressed: () => context.go('/registration'),
                    child: Text(
                      'Зарегистрироваться',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
