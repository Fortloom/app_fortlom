import 'dart:ffi';

import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/EventService.dart';
import 'package:fortloom/core/service/OpinionService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/views/Forum/ForumSection.Dart.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'event.dart';
import 'package:fortloom/domain/entities/EventResource.dart';

import '../../../domain/entities/PersonResource.dart';

class EventListView extends StatefulWidget {
  const EventListView({Key? key}) : super(key: key);

  @override
  State<EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {

  EventService eventservice = EventService();
  List<EventResource> eventlist = [];


  Future<void> getdata()async {

    eventservice.getallEvents().then((value) {
      setState(() {
        eventlist = value;
      });
    });
  }

  @override
  void initState() {

    super.initState();
     this.getdata();


  }
  Future<void> _pullRefresh() async {
    eventservice.getallEvents().then((value) {
      setState(() {
        eventlist = value;
      });
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }
  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        body:
        Container(
          height: ScreenWH(context).height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://cdn.discordapp.com/attachments/1011046180064604296/1041115572852752465/artistlist.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child:

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child:Column(
              children: <Widget>[
                Expanded(
                    child: eventlist.isNotEmpty
                        ? RefreshIndicator(
                        child: ListView.builder(
                            itemCount: eventlist.length,
                            itemBuilder: (context,index){
                              return Event(event:eventlist[index]);
                            }
                        ),
                        onRefresh: _pullRefresh)
                        : const Center(child: Text("No Events"),)
                )

              ],
            ),
          ),
        )

      );
  }
}









