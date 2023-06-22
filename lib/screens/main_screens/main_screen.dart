import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  @override
  void initState() {
    context.read<MainScreenProvider>().getAllDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List productList = context.read<MainScreenProvider>().products;
    bool dataIsLoaded = context.watch<MainScreenProvider>().dataIsLoaded;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => showExitPopup(context),
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
                        onTap: () {},
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Жалко выкинуть',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 25),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/main/account');
                        },
                        child: Icon(
                          Icons.manage_accounts_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 10),
                sliver: SliverAppBar(
                  toolbarHeight: 120,
                  elevation: 0,
                  floating: true,
                  pinned: false,
                  snap: true,
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  titleSpacing: 0,
                  title: Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          context.read<MainScreenProvider>().Categories.length,
                      itemBuilder: (context, index) {
                        return CategoryBlock(
                          name: context
                              .read<MainScreenProvider>()
                              .Categories[index]
                              .nameCategory,
                          icon: context
                              .read<MainScreenProvider>()
                              .Categories[index]
                              .iconCategory,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: !dataIsLoaded ? 4 : productList.length,
                    (context, index) {
                      return Container(
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
                                        productList[index].photoProd,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(height: 5),
                            !dataIsLoaded
                                ? SpinKitWave(
                                    color: mainColor.withAlpha(50), size: 20.0)
                                : Text(
                                    productList[index].nameProd,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
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
      ),
    );
  }
}

class CategoryBlock extends StatelessWidget {
  String name;
  IconData icon;
  CategoryBlock({Key? key, required this.name, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 15),
        Container(
          width: 65,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  color: Color(0xffF5F5F5),
                  width: 65,
                  height: 65,
                  child: Icon(
                    icon,
                    color: Color.fromARGB(255, 104, 104, 104),
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<bool> showExitPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Вы хотите выйти?"),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('yes selected');
                          exit(0);
                        },
                        child: Text("Да"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade800),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      child: Text("Нет", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
