import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/colors.dart';

import '../chat/chat.dart';

class HomeScreen extends StatefulWidget with NavigationStates {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AuthService authService= new AuthService();
  bool isfanatic=false;
  @override
  void initState() {

    super.initState();
    String tep;
    this.authService.getToken().then((result){

      setState(() {
        tep = result.toString();
        this.isfanatic= this.authService.isfanatic(tep);


      });



    });




  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(this.isfanatic)...[

          Image.asset(
            "assets/imgs/Welcome_fanatic.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        ]else ...[
          Image.asset(
            "assets/imgs/Welcome_artist.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
        ],


        Scaffold(
          backgroundColor: Colors.transparent,
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

          floatingActionButton:FloatingActionButton(
            elevation: 70,
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat())
              );
            },
            child: const Icon(
              Icons.adb,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
      ],
    );

  }
}
