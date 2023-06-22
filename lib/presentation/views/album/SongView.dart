import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/MusicService.dart';
import 'package:fortloom/domain/entities/SongResource.dart';
import 'package:fortloom/presentation/views/album/SongCreate.dart';
import 'package:fortloom/presentation/views/album/SongWidget.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';

import '../../../core/framework/globals.dart';

class SongView extends StatefulWidget {
  const SongView({Key? key,required this.album,required this.post}) : super(key: key);
  final int album;
  final bool post;
  @override
  State<SongView> createState() => _SongViewState();
}

class _SongViewState extends State<SongView> {
   List<SongResource>songs=[];
   final MusicService musicService= new MusicService();
  navigatetoASongCreate(BuildContext context,int albumId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongCreate(id:albumId)),
    );


  }

   @override
   void initState() {
     // TODO: implement initState
     super.initState();
    musicService.getbyAlbum(widget.album).then((value){
      setState(() {
        songs=value;

      });




    });



  }



  @override
  Widget build(BuildContext context) {



    Future<void> _pullRefresh() async {
      musicService.getbyAlbum(widget.album).then((value) {
        setState(() {
          songs=value;
        });
      });

    }










    return ScreenBase(
        body: Container(
          width: ScreenWH(context).width,
          height: ScreenWH(context).height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/imgs/Battlelogo.jpg"),
                fit: BoxFit.cover
            )
        ),


            child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                   children: [
                     SizedBox(height: 20,),
                     if(!widget.post)...[
                       Align(
                         alignment: Alignment.topRight,
                         child:  FloatingActionButton.extended(
                           onPressed: (){

                             navigatetoASongCreate(context,widget.album);

                           },
                           backgroundColor: Colors.amber,
                           label: Text("New Song",style: TextStyle(
                               fontWeight: FontWeight.w800
                           ),),
                           icon: Icon(Icons.add),
                         ),
                       ),
                     ],

                     SizedBox(height: 20,),
                     Expanded(
                       child: songs.isNotEmpty
                           ? RefreshIndicator(
                           child: ListView.builder(
                               itemCount: songs.length,
                               itemBuilder: (context, index) {
                                 return SongWidget(songResource: songs[index]);
                               }),
                           onRefresh: _pullRefresh)
                           : const Center(child: Text("No Songs Avaliable",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)),
                     )








                   ],



                 ),

              )












        )

    );
  }
}
