import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
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
    context.read<ProdScreenProvider>().getAllProds(widget.prodId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool dataIsLoaded = context.watch<ProdScreenProvider>().dataIsLoaded;
    List prod = context.read<ProdScreenProvider>().products;

    return !dataIsLoaded
        ? Container(
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
            child: Center(
              child: SpinKitWave(color: mainColor.withAlpha(150), size: 50.0),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Image.network(prod[0].photoProd),
                  Container(
                    color: Colors.red,
                    child: Text(prod[0].id.toString()),
                  ),
                  SizedBox(height: 5),
                  Container(
                    color: Colors.green,
                    child: Text(prod[0].nameProd.toString()),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
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
                        context.read<MainScreenProvider>().getAllDb();
                      });
                    },
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
  }
}
