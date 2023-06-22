import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/EventResource.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/service/ImageUserService.dart';
import '../../../domain/entities/ImageResource.dart';
import 'eventlike.dart';

class Event extends StatefulWidget {
  const Event({Key? key,required this.event}) : super(key: key);
  final EventResource event;

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  ImageResource imageResource=new ImageResource(0, "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png", 0, "0", 0);
  final ImageUserService imageUserService=new ImageUserService();
  void getImage(int userId){

    this.imageUserService.getImageByUserId(userId).then((value){
      setState(() {
        this.imageResource = value[0];
      });
    });

  }
  @override
  void initState() {

    getImage(widget.event.artistid);



  }
  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
            color: Color(0xffcca027),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(widget.event.artist.realname),
                  SizedBox(width: 10,),
                  Text(widget.event.artist.lastname),
                  SizedBox(width: 70,),

                ],
              ),
              subtitle: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Container(
                    width: 400,
                    color: Colors.black,
                    child:
                    Text(widget.event.name.toUpperCase().trim(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,


                    ),),
                  ),

                  SizedBox(height: 10,),
                  Text(widget.event.description),
                  SizedBox(height: 10,),
                  if(widget.event.releasedDate!=null)...[
                    Align(
                     alignment: Alignment.topLeft,
                      child: Text(DateFormat('yyyy-MM-dd').format(widget.event.releasedDate as DateTime)),
                    ),

                  ] else...[
                    Text("No Time"),
                  ],

                  SizedBox(height: 10,),
                  Eventlikes(contentid: widget.event.id),
                  SizedBox(height: 5,),
                  Container(
                    width: 700,
                    child: Divider(
                      height: 30,
                      thickness: 5,
                      color: Colors.black54,

                    )
                  )
                  ,
                  Container(
                     width: 300,
                     child:  FloatingActionButton(onPressed: (){
                       Uri _urlF = Uri.parse(widget.event.ticketLink);
                       _launchUrl(_urlF);

                     },
                          shape: RoundedRectangleBorder(),
                           child: Icon(Icons.search),
                     ),
                  )





                ],
              ),
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    this.imageResource.imagenUrl

                ),
              ),
            )
        )
    );
  }
}
