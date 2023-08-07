import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:xlam_app/constants/constants.dart';
import 'package:xlam_app/provider/mainScreenProvider.dart';
import 'package:xlam_app/screens/main_screens/category_block.dart';
import 'package:xlam_app/screens/main_screens/show_exit_poput.dart';

class ProductBlock extends StatelessWidget {
  const ProductBlock({
    Key? key,
    required this.productList,
    required this.dataIsLoaded,
    required this.index,
  }) : super(key: key);

  final List productList;
  final bool dataIsLoaded;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 180,
              color: const Color.fromARGB(255, 214, 214, 214),
              width: double.infinity,
              child: !dataIsLoaded
                  ? SpinKitWave(color: mainColor.withAlpha(50), size: 50.0)
                  : Image.network(
                      productList[index].photoProd,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 5),
          !dataIsLoaded
              ? SpinKitWave(color: mainColor.withAlpha(50), size: 20.0)
              : Text(
                  productList[index].nameProd,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }
}
