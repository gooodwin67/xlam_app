import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/accountProvider.dart';
import 'package:xlam_app/provider/bottomBarProvider.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/provider/messageProvider.dart';
import 'package:xlam_app/provider/prodScreenProvider.dart';
import 'package:xlam_app/screens/main_screens/bottom_bar.dart';

class ProdScreenWidget extends StatefulWidget {
  String? prodId;
  ProdScreenWidget({super.key, required this.prodId});

  @override
  State<ProdScreenWidget> createState() => _ProdScreenWidgetState();
}

class _ProdScreenWidgetState extends State<ProdScreenWidget> {
  @override
  void initState() {
    context
        .read<ProdScreenProvider>()
        .getAllProds(context.read<MainProvider>().userId, widget.prodId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool dataIsLoaded = context.watch<ProdScreenProvider>().dataIsLoaded;
    List prod = context.read<ProdScreenProvider>().products;

    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SafeArea(
        child: !dataIsLoaded
            ? Container(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                child: Center(
                  child:
                      SpinKitWave(color: mainColor.withAlpha(150), size: 50.0),
                ),
              )
            : WillPopScope(
                onWillPop: () {
                  context.read<BottomBarProvider>().onItemTapped(0);
                  context.read<MainScreenProvider>().getAllDb(
                      context.read<MainScreenProvider>().activeCategory);
                  context.go('/main');
                  return Future((() => true));
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(mainPadding),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              prod[0].photoProd,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          child: Text(
                            prod[0].nameProd.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 25),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: Text(
                            prod[0].nameUser.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        context.read<ProdScreenProvider>().myProd
                            ? const SizedBox()
                            : Container(
                                width: double.infinity,
                                height: 50,
                                child: context.read<MainProvider>().isLogin ==
                                        false
                                    ? TextButton(
                                        onPressed: () =>
                                            context.go('/main/login'),
                                        child: Text(
                                          'Войдите чтобы написать продавцу',
                                          style: TextStyle(
                                              fontSize: 17,
                                              decoration:
                                                  TextDecoration.underline),
                                        ))
                                    : ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ProdScreenProvider>()
                                              .checkDialog(
                                                  context
                                                      .read<MainProvider>()
                                                      .userId,
                                                  prod[0].idUser,
                                                  prod[0].nameUser)
                                              .then((value) {
                                            if (context
                                                    .read<ProdScreenProvider>()
                                                    .dialogIsEnabled ==
                                                2) {
                                              context.go(
                                                  '/main/messages/${context.read<MainProvider>().userId}-xl-${prod[0].idUser}');
                                            } else if (context
                                                    .read<ProdScreenProvider>()
                                                    .dialogIsEnabled ==
                                                1) {
                                              context.go(
                                                  '/main/messages/${prod[0].idUser}-xl-${context.read<MainProvider>().userId}');
                                            } else {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            mainPadding),
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            context
                                                                .read<
                                                                    MessageProvider>()
                                                                .changeMessageText(
                                                                    value);
                                                          },
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                          decoration:
                                                              InputDecoration(
                                                            floatingLabelBehavior:
                                                                FloatingLabelBehavior
                                                                    .never,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            filled: true,
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            prefixIcon:
                                                                Icon(Icons.add),
                                                            suffixIcon: InkWell(
                                                              onTap: () {
                                                                if (context
                                                                    .read<
                                                                        MessageProvider>()
                                                                    .messageTextLegal) {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  context
                                                                      .read<
                                                                          ProdScreenProvider>()
                                                                      .setDialog(
                                                                          context
                                                                              .read<
                                                                                  MainProvider>()
                                                                              .userId,
                                                                          prod[0]
                                                                              .idUser,
                                                                          prod[0]
                                                                              .nameUser)
                                                                      .then(
                                                                          (value) {
                                                                    context
                                                                        .read<
                                                                            ProdScreenProvider>()
                                                                        .checkDialog(
                                                                            context.read<MainProvider>().userId,
                                                                            prod[0].idUser,
                                                                            prod[0].nameUser)
                                                                        .then((value) {
                                                                      print(
                                                                          '1111 ${prod[0].idUser}');
                                                                      context
                                                                          .read<
                                                                              MessageProvider>()
                                                                          .getMessagesDB(
                                                                              '${context.read<MainProvider>().userId}-xl-' + prod[0].idUser,
                                                                              context.read<MainProvider>().userId)
                                                                          .then((value) {
                                                                        context
                                                                            .read<MessageProvider>()
                                                                            .setMessage();
                                                                        if (context.read<ProdScreenProvider>().dialogIsEnabled ==
                                                                            2) {
                                                                          context
                                                                              .go('/main/messages/${context.read<MainProvider>().userId}-xl-${prod[0].idUser}');
                                                                        } else if (context.read<ProdScreenProvider>().dialogIsEnabled ==
                                                                            1) {
                                                                          context
                                                                              .go('/main/messages/${prod[0].idUser}-xl-${context.read<MainProvider>().userId}');
                                                                        }
                                                                      });
                                                                    });
                                                                  });
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .send_rounded,
                                                              ),
                                                            ),
                                                            label: Text(
                                                              'Написать сообщение',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              borderSide: BorderSide(
                                                                  // color: context
                                                                  //         .read<AccountProvider>()
                                                                  //         .nameIsLegal
                                                                  //     ? Colors.transparent
                                                                  //     : Colors.red,
                                                                  width: 0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }
                                          });
                                          // context
                                          //     .read<ProdScreenProvider>()
                                          //     .setDialog(
                                          //         context.read<MainProvider>().userId,
                                          //         prod[0].idUser,
                                          //         prod[0].nameUser)
                                          //     .then((value) {

                                          //   if (context
                                          //           .read<ProdScreenProvider>()
                                          //           .dialogIsEnabled ==
                                          //       2) {
                                          //     context.go(
                                          //         '/main/messages/${context.read<MainProvider>().userId}-xl-${prod[0].idUser}');
                                          //   } else if (context
                                          //           .read<ProdScreenProvider>()
                                          //           .dialogIsEnabled ==
                                          //       1) {
                                          //     context.go(
                                          //         '/main/messages/${prod[0].idUser}-xl-${context.read<MainProvider>().userId}');
                                          //   }
                                          // });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  mainColor),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Написать владельцу',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                        const SizedBox(height: 10),
                        !context.read<ProdScreenProvider>().myProd
                            ? const SizedBox()
                            : TextButton(
                                onPressed: () {
                                  context
                                      .read<ProdScreenProvider>()
                                      .deleteProduct(widget.prodId)
                                      .then((value) {
                                    context
                                        .read<BottomBarProvider>()
                                        .onItemTapped(0);
                                    context.pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: mainColor,
                                      content: const Text(
                                        'Товар удален',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ));
                                    context.read<MainScreenProvider>().getAllDb(
                                        context
                                            .read<MainScreenProvider>()
                                            .activeCategory);
                                  });
                                },
                                child: const Text(
                                  'Удалить товар',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline),
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
