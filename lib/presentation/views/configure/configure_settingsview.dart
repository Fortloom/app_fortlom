import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortloom/core/service/ArtistService.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/ProfileService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/views/login_register/login.dart';

import '../../../core/framework/globals.dart';
import '../../../domain/entities/TagResource.dart';



class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key,required this.artist,required this.isartist,required this.isupgrade}) : super(key: key);
  final ArtistResource artist;
  final bool isartist;
  final bool isupgrade;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<bool> isActive =[false,false,false,false,false,false];
  List<TagResource> tags=[];
  String token="";
  final TextEditingController facebookController = new TextEditingController();
  final TextEditingController instagramController = new TextEditingController();
  final TextEditingController twitterController = new TextEditingController();
  final ArtistService artistService = new ArtistService();
  final AuthService authService= new AuthService();
  
  void Updateaccount(String type){
    if(type=="Facebook"){
         artistService.updateFacebookAccount(this.widget.artist.id, facebookController.text.trim()).then((value) {
         Navigator.of(context).pop();
         });
    }
    if(type=="Instagram"){
      artistService.updateInstagramAccount(this.widget.artist.id, instagramController.text.trim()).then((value) {
        Navigator.of(context).pop();
      });
    }
    if(type=="Twitter"){
      artistService.updateTwitterAccount(this.widget.artist.id, twitterController.text.trim()).then((value) {
        Navigator.of(context).pop();
      });
    }
  }


  @override
  void initState() {

    artistService.GetTags(widget.artist.id).then((value) {
      setState(() {
        tags = value;

      });
    });
    authService.getToken().then((value){

      this.token=value!;


    });




  }








  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
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
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text("Settings", style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 40,),

            if(widget.isartist||widget.isupgrade)...[
              Row(
                children: [
                  Icon(Icons.person,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8,),
                  Text("Account",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(height: 15,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
               buildAcountOptionRow(context, "Manage tags"),
               buildAccountSocial(context, "Social"),
               if(widget.isartist)...[
                 buildUpgrade(context,"Upgrade Account"),
               ]

            ],

            SizedBox(height: 40,),
            Row(
              children: [
                Icon(Icons.volume_up_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8,),
                Text("Notifications",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 15,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [

                  Text("Likes",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Off",0),
            buildNotificationOptionRow("From people i follow",1),
            buildNotificationOptionRow("From everyone",2),
            SizedBox(
              height: 10,
            ),
            Row(
                children: [
                  Text("Comments",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.library_books,
                    color: Colors.amber,
                  ),
                ],
              ),

            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Off",3),
            buildNotificationOptionRow("From people i follow",4),
            buildNotificationOptionRow("From everyone",5),
            SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                  onPressed: (){actionSheetMethod(context);},
                  child: Text("Sign Out",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.black
                  ),
                  )
              ),
            )
          ],
        ),

      ),
    );
  }

  Row buildNotificationOptionRow(String title,int index) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(title,
            style: TextStyle(
              fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
            ),
            ),
            Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  value: isActive[index],
                  activeColor: Colors.black,
                  onChanged: (value){
                    setState(() {
                      isActive[index]=value;
                    });
                  },
                )
            )
          ],);
  }



  GestureDetector buildAcountOptionRow(BuildContext context, String title) {

    Future<void> _pullRefresh() async {
      artistService.GetTags(widget.artist.id).then((value) {
        setState(() {
          tags = value;

        });
      });
    }

    return GestureDetector(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text(title),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tags.isNotEmpty
                              ? Container(
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: tags.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Text(tags[index].name,style: TextStyle(fontSize: 20),)
                                    );
                                  }),
                             )
                              : const Center(child: Text("No Tags")),

                      ],),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        },
                            child: Text("Close",
                            style: TextStyle(
                              color: Colors.black
                            ),
                            )
                        ),
                      ],
                    );
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ],),
            ),
          );
  }
  GestureDetector buildUpgrade(BuildContext context,String title){
        return GestureDetector(
              onTap:(){

                showDialog(
                  context: context,
                  builder: (BuildContext context){
                        return AlertDialog(
                             content: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 UpgradeOption("S/13/week"),
                                 UpgradeOption("S/30/month"),
                                 UpgradeOption("S/70/year"),
                               ],
                             ),


                        );
                  });


              },
              child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(title,
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.grey[600],
    ),
    ),
    Icon(
    Icons.arrow_forward_ios,
    color: Colors.grey,
    ),
    ],),
    ),
        );
  }

  GestureDetector buildAccountSocial(BuildContext context,String title){
           return GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text(title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                         return ChangeAccount("Change Facebook Account","Account","Facebook",facebookController);
                                    });
                                  },
                                  icon: Icon(FontAwesomeIcons.facebook),
                                  iconSize: 35,
                                  splashRadius: 24,
                                ),
                                IconButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return ChangeAccount("Change Instagram Account","Account","Instagram",instagramController);
                                    });
                                  },
                                  icon: Icon(FontAwesomeIcons.instagram),
                                  iconSize: 35,
                                  splashRadius: 24,
                                ),
                                IconButton(
                                  onPressed: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return ChangeAccount("Change Twitter Account","Account","Twitter",twitterController);
                                    });
                                  },
                                  icon: Icon(FontAwesomeIcons.twitter),
                                  iconSize: 35,
                                  splashRadius: 24,
                                ),
                              ],),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.of(context).pop();
                              },
                                  child: Text("Close",
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  )
                              ),
                            ],
                          );
                        });
                  },
             child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 8.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(title,
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.w500,
                       color: Colors.grey[600],
                     ),
                   ),
                   Icon(
                     Icons.arrow_forward_ios,
                     color: Colors.grey,
                   ),
                 ],),
             ),


           );
  }
  Widget ChangeAccount(String title,String hintetxt,String type,TextEditingController Controller){
       return AlertDialog(
           title: Text(title),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             TextField(
               controller: Controller,
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 hintText: hintetxt,
                 isDense: true,
                 contentPadding: EdgeInsets.all(8),
                 filled: true,
               ),
             ),
             SizedBox(height: 30),
             Container(
               width: 300,
               child:  FloatingActionButton(
                 onPressed: () {
                   heroTag:
                   "heroTag";
                    Updateaccount(type);
                 },
                 shape: RoundedRectangleBorder(),
                 child: Text("Update Account"),
               ),
             ),
           ],
         ),
       );

  }

  Widget UpgradeOption(String price){
    return  FloatingActionButton.extended(
          onPressed: () {
            this.artistService.updateArtistPremium(widget.artist.id).then((value){
              Navigator.of(context).pop();
            });
          },

             label:  Text(
                 price,
                 style: TextStyle(
                     fontSize: 30
                 ),
               ),


              icon: Icon(
                 Icons.attach_money,
                 size: 40,
               )





        )
      ;

  }

  actionSheetMethod(BuildContext context){
    showCupertinoModalPopup(
        context: context,
        builder: (context){
          return CupertinoActionSheet(
            title: Text("You are about to leave",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black
            ),
            ),
            message: Text("If you sign out you will have to enter your credentials again",
              style: TextStyle(
                  fontSize: 16,
              ),
            ) ,
            cancelButton: CupertinoActionSheetAction(

              onPressed: (){Navigator.of(context).pop();},
              child: Text("Cancel",
              style: TextStyle(
                color: Colors.black
              ),
              ),
            ) ,
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text("Leave",
                  style: TextStyle(
                    color: Colors.black

                  ),
                  ),
              ),
            ],
          );
        }
    );
  }
}