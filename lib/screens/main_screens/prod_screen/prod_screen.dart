import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    context.read<ProdScreenProvider>().clearData();
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
                  //context.go('/main');
                  return Future((() => true));
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(mainPadding),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       InkWell(
                        //         onTap: () {
                        //           context.pop();
                        //         },
                        //         child: Icon(Icons.chevron_left),
                        //       ),
                        //       const InkWell(
                        //         child: Icon(Icons.favorite_border_rounded),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 5),
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
                          child: Row(
                            children: [
                              Text(
                                'Продавец: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                prod[0].nameUser.toString(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: [
                              Text(
                                'Город: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                prod[0].city.toString(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        prod[0].descProd == ''
                            ? SizedBox()
                            : Container(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Описание: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 15),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        prod[0].descProd.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        context.read<ProdScreenProvider>().iLikedProd
                            ? Text('Вы предложили цену')
                            : context.read<ProdScreenProvider>().myProd
                                ? SizedBox()
                                : Container(
                                    padding: EdgeInsets.all(mainPadding * 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey,
                                        )),
                                    child: context
                                                .read<MainProvider>()
                                                .isLogin ==
                                            false
                                        ? TextButton(
                                            onPressed: () =>
                                                context.go('/main/login'),
                                            child: const Text(
                                              'Войдите чтобы написать продавцу',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ))
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                // controller: TextEditingController()
                                                //   ..text = context
                                                //       .read<ProdScreenProvider>()
                                                //       .price,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          ProdScreenProvider>()
                                                      .editPrice(value);
                                                },
                                                textInputAction:
                                                    TextInputAction.send,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  prefixIcon: Icon(
                                                      Icons.currency_ruble),
                                                  label: Text(
                                                    'Предложить цену',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255,
                                                            155,
                                                            155,
                                                            155)),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255,
                                                            155,
                                                            155,
                                                            155)),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              TextField(
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          ProdScreenProvider>()
                                                      .editComment(value);
                                                },
                                                textInputAction:
                                                    TextInputAction.send,
                                                maxLines: 4,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 52),
                                                    child: Icon(Icons
                                                        .insert_comment_outlined),
                                                  ),
                                                  label: Text(
                                                    'Оставить комментарий',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                  alignLabelWithHint: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255,
                                                            155,
                                                            155,
                                                            155)),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255,
                                                            155,
                                                            155,
                                                            155)),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              context
                                                          .watch<
                                                              ProdScreenProvider>()
                                                          .price ==
                                                      ''
                                                  ? ElevatedButton(
                                                      onPressed: () {},
                                                      style: ButtonStyle(
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all(Size(
                                                                    double
                                                                        .infinity,
                                                                    45)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .grey),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Отправить',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : ElevatedButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                ProdScreenProvider>()
                                                            .setDialog(
                                                                context
                                                                    .read<
                                                                        MainProvider>()
                                                                    .userId,
                                                                prod[0].idUser,
                                                                prod[0]
                                                                    .nameUser,
                                                                prod[0].id)
                                                            .then((value) => context
                                                                .read<
                                                                    ProdScreenProvider>()
                                                                .setFirstMessage())
                                                            .then((value) {
                                                          context
                                                              .read<
                                                                  ProdScreenProvider>()
                                                              .getAllProds(
                                                                  context
                                                                      .read<
                                                                          MainProvider>()
                                                                      .userId,
                                                                  widget
                                                                      .prodId);
                                                          context
                                                              .read<
                                                                  ProdScreenProvider>()
                                                              .clearData();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            backgroundColor:
                                                                mainColor,
                                                            content: const Text(
                                                              'Продавцу отправлено ваше предложение!',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                    seconds: 4),
                                                          ));
                                                        });
                                                      },
                                                      style: ButtonStyle(
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all(Size(
                                                                    double
                                                                        .infinity,
                                                                    45)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(mainColor),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Отправить',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                            ],
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
                                      duration: const Duration(seconds: 4),
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
