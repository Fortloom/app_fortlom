import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortloom/core/service/ImageUserService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/views/artist/artistFollow.dart';
import 'package:fortloom/presentation/views/artist/artistRate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/ImageResource.dart';

class artistSupport extends StatefulWidget {

  const artistSupport({Key? key, required this.artistid, required this.userid}) : super(key: key);
   final ArtistResource artistid;
  final int userid;
  @override
  State<artistSupport> createState() => _artistSupportState();
}

class _artistSupportState extends State<artistSupport> {
  ImageUserService imageUserService=ImageUserService();
  Uri _urlF = Uri.parse('https://www.facebook.com/?sk=welcome');
  Uri _urlI = Uri.parse('https://www.instagram.com');
  Uri _urlT = Uri.parse('https://twitter.com/i/flow/login');
  ImageResource imageResource=new ImageResource(0, "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png", 0, "0", 0);
  @override
  void initState() {

    this.imageUserService.getImageByUserId(widget.artistid.id).then((value){
      setState(() {
        this.imageResource = value[0];
      });
    });
    setState(() {

      if(widget.artistid.facebookLink!=null){
        this._urlF=Uri.parse(widget.artistid.facebookLink.toString());
      }
      if(widget.artistid.instagramLink!=null){
        this._urlI=Uri.parse(widget.artistid.instagramLink.toString());
      }
      if(widget.artistid.twitterLink!=null){
        this._urlT=Uri.parse(widget.artistid.twitterLink.toString());
      }



    });

    print(widget.artistid.aboutMe);
  }


  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.grey,
      child: Column(
        children: [
          /* Container(
                    child: Image.network(artistList![index].content),
                    height: 200,
                  ),*/

          ListTile(
            title: Center(
                child: Text(
                  widget.artistid.realname+" "+ widget.artistid.lastname,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                )
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
          height: 300,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[600],

          image: DecorationImage(
          image: NetworkImage(
          imageResource.imagenUrl),
          fit: BoxFit.fill),
          ),
          ),
          SizedBox(
            height: 15,
          ),
          if(widget.artistid.aboutMe != null)...[
            Text(widget.artistid.aboutMe.toString(),style: TextStyle(
              fontSize: 15

            ),),
          ],

          SizedBox(
            height: 5,
          ),
          Center(
            child: Wrap(
                children: [
                  buildSocialNetwork(1),
                  buildSocialNetwork(2),
                  buildSocialNetwork(3),
                ]
            ),
          ),
          SizedBox(
            height: 5,
          ),
         artistRate(artistid: widget.artistid.id,userid: widget.userid),

          artistFollow(artistid: widget.artistid.id,userid: widget.userid)
        ],
      ),
      elevation: 8,
      shadowColor: Colors.black,
      margin: EdgeInsets.all(20),
      shape:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1)
      ),
    );
  }



  Widget buildSocialNetwork(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: index==1 ?
        IconButton(
          onPressed: (){
            _launchUrl(_urlF);
          },
          icon: Icon(FontAwesomeIcons.facebook,color: Colors.indigoAccent,),
          iconSize: 35,
          splashRadius: 24,
        ):
        index ==2 ?
        IconButton(
          onPressed: (){
            _launchUrl(_urlI);
          },
          icon: Icon(FontAwesomeIcons.instagram,color: Colors.pinkAccent),
          iconSize: 35,
          splashRadius: 24,
        ):
        IconButton(
          onPressed: (){
            _launchUrl(_urlT);
          },
          icon: Icon(FontAwesomeIcons.twitter,color: Colors.lightBlue),
          iconSize: 35,
          splashRadius: 24,
        )
    );
  }
  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }









}
