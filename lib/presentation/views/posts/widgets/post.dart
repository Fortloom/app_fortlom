
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/ImagePublicationService.dart';
import 'package:fortloom/core/service/PostService.dart';
import 'package:fortloom/core/service/PublicationService.dart';
import 'package:fortloom/domain/entities/ImageResource.dart';
import 'package:fortloom/domain/entities/PostResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';
import 'package:fortloom/presentation/views/posts/widgets/comentsDialog.dart';
import 'package:fortloom/presentation/views/posts/widgets/imagePost.dart';
import 'package:fortloom/presentation/views/posts/widgets/reportDialog.dart';

import '../../../../core/service/ImageUserService.dart';
import '../../event/eventlike.dart';
import '../../event/eventlistview.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post}) : super(key: key);
  final PublicationResource post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final PublicationService _postService = PublicationService();
  final ImageUserService imageUserService=new ImageUserService();
  final ImagePublicationService imagePublicationService=ImagePublicationService();
  List<ImageResource> imalist = [];
   ImageResource imageResource=new ImageResource(0, "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png", 0, "0", 0);
  void getImage(int userId){

    this.imageUserService.getImageByUserId(userId).then((value){
      setState(() {
        this.imageResource = value[0];
      });
    });

  }



  int list=0;
  @override
  void initState() {

    this.imagePublicationService.getImageByPublicationId(widget.post.id).then((value){
      setState(() {
        print("lista");
        imalist=value;
        print(widget.post.id);
        list=imalist.length;
        print(list);
      });

    });
    getImage(widget.post.artistid);

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenWH(context).width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [headerPost(), body()],
      ),
    );
  }

  Widget headerPost() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      this.imageResource.imagenUrl

                  )
              ),
              SizedBox(width: 15),
              Text(
                widget.post.artist.username,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.report,
              color: Colors.redAccent.withOpacity(0.6),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => reportDialog(
                  userReported: widget.post.artist.id,
                  publicationid: widget.post.id,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.post.description,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if(list!=0)...[

            CarouselSlider.builder(
                itemCount: list,
                itemBuilder: (context, index,realIndex) {
                       return imagePost(image: imalist[index]);
                },
                options: CarouselOptions(height: 350,
                viewportFraction: 1,
                 enableInfiniteScroll: false
                ),
            )




          ],
           /* ListView.builder(
                itemCount: list,
                physics: ClampingScrollPhysics(),

                shrinkWrap: true,
                itemBuilder: (context, index) {
                       return imagePost(image: imalist[index]);
                }),*/






          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    //widget.post.likes++;
                  });
                  //_postService.uptPost(widget.post);
                },
                child: Row(
                  children: [

                    Eventlikes( contentid: widget.post.id),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CommetsDialog(
                        postId: widget.post.id,
                        // post: widget.post,
                      ),
                    );
                  },
                  child: const Text(
                    "View Comments",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
