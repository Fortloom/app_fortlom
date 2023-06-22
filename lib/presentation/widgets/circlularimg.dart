import 'package:fortloom/core/framework/colors.dart';
import 'package:flutter/material.dart';

class CircularImg extends StatelessWidget {
  const CircularImg({Key? key, this.pathImg = ''}) : super(key: key);
  final String pathImg;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: goldPrimary, width: 2.5)),
        child: CircleAvatar(
          backgroundImage: AssetImage(pathImg),
          backgroundColor: Colors.white,
        ));
  }
}
