import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AlbumService.dart';
import 'package:fortloom/domain/entities/AlbumResource.dart';
import 'package:fortloom/presentation/views/album/AlbumCreate.dart';
import 'package:fortloom/presentation/views/album/AlbumWidget.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';

import '../../../core/framework/colors.dart';
import '../../../core/service/AuthService.dart';
import '../../widgets/sideBar/navigationBloc.dart';

class AlbumView extends StatefulWidget with NavigationStates {
  const AlbumView({Key? key}) : super(key: key);

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  final AuthService authService = AuthService();
  final AlbumService albumService = new AlbumService();
  List<AlbumResource> albums = [];
  int userId = 0;
  String username = "Usuario";
  bool canpost = true;

  navigatetoAlbumCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlbumCreate(id: this.userId)),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String tep;

    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;
          });
        });

        canpost = this.authService.isfanatic(tep);
      });
    });

    albumService.getall().then((value) {
      setState(() {
        albums = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pullRefresh() async {
      albumService.getall().then((value) {
        setState(() {
          albums = value;
        });
      });
    }

    return ScreenBase(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/Battlelogo.jpg"),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                if (!canpost) ...[
                  Container(
                    width: ScreenWH(context).width * 0.8,
                    // height: ScreenWH(context).height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(goldPrimary),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                        ),
                      ),
                      onPressed: () {
                        navigatetoAlbumCreate(context);
                      },
                      child: const Text(
                        "New Album",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: albums.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: _pullRefresh,
                          child: ListView.builder(
                              itemCount: albums.length,
                              itemBuilder: (context, index) {
                                return AlbumWidget(
                                  album: albums[index],
                                  canpost: canpost,
                                );
                              }))
                      : const Center(child: Text("No Albums Avaliable")),
                )
              ],
            ),
          )),
    );
  }
}
