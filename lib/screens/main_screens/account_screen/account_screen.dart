import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';

class AccountScreenWidget extends StatelessWidget {
  const AccountScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.go('/main');
                },
                child: Text('back'),
              ),
              Text(context.read<MainProvider>().userId),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Future.delayed(Duration(milliseconds: 500), () {
                    print('вышли');
                    context.go('/');
                  });
                },
                child: Text('Выйти'),
              ),
              Text('data'),
              SizedBox(height: 50),
              InkWell(
                onTap: (() => context.read<AccountProvider>().getDb()),
                child: Text('getData'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
