import 'package:flutter/material.dart';

import '../../../core/service/AuthService.dart';
import '../../../core/service/ImageUserService.dart';
import '../../../domain/entities/ImageResource.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({Key? key,required this.messages}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  AuthService authService=AuthService();
  ImageUserService imageUserService=ImageUserService();
  ImageResource imageResource=new ImageResource(0, "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png", 0, "0", 0);
  String username = "Usuario";
  int userId=0;

  @override
  void initState() {
    super.initState();

    String tep;
    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;

            this.imageUserService.getImageByUserId(userId).then((value){
              setState(() {
                this.imageResource = value[0];
              });
            });
          });
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(itemBuilder: (context, index){
      return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: widget.messages[index]['isUserMessage']
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if(widget.messages[index]['isUserMessage'] == false)
              CircleAvatar(backgroundImage: AssetImage('assets/imgs/chatbot_avatar.png')),
            SizedBox(width: 5,),
            Container(
                padding: EdgeInsets.symmetric(
                    vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        20,
                      ),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(
                          widget.messages[index]['isUserMessage']
                              ? 0
                              : 20),
                      topLeft: Radius.circular(
                          widget.messages[index]['isUserMessage']
                              ? 20
                              : 0),
                    ),
                    color: widget.messages[index]['isUserMessage']
                        ? Colors.white
                        : Colors.white),
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Text(widget.messages[index]['message'].text.text[0])),
            SizedBox(width: 5,),
            if(widget.messages[index]['isUserMessage'] == true)
              CircleAvatar(backgroundImage: NetworkImage(this.imageResource.imagenUrl),)
          ],
        ),
      );
    },
        separatorBuilder: (_, i) => Padding(padding: EdgeInsets.only(top: 10)),
        itemCount: widget.messages.length);
  }
}
