import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/colors.dart';

import '../../core/framework/globals.dart';

class ScreenBase extends StatelessWidget {
  final Widget body;
  const ScreenBase({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Container(
            alignment: Alignment.center,
            child: Image.asset('assets/imgs/logo.png',
                height: ScreenWH(context).height * 0.1,
                width: ScreenWH(context).width * 0.25),
          ),
          backgroundColor: background1,
        ),
        body: body);
  }
}
