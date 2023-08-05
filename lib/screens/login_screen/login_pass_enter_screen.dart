import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/loginScreenProvider.dart';

class LoginPassEnterScreen extends StatelessWidget {
  const LoginPassEnterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool loginingNow = context.watch<LoginScreenProvider>().isLogining;
    bool isLoginCorrect = context.watch<LoginScreenProvider>().isLoginCorrect;
    int isLoginError = context.watch<LoginScreenProvider>().isLoginError;

    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => context.read<BottomBarProvider>().onItemTapped(0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(mainPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<BottomBarProvider>().onItemTapped(0);
                          context.pop();
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Жалко выкинуть',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 43,
                          child: TextField(
                            onChanged: ((value) => context
                                .read<LoginScreenProvider>()
                                .editLogin(value)),
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Color(0xffF2F0F7),
                              prefixIcon: Icon(Icons.account_circle_outlined),
                              label: Text(
                                'Email',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          onChanged: ((value) => context
                              .read<LoginScreenProvider>()
                              .editPassword(value)),
                          obscureText: true,
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: Color(0xffF2F0F7),
                            prefixIcon: Icon(Icons.lock_outlined),
                            suffixIcon: Icon(Icons.remove_red_eye_outlined),
                            label: Text(
                              'Пароль',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                          ),
                        ),
                        isLoginError == 1
                            ? const Text(
                                'Пользователя с таким Email не существует',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              )
                            : SizedBox(),
                        isLoginError == 2
                            ? const Text(
                                'Неверный пароль',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              )
                            : SizedBox(),
                        isLoginError == 3
                            ? const Text(
                                'Неверный формат Email',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              )
                            : SizedBox(),
                        isLoginError == 4
                            ? const Text(
                                'Введите данные',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              )
                            : SizedBox(),
                        SizedBox(height: 15),
                        const InkWell(
                            child: Text(
                          'Забыли пароль?',
                          style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline),
                        )),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: loginingNow == false
                              ? () async {
                                  await context
                                      .read<LoginScreenProvider>()
                                      .tryLogin();
                                  context
                                      .read<BottomBarProvider>()
                                      .onItemTapped(0);
                                  context
                                          .read<LoginScreenProvider>()
                                          .isLoginCorrect
                                      ? context.go('/main')
                                      : null;
                                }
                              : () {},
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(mainColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ))),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: loginingNow == false
                                  ? const Text(
                                      'Войти',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text(
                                      'Войти',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    )),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                            onTap: () => context.go('/main/login/registration'),
                            child: Text(
                              'Зарегистрироваться?',
                              style: TextStyle(
                                  color: mainColor,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Column(
//         children: [
//           ElevatedButton(onPressed: () => context.go('/'), child: Text('pop')),
//           SizedBox(height: 10),
//           ElevatedButton(
//               onPressed: () => context.go('/main'), child: Text('next')),
//         ],
//       ),
