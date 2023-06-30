import 'package:flutter/material.dart';
import 'package:xlam_app/constants/constants.dart';

class CategoryBlock extends StatelessWidget {
  String name;
  num index;
  num numCat;
  IconData icon;
  CategoryBlock(
      {Key? key,
      required this.name,
      required this.icon,
      required this.index,
      required this.numCat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          width: 65,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  color: index == numCat
                      ? mainColor.withAlpha(120)
                      : const Color(0xffF5F5F5),
                  width: 65,
                  height: 65,
                  child: Icon(
                    icon,
                    color: const Color.fromARGB(255, 104, 104, 104),
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                name,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
