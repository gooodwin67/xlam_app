import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/RegistrationScreenProvider.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool RegisteringNow =
        context.watch<RegistrationScreenProvider>().isRegistering;
    bool passCorrect = context.watch<RegistrationScreenProvider>().passCorrect;
    int isRegisterError =
        context.watch<RegistrationScreenProvider>().isRegisterError;

    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
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
                      onTap: () => context.go('/'),
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
                      Text(
                        'Регистрация',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 43,
                        child: TextField(
                          onChanged: ((value) => context
                              .read<RegistrationScreenProvider>()
                              .editLoginReg(value)),
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                      SizedBox(height: 15),
                      Container(
                        height: 43,
                        child: TextField(
                          onChanged: ((value) => context
                              .read<RegistrationScreenProvider>()
                              .editPasswordReg(value)),
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
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 43,
                        child: TextField(
                          onChanged: ((value) => context
                              .read<RegistrationScreenProvider>()
                              .editPasswordReg2(value)),
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: Color(0xffF2F0F7),
                            prefixIcon: Icon(Icons.lock_outlined),
                            suffixIcon: Icon(Icons.remove_red_eye_outlined),
                            label: Text(
                              'Пароль еще раз',
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
                      isRegisterError == 1
                          ? const Text(
                              'Пароль слишком простой',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            )
                          : SizedBox(),
                      SizedBox(height: 15),
                      isRegisterError == 2
                          ? const Text(
                              'Пользователь с такми Email уже зарегистрирован',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            )
                          : SizedBox(),
                      ElevatedButton(
                        onPressed: RegisteringNow == false &&
                                passCorrect == true
                            ? () async {
                                await context
                                    .read<RegistrationScreenProvider>()
                                    .tryRegister();
                                context
                                            .read<RegistrationScreenProvider>()
                                            .registerDone ==
                                        true
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            WillPopScope(
                                          onWillPop: () {
                                            context.go('/main');
                                            return Future.value(true);
                                          },
                                          child: AlertDialog(
                                            title: const Text('Регистрация'),
                                            content: const Text(
                                                'Вы успешно зарегистрировались в приложении'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    context.go('/main'),
                                                child: const Text('Продолжить'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
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
                            child: RegisteringNow == false &&
                                    passCorrect == true
                                ? const Text(
                                    'Зарегистрироваться',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Зарегистрироваться',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )),
                      ),
                    ],
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

// Column(
//         children: [
//           ElevatedButton(onPressed: () => context.go('/'), child: Text('pop')),
//           SizedBox(height: 10),
//           ElevatedButton(
//               onPressed: () => context.go('/main'), child: Text('next')),
//         ],
//       ),
