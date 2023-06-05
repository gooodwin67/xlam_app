import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';

class AccountScreenWidget extends StatefulWidget {
  const AccountScreenWidget({super.key});

  @override
  State<AccountScreenWidget> createState() => _AccountScreenWidgetState();
}

class _AccountScreenWidgetState extends State<AccountScreenWidget> {
  @override
  void initState() {
    context.read<AccountProvider>().getDb(context.read<MainProvider>().userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userName = context.watch<AccountProvider>().userName;
    List productList = context.read<AccountProvider>().productsList;
    bool dataIsLoaded = false;
    dataIsLoaded = context.read<AccountProvider>().dataIsLoaded;

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
                        onPressed: () {},
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
                                    color: mainColor.withAlpha(50), size: 50.0)
                                : Image.asset(
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
