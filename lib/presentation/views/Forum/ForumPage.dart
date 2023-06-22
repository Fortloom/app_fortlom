

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/core/service/ReportService.dart';
import 'package:fortloom/domain/entities/ForumResource.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../../core/framework/globals.dart';
import '../../../core/service/AuthService.dart';
import '../../../core/service/ForumCommentService.dart';
import '../../../domain/entities/ForumCommentResource.dart';
import '../../widgets/screenBase.dart';


class ForumPage extends StatefulWidget {

  final ForumResource forumResource;

  const ForumPage({Key? key,required this.forumResource}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState(forumResource);
}

class _ForumPageState extends State<ForumPage> {

   late ForumResource forumResourceo;
   ForumCommentService forumCommentService = new ForumCommentService();
   AuthService authService= new AuthService();
   ReportService reportService=new ReportService();
   String username="Usuario";
   _ForumPageState(ForumResource forumResourcejj){
    PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
     forumResourceo = new ForumResource(0, "forumname", "forumdescription","forumrules" ,personResource);
    forumResourceo=forumResourcejj;
  }
   PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");

   final TextEditingController createcomment = new TextEditingController();
   final TextEditingController report = new TextEditingController();
   Future<List<ForumCommentResource>> getdata(int id){

     return forumCommentService.getbyForumID(id);
   }
   @override
   void initState() {

     super.initState();
     this.getdata(forumResourceo.id);

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



       });


     }) ;

   }

   void AddForumComment(){

     forumCommentService.addForumComment(createcomment.text.trim(), this.forumResourceo.id,this.personResource.id).then((result){


       setState(() {
         createcomment.text="";
         this.getdata(forumResourceo.id);
       });



     });




   }
   
   Future<Response> AddReport(){
     var result=reportService.createforforum( personResource.id, forumResourceo.person.id,forumResourceo.id,report.text.trim());

     return result;
     
   }

   






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 3,
          title: Container(
            padding: EdgeInsets.only(right: 50),
            alignment: Alignment.center,
            child: Image.asset('assets/imgs/logo.png',
                height: ScreenWH(context).height * 0.1,
                width: ScreenWH(context).width * 0.25),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          height: ScreenWH(context).height,
          width: ScreenWH(context).width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://cdn.discordapp.com/attachments/1011046180064604296/1041115572852752465/artistlist.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child:  SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Card(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Text(this.forumResourceo.forumname,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 7),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black54,
                          ),

                          child:IconButton(
                              icon: const Icon(Icons.flag),
                              onPressed: () {
                                showDialog(context: context,
                                    barrierDismissible: false,
                                    builder: (context)=> AlertDialog(

                                      title: Text("Reporte al Foro"),
                                      content: Container(
                                        width: 200,
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 20,
                                          maxLength: 100,
                                          controller: report,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Description',

                                          ),
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child:Text("Ok"),
                                          onPressed: (){

                                            AddReport();

                                            Fluttertoast.showToast(
                                                msg: "Reporte Enviado",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                textColor: Colors.white,
                                                fontSize: 16.0

                                            );




                                            Navigator.of(context).pop();
                                          },),


                                        FloatingActionButton(
                                          child:Text("Cancel"),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],

                                    )

                                );
                              }
                          ),
                        ),
                      ) ,

                      Align(
                        alignment: Alignment.topLeft,
                        child:Text(this.forumResourceo.person.realname+"    "+ this.forumResourceo.person.lastname,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topLeft,
                        child:Text(this.forumResourceo.forumdescription,
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                FutureBuilder<List<ForumCommentResource>>(
                  future: getdata(forumResourceo.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if(snapshot.hasData){


                      return itemList(list: snapshot.data,report: this.report,personResource: this.personResource,);

                    }
                    return Text("No Comments Available",
                     );

                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 200,
                    child: Card(
                      color: Colors.grey,
                      child: Column(
                        children: [
                          Text("Write a Comment",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 200,

                            child:TextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 20,
                              maxLength: 1000,
                              controller: createcomment,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Description',

                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(onPressed:(){
                                AddForumComment();
                              },
                                shape: RoundedRectangleBorder(),
                                child: Text("Accept"),
                              ) ,
                              FloatingActionButton(onPressed:(){
                                createcomment.text="";
                              },
                                shape: RoundedRectangleBorder(),
                                backgroundColor: Colors.red,
                                child: Text("Delete"),
                              ) ,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )




      );

  }
}















class itemList extends StatelessWidget {
  final List<ForumCommentResource>? list;
  final TextEditingController report;
  final PersonResource personResource;
  const itemList({Key? key,required this.list,required this.report,required this.personResource}) : super(key: key);



  Future<Response> AddReportincomment(int id,int idcomment){

    ReportService reportService=new ReportService();
    var result=reportService.createforcomment( personResource.id, id,idcomment,report.text.trim());

    return result;

  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: list == null ? 0 : list?.length,
        itemBuilder: (context,index){
          return Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 200,
              child: Card(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Text(list![index].commentdescription,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 7),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.black54,
                          ),

                          child:IconButton(
                              icon: const Icon(Icons.flag),
                              onPressed: () {

                                showDialog(context: context,
                                    barrierDismissible: false,
                                    builder: (context)=> AlertDialog(

                                      title: Text("Reporte al Foro"),
                                      content: Container(
                                        width: 200,
                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 20,
                                          maxLength: 100,
                                          controller: report,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Description',

                                          ),
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child:Text("Ok"),
                                          onPressed: (){

                                            AddReportincomment(list![index].userAccount.id,list![index].id);

                                            Fluttertoast.showToast(
                                                msg: "Reporte Enviado",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                textColor: Colors.white,
                                                fontSize: 16.0

                                            );




                                            Navigator.of(context).pop();
                                          },),


                                        FloatingActionButton(
                                          child:Text("Cancel"),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],

                                    )

                                );



                              }
                          ),
                        ),
                      ) ,
                      Align(
                        alignment: Alignment.topLeft,
                        child:Text(list![index].userAccount.realname+"  "+list![index].userAccount.lastname,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child:Text(
                            DateFormat('yyyy-MM-dd').format(list![index].registerdate as DateTime),
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          );
        });
  }
}

