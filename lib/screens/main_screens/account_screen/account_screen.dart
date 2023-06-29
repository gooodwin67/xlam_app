import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';

class AccountScreenWidget extends StatelessWidget {
  const AccountScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AccountProvider>().getDb(context.read<MainProvider>().userId);
    String userName = context.read<AccountProvider>().userName;
    XFile? image = context.read<AccountProvider>().image;

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
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<AccountProvider>()
                              .clearDataFromBottomSheet();
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(mainPadding),
                                      child: Column(
                                        children: [
                                          TextField(
                                            onChanged: (value) {
                                              context
                                                  .read<AccountProvider>()
                                                  .getName(value);
                                            },
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              contentPadding: EdgeInsets.zero,
                                              filled: true,
                                              fillColor: Color(0xffF2F0F7),
                                              prefixIcon: Icon(Icons.add),
                                              label: Text(
                                                'Название товара',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide(
                                                    color: context
                                                            .read<
                                                                AccountProvider>()
                                                            .nameIsLegal
                                                        ? Colors.transparent
                                                        : Colors.red,
                                                    width: 0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          DropdownButtonFormField(
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Text('Выберите категорию',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                            ),
                                            items: context
                                                .read<MainScreenProvider>()
                                                .Categories
                                                .where((element) =>
                                                    element.numCategory != 0)
                                                .map((e) => DropdownMenuItem(
                                                    value: e.numCategory,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20),
                                                      child: Text(
                                                          e.nameCategory,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                    )))
                                                .toList(),
                                            onChanged: (value) {
                                              context
                                                  .read<AccountProvider>()
                                                  .changeCategory(value);
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              filled: true,
                                              fillColor: context
                                                          .watch<
                                                              AccountProvider>()
                                                          .categoryIsLegal ==
                                                      true
                                                  ? Colors.transparent
                                                  : Color.fromARGB(
                                                      255, 255, 190, 186),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text('Добавьте фотографию'),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  context
                                                      .read<AccountProvider>()
                                                      .getImage(
                                                          ImageSource.camera);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              InkWell(
                                                onTap: () {
                                                  context
                                                      .read<AccountProvider>()
                                                      .getImage(
                                                          ImageSource.gallery);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .photo_size_select_actual_outlined,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Container(
                                            width: 100,
                                            height: 100,
                                            child: context
                                                        .watch<
                                                            AccountProvider>()
                                                        .image ==
                                                    null
                                                ? Image.asset(
                                                    'assets/images/login-img.jpg')
                                                : Image.file(File(context
                                                    .read<AccountProvider>()
                                                    .image!
                                                    .path)),
                                          ),
                                          SizedBox(height: 20),
                                          context
                                                      .read<AccountProvider>()
                                                      .nameIsLegal &&
                                                  context
                                                      .read<AccountProvider>()
                                                      .imageLoaded &&
                                                  context
                                                      .read<AccountProvider>()
                                                      .categoryIsLegal
                                              ? ElevatedButton(
                                                  onPressed: (() {
                                                    context
                                                        .read<AccountProvider>()
                                                        .setDb(context
                                                            .read<
                                                                MainProvider>()
                                                            .userId);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          mainColor,
                                                      content: Text(
                                                        'Товар добавлен',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ));
                                                  }),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(mainColor),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Добавить товар',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromARGB(
                                                                255,
                                                                226,
                                                                226,
                                                                226)),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Добавить товар',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(mainColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Добавить товар',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
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
                  return InkWell(
                    onTap: () {
                      context.go('/main/${productList[index].id}');
                    },
                    child: Container(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              height: 180,
                              color: Color.fromARGB(255, 214, 214, 214),
                              width: double.infinity,
                              child: !dataIsLoaded
                                  ? SpinKitWave(
                                      color: mainColor.withAlpha(50),
                                      size: 50.0)
                                  : Image.network(
                                      productList[index].photo,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(height: 5),
                          !dataIsLoaded
                              ? SpinKitWave(
                                  color: mainColor.withAlpha(50), size: 20.0)
                              : Text(
                                  productList[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ],
                      ),
                    ),
                  );
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
