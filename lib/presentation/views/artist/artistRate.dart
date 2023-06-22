import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/core/service/RateService.dart';

class artistRate extends StatefulWidget {
  const artistRate({Key? key, required this.artistid, required this.userid}) : super(key: key);
  final int artistid;
  final int userid;
  @override
  State<artistRate> createState() => _artistRateState();
}

class _artistRateState extends State<artistRate> {
  RateService rateService=RateService();
  double setrates=0.0;
  void setratesvalues(double value) {

    this.rateService.existbyartistoidandfanaticid(widget.artistid,widget.userid).then((result) {

          if(result=="false"){
             this.rateService.createRate(widget.artistid,widget.userid, value).then((result) {
               Fluttertoast.showToast(
                   msg: "Nuevo Rate",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.CENTER,
                   textColor: Colors.white,
                   fontSize: 16.0

               );
               setState((){
                 setrates=value;
               });
             });

          }else{
            this.rateService.getRateByartistIdandfanaticId(widget.artistid,widget.userid).then((result) {
              Fluttertoast.showToast(
                  msg: "Actualizado el Rate",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.white,
                  fontSize: 16.0

              );
              this.rateService.updateRate(result, value).then((result) {
                setState((){

                  setrates=value;
                });


              });



            });

          }


    });

  }


  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: 1.5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.orange),
          half: const Icon(
            Icons.star_half,
            color: Colors.orange,
          ),
          empty: const Icon(
            Icons.star_outline,
            color: Colors.orange,
          )),
      onRatingUpdate: (double value) {
        print(value);
        setratesvalues(value);
      },
    );
  }
}
