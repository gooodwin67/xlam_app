import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xlam_app/constants/constants.dart';

class LoginPassEnterScreen extends StatelessWidget {
  const LoginPassEnterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
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
                    Container(
                      height: 43,
                      child: TextField(
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
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
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
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0),
                        ),
                      ),
                    ),
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
                      onPressed: () => context.go('/main'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(mainColor),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Отправить',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
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
