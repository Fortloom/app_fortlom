import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/FollowService.dart';

class artistFollow extends StatefulWidget {
  const  artistFollow({Key? key, required this.artistid, required this.userid}) : super(key: key);
  final int artistid;
  final int userid;

  @override
  State<artistFollow> createState() => _artistFollowState();
}

class _artistFollowState extends State<artistFollow> {
  FollowService followService=FollowService();
  var setfollowsartists=204;
  void setfollows() {

    this.followService.geybyartistoidandboleean(widget.artistid,true).then((result) {
      setState(() {

        this.setfollowsartists=result.length;
      });



    });

  }
  void checkfanaticandartisfollows(){

    this.followService.existbyartistoidandfanaticid(widget.artistid, widget.userid).then((value) {
             print(value);
             if(value=="false"){

                    print("no follows");
                    this.followService.createFollow(widget.artistid, widget.userid, true).then((value){
                      setState(() {
                        this.setfollows();
                      });
                    });
             }
             else{
                 this.followService.geybyartistoidandfanaticid(widget.artistid,  widget.userid).then((value) {

                                 this.followService.update(value, true).then((value){

                                   setState(() {
                                     this.setfollows();
                                   });

                                 });


                 });
             }


    });


  }
  void checkfanaticandartisunfollows(){

    this.followService.existbyartistoidandfanaticid(widget.artistid, widget.userid).then((value) {

      if(value=="false"){
        this.followService.createFollow(widget.artistid, widget.userid, false).then((value){
          setState(() {
            this.setfollows();
          });
        });
      }else{
        this.followService.geybyartistoidandfanaticid(widget.artistid,  widget.userid).then((value) {

          this.followService.update(value, false).then((value){

            setState(() {
              this.setfollows();
            });

          });


        });
      }


    });


  }

  @override
  void initState() {

    this.setfollows();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
       children: [

         Wrap(

           crossAxisAlignment: WrapCrossAlignment.center,
           children: [

             Icon(Icons.people,color: Color(0xffcca027),size: 30,),
             SizedBox(width: 5,),
             Text('Followers:',style: TextStyle(

               fontSize: 30
             ),),
             SizedBox(width: 2,),
             Text(setfollowsartists.toString(),style: TextStyle(
                 fontSize: 30
             ),),
           ],


         ),

                 Row(
    children: [
              Icon(Icons.favorite,color: Colors.red,),
              TextButton(
                child:Text("FOLLOW",
    style: TextStyle(
    color: Colors.black,
    fontSize: 15
    ),
    ),
                 onPressed: (){
                 checkfanaticandartisfollows();
                  }
              ),
               Icon(Icons.heart_broken,color: Colors.red,),
              TextButton(
    child:Text("UNFOLLOW",
    style: TextStyle(
    color: Colors.black,
    fontSize: 15
    ),
    ),
    onPressed: (){
    checkfanaticandartisunfollows();
    }
    ),

    ],
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,

    ),
       ],
    );

  }
}
