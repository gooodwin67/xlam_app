import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/mainProvider.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/provider/prodScreenProvider.dart';

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
      body: SafeArea(
        child: !dataIsLoaded
            ? Container(
                color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                child: Center(
                  child:
                      SpinKitWave(color: mainColor.withAlpha(150), size: 50.0),
                ),
              )
            : SingleChildScrollView(
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
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          prod[0].nameProd.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 10),
                      context.read<ProdScreenProvider>().myProd
                          ? SizedBox()
                          : Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(mainColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
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
                      SizedBox(height: 10),
                      !context.read<ProdScreenProvider>().myProd
                          ? SizedBox()
                          : TextButton(
                              onPressed: () {
                                context
                                    .read<ProdScreenProvider>()
                                    .deleteProduct(widget.prodId)
                                    .then((value) {
                                  context.pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Product Deleted'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  context.read<MainScreenProvider>().getAllDb(
                                      context
                                          .read<MainScreenProvider>()
                                          .activeCategory);
                                });
                              },
                              child: Text(
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
    );
  }
}
