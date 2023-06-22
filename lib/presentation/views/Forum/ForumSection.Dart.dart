
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fortloom/core/service/ForumService.dart';
import 'package:fortloom/presentation/views/Forum/Forum.dart';
import 'package:fortloom/presentation/views/Forum/ForumCreate.dart';
import 'package:fortloom/presentation/views/Forum/ForumPage.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/sidebarLayout.dart';
import '../../../core/framework/globals.dart';
import '../../../domain/entities/ForumResource.dart';
import '../../widgets/sideBar/navigationBloc.dart';


class ForumSection extends StatefulWidget with NavigationStates{
  const ForumSection({Key? key}) : super(key: key);

  @override
  State<ForumSection> createState() => _ForumSectionState();
}

class _ForumSectionState extends State<ForumSection> {

  ForumService forumService=ForumService();




   List<ForumResource> getforums=[];

   Future<List<ForumResource>> getdata(){

     return forumService.getall();
   }
  Future<void> _pullRefresh() async {
    forumService.getall().then((value) {
      setState(() {
        getforums = value;

      });
    });
  }
  navigatetoForumCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForumCreate()),
    );

    if (result) {
      this.getdata();
      setState(() {});
    }
  }



  @override
  void initState() {

    super.initState();
    forumService.getall().then((value) {
      setState(() {
        getforums = value;
        print(getforums.length);

      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
         home:ScreenBase(

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
                           Center(
                             child: Text(
                               'Forums',
                               style: TextStyle(
                                   fontFamily: 'Roboto',
                                   fontSize: 50,
                                   color: Colors.white,
                                   fontWeight:FontWeight.w900

                               ),

                             ),
                           ),
                           SizedBox(height: 30),
                           Container(
                             width: 400,
                             height: 100,
                             child: ElevatedButton(onPressed: () => navigatetoForumCreate(context),

                               child: Text("Create Forum",
                                 style: TextStyle(
                                     color: Colors.black54,
                                     fontSize: 50

                                 ),
                               ),
                               style: TextButton.styleFrom(
                                 backgroundColor: Colors.cyan,
                                 padding: const EdgeInsets.all(16.0),
                               ),

                             ),
                           ),
                           SizedBox(height: 30),
                           Expanded(
                               child: getforums.isNotEmpty
                                   ? RefreshIndicator(
                                   child: ListView.builder(
                                       itemCount: getforums.length,
                                       itemBuilder: (context,index){
                                         return ForumWidget(forum:getforums[index]);
                                       }
                                   ),
                                   onRefresh: _pullRefresh)
                                   : const Center(child: Text("No Forums Avaliable",textAlign: TextAlign.center,style: TextStyle(
                                       fontSize: 30,color: Colors.white,fontWeight: FontWeight.w800
                               ),),)
                           )

                         ],
                       ),
                     ),








             )



         ) ,


      
    );

  }

  
  
  
  



}
class ItemList extends StatelessWidget {
  final List<ForumResource>?list;

  const ItemList({Key? key, required this.list,}) : super(key: key);

  navigatetoForumPage(BuildContext context,ForumResource forumResource) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForumPage(forumResource: forumResource,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),

        shrinkWrap: true,
        itemCount: list == null ? 0 : list?.length,
        itemBuilder: (context,index){
          return Container(
             height: 100,
            child: InkWell(
                onTap: ()  {

                  navigatetoForumPage(context,list![index]);

                },

                child: Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),


                  ),
                  elevation: 100,
                  shadowColor: Colors.black54,
                  color: Colors.grey,
                  child: Center(

                      child: RichText(
                        text: TextSpan(
                              children: [

                                TextSpan(
                                    text:list![index].forumname.toUpperCase().trim(), style: TextStyle(fontSize: 30)
                                ),

                              ]
                        ),
                      )
                     /* Icon(
                                Icons.campaign,
                                color: Colors.yellowAccent,
                                size: 50.0,
                              ),
                            ),*/




                           /* Text(
                                list![index].forumname, style: TextStyle(fontSize: 20)
                            ),*/








                  ),


                )

            ),
          );







        });
  }
}
