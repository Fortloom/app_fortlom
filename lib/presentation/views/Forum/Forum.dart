import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/ForumResource.dart';

import 'ForumPage.dart';

class ForumWidget extends StatefulWidget {
  const ForumWidget({Key? key,required this.forum}) : super(key: key);
  final ForumResource forum;

  @override
  State<ForumWidget> createState() => _ForumWidgetState();
}

class _ForumWidgetState extends State<ForumWidget> {


  navigatetoForumPage(BuildContext context,ForumResource forumResource) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForumPage(forumResource: forumResource,)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Card(
        color: Colors.grey,
        shadowColor: Colors.black,
        elevation: 50.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          onTap: (){

            navigatetoForumPage(context,widget.forum);

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                widget.forum.forumname.toUpperCase().trim(),style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
              ),
              ),
              SizedBox(height: 20,),
              Icon(
                Icons.forum,
                color: Colors.white,
                size: 40,
              ),

            ],
          ),

        ),

      ),

    );


  }
}
