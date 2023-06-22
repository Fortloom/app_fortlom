import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/ImageUserService.dart';
import 'package:fortloom/domain/entities/ImageResource.dart';

import '../../../../domain/entities/PublicationCommentResource.dart';

class CommentWid extends StatefulWidget {
  const CommentWid({Key? key,required this.comment}) : super(key: key);
  final PublicationCommentResource comment;
  @override
  State<CommentWid> createState() => _CommentState();
}

class _CommentState extends State<CommentWid> {
  ImageResource imageResource= new ImageResource(0, "assets/imgs/normalimage.png", 0, "0", 0);
  ImageUserService imageUserService= new ImageUserService();
  @override
  void initState(){

    this.imageUserService.getImageByUserId(widget.comment.userid).then((value){

           this.imageResource= value[0];


    });



  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              if(this.imageResource.imagenUrl=="assets/imgs/normalimage.png")...[
                CircleAvatar(
                  backgroundImage: AssetImage(
                      this.imageResource.imagenUrl),
                ),
              ]else...[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      this.imageResource.imagenUrl),
                ),
              ],



              const SizedBox(
                width: 10,
              ),
              Text(
                widget.comment.userAccount.username,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Text(
              widget.comment.commentdescription,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
