


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/service/AuthService.dart';
import '../../../core/service/OpinionService.dart';
import '../../../domain/entities/PersonResource.dart';

class Eventlikes extends StatefulWidget {
  final int contentid;
  const Eventlikes({Key? key,required this.contentid}) : super(key: key);

  @override
  State<Eventlikes> createState() => _EventlikesState();
}

class _EventlikesState extends State<Eventlikes> {

  var seteventlikes=204;
  OpinionService opinionService=OpinionService();
  AuthService authService=AuthService();
  String username="Usuario";
  PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");

  void setlikes(int contentid) {
    print(contentid);
    this.opinionService.getAllOpinionsByagreeandContentId(widget.contentid, true).then((result) {
      setState(() {

        this.seteventlikes=result;
      });



    });

  }

  void setuser(){
    String tep;
    this.authService.getToken().then((result){


      if(mounted){

        setState(() {
          tep= result.toString();
          username=this.authService.GetUsername(tep);

          this.authService.getperson(username).then((result) {

            setState(() {
              personResource=result;
            });

          });
        });

      }




    }) ;
  }


  void checkuserandcontentlikes(){
    this.opinionService.existsbyUserandcontenid(personResource.id, widget.contentid).then((result){

      if(result==false){
        print("nuevo");
        this.opinionService.createOpinion(true, personResource.id, widget.contentid).then((value) {
          setState(() {
            this.setlikes(widget.contentid);
          });
        });
      }else{
        print("actualiza");
        this.opinionService.getAllOpinionsByuserandcontenid(personResource.id, widget.contentid).then((value) {
          print("value");
          print(value);
          this.opinionService.updateOpinion(value, true).then((value) {
            setState(() {
              this.setlikes(widget.contentid);
            });

          });


        });


      }







    });


  }

  void checkuserandcontentdislikes(){
    this.opinionService.existsbyUserandcontenid(personResource.id, widget.contentid).then((result){

      if(result==false){
        print("nuevo");
        this.opinionService.createOpinion(false, personResource.id, widget.contentid).then((value) {
          setState(() {
            this.setlikes(widget.contentid);
          });
        });
      }else{
        print("actualiza");
        this.opinionService.getAllOpinionsByuserandcontenid(personResource.id, widget.contentid).then((value) {
          print("value");
          print(value);
          this.opinionService.updateOpinion(value, false).then((value) {

            setState(() {
              this.setlikes(widget.contentid);
            });


          });


        });


      }







    });


  }




  @override
  void initState() {
    print("inciio");
    this.opinionService.getAllOpinionsByagreeandContentId(widget.contentid, true).then((result) {
      setState(() {

        this.seteventlikes=result;
      });



    });
    this.setuser();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        //Text(widget.list![index].registerdate),
        IconButton(
            onPressed: (){
              checkuserandcontentlikes();
              setState(() {
                //widget.list![index].eventlikes  += 1;
              });
              //eventservice.updateEvents(widget.list![index].eventlikes, widget.list![index].id);
              //print('event $index number of likes: '+ widget.list![index].eventlikes.toString()); //${index}  and   ${events[index].likes}
            },
            icon: Icon(Icons.thumb_up)
        ),
        IconButton(
            onPressed: (){
              checkuserandcontentdislikes();
              setState(() {
                //widget.list![index].eventlikes -= 1;
              });
              //eventservice.updateEvents(widget.list![index].eventlikes, widget.list![index].id);
              //print('event $index number of likes: ' + widget.list![index].eventlikes.toString()); //${index} and ${events[index].likes}
            },
            icon: Icon(Icons.thumb_down)
        ),
        SizedBox(width: 20,),
        Text(
            seteventlikes.toString()

        ),
      ],
    );
  }
}