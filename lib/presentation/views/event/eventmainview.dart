import 'dart:developer';

import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/EventResource.dart';
import 'package:fortloom/presentation/views/event/eventlistview.dart';
import 'package:intl/intl.dart';

import '../../../core/service/AuthService.dart';
import '../../../core/service/EventService.dart';
import '../../../domain/entities/PersonResource.dart';
import 'PostEventForm.dart';

class EventMainView extends StatefulWidget with NavigationStates{
  const EventMainView({Key? key}) : super(key: key);

  @override
  State<EventMainView> createState() => _EventState();
}

class _EventState extends State<EventMainView> {

  EventService eventService=new EventService();
  AuthService authService= new AuthService();
  String username="Usuario";
  PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
  bool post = false;
  bool isupdagrade=false;
  var nametextfield = TextEditingController();
  var descriptiontextfield = TextEditingController();
  var datetextfield = TextEditingController();
  var tickettextfield= TextEditingController();
  String fechastring = "fecha";
  DateTime fechadescription = DateTime(2022,06,15);
  DateTime fechapredefinida = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
      body: Container(
           height: ScreenWH(context).height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://cdn.discordapp.com/attachments/1011046180064604296/1041115572852752465/artistlist.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: SingleChildScrollView(
              child:Center(
                  child:Container(
                      child:Column(
                          children: <Widget>[
                            SizedBox(height: 30,),
                            Center(
                              child: Text(
                                "Look for the most emotional events of the artists",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50,
                                   color: Color(0xfff5f5f5),
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            if(isupdagrade)...[
                              CardMainEvent(),
                            ],
                            SizedBox(height: 10,),
                            SizedBox(height: 10,),
                            ShowButtons()
                          ]
                      )
                  )
              )
          )
      )

    );
  }

  @override
  void initState() {

    super.initState();
    String tep;

    this.authService.getToken().then((result){

      setState(() {
        tep= result.toString();
        username=this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {

          setState(() {
            personResource=result;
          });

        });
        isupdagrade=this.authService.isartistupgrade(tep);


      });
    }) ;
  }

  Widget CardMainEvent(){
    return Card(
      child:Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black54,
                  width: 5
            )
          ),
          width: 400,
          height: 350,
          child:Column(
            children:<Widget> [
              Text('Make a Event!',style: TextStyle(
                  fontSize: 24,
                color: Colors.black
              ),),
              SizedBox(height: 10,),
              Image(
                image: AssetImage('assets/imgs/events_image.jpg'),
                height: 200,
                width: 500,
              ),
              SizedBox(height: 10,),
              Container(

                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostEventForm(artist:this.personResource.id)),
                    );




                  },
                  child: Text("Post Event",style: TextStyle(
                        color: Colors.black,
                    fontSize: 16

                  ),),
                  style: TextButton.styleFrom(backgroundColor: Color(0xffA3C6E8)),
                ),
              )

            ],
          )
      )
    );
  }



  Widget ShowButtons(){
    return Center(

       child: Container(
            width: 400,
            height: 100,

            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventListView())
                );
              },
              child: Center(
                child: Text("Show All Events",style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold

                )),
              )

              //colo:Colors.black54
            ),
          )

        );
  }



}


