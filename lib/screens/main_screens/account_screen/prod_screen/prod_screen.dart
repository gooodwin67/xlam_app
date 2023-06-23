import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        ? Container(color: Colors.black)
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
                ],
              ),
            ),
          );
  }
}
