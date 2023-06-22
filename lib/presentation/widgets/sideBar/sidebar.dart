import 'dart:async';

import 'package:fortloom/core/framework/colors.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/ImageUserService.dart';
import 'package:fortloom/presentation/views/event/eventmainview.dart';
import 'package:fortloom/presentation/views/login_register/login.dart';
import 'package:fortloom/presentation/widgets/circlularimg.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/presentation/widgets/sideBar/menuItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fortloom/presentation/views/Forum/ForumSection.Dart.dart';

import '../../../domain/entities/ImageResource.dart';
import '../../../domain/entities/PersonResource.dart';
class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 400);
  AuthService authService=AuthService();
  ImageUserService imageUserService=ImageUserService();
  PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
  ImageResource imageResource=new ImageResource(0, "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png", 0, "0", 0);
   bool isfanaitc=false;
   String Username="Usuario";
   String name="";
  String lastname="";
  String email="";
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
    this.authService.getToken().then((value){
      isfanaitc = this.authService.isfanatic(value.toString());
      Username= this.authService.GetUsername(value.toString());
      this.authService.getperson(Username).then((result) {
        setState(() {
          personResource=result;
          name=personResource.realname;
          lastname=personResource.lastname;
          email=personResource.email;
          this.imageUserService.getImageByUserId(personResource.id).then((value){
            setState(() {
              this.imageResource = value[0];
            });
          });
        });


      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left:
              isSideBarOpenedAsync.data.toString() == 'true' ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data.toString() == 'true'
              ? 0
              : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: background1,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('assets/imgs/logo.png',
                          height: ScreenWH(context).height * 0.15,
                          width: ScreenWH(context).width * 0.3),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: ScreenWH(context).height * 0.1,
                        width: ScreenWH(context).width * 0.8,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                             Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child:
                              CircleAvatar(backgroundImage:NetworkImage(this.imageResource.imagenUrl),),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${this.name}  ${this.lastname}",

                                  style: TextStyle(
                                      color: txtPrimaryWhite,
                                      fontSize: 24,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700),
                                ),

                                Text(
                                  "${this.email} ",
                                  style: TextStyle(
                                      color: txtPrimaryWhite,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        )),
                     MenuItemS(
                      icon: Icons.home,
                      title: "Home",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.homeScreenClickedEvent);
                      },
                    ),
                    dividerLine(),
                    MenuItemS(
                      icon: Icons.article,
                      title: "Posts",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.postScreenClickedEvent);
                      },
                    ),
                    dividerLine(),
                    MenuItemS(
                      icon: Icons.event,
                      title: "Events",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.EventScreenClickedEvent);

                      },
                    ),
                    dividerLine(),
                    MenuItemS(
                      icon: Icons.group,
                      title: "Forum",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.ForumScreenClickedEvent);
                      },
                    ),
                    dividerLine(),


                    if(isfanaitc)...[
                         MenuItemS(
                      icon: Icons.person,
                      title: "Artist",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.ArtistScreenClickedEvent);
                      },
                    ),
                         dividerLine(),
                    ],
                    MenuItemS(
                      icon: Icons.album,
                      title: "Album",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.AlbumScreenClickedEvent);
                      },
                    ),
                    dividerLine(),
                    MenuItemS(
                      icon: Icons.settings,
                      title: "Configure",
                      onTap: () {
                        onIconPressed();
                        BlocProvider.of<NavigationBloc>(context)
                            .add(NavigationEvents.ConfigureScreenClickedEvent);
                      },
                    ),

                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: MenuItemS(
                          icon: Icons.exit_to_app,
                          title: "Logout",
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Login(),
                                    type: PageTransitionType.rightToLeft));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
              Align(
                alignment: const Alignment(0, -0.99),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 45,
                      height: 110,
                      color: background1,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: goldPrimary,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget dividerLine() {
    return const Divider(
      height: 8,
      thickness: 2.5,
      color: Colors.white,
      // indent: 0,
      // endIndent: 180,
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
