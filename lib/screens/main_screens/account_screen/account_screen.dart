import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/screens/main_screens/account_screen/addProductWidget.dart';
import 'package:xlam_app/screens/main_screens/product_block.dart';

class AccountScreenWidget extends StatelessWidget {
  const AccountScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AccountProvider>().getDb(context.read<MainProvider>().userId);
    String userName = context.read<AccountProvider>().userName;

    List productList = context.read<AccountProvider>().productsList;
    bool dataIsLoaded = context.watch<AccountProvider>().dataIsLoaded;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              floating: true,
              pinned: false,
              snap: false,
              titleSpacing: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 59,
              title: Padding(
                padding: EdgeInsets.all(mainPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<MainScreenProvider>().getAllDb(
                            context.read<MainScreenProvider>().activeCategory);
                        context.go('/main');
                      },
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Личный кабинет',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 25),
                    ),
                    InkWell(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Future.delayed(Duration(milliseconds: 500), () {
                          print('вышли');
                          context.go('/');
                        });
                      },
                      child: Icon(
                        Icons.power_settings_new,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: 10, left: mainPadding, right: mainPadding),
              sliver: SliverAppBar(
                toolbarHeight: 90,
                elevation: 0,
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Container(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !dataIsLoaded
                          ? Container(
                              height: 40,
                              child: SpinKitWave(
                                  color: mainColor.withAlpha(100), size: 30.0),
                            )
                          : Container(
                              height: 40,
                              child: Text(
                                userName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                      AddProductButton(),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    childCount: !dataIsLoaded ? 4 : productList.length,
                    (context, index) {
                  return ProductBlock(
                      productList: productList,
                      dataIsLoaded: dataIsLoaded,
                      index: index);
                }),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 210,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
