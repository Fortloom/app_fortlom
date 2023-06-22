import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/ImageUserService.dart';
import 'package:fortloom/domain/entities/ImageResource.dart';
import 'package:image_picker/image_picker.dart';

import 'configureview.dart';

class Editimage extends StatefulWidget {
  const Editimage({Key? key,required this.id}) : super(key: key);
  final int id;

  @override
  State<Editimage> createState() => _EditimageState();
}

class _EditimageState extends State<Editimage> {

  File? image;
  final ImageUserService imageUserService= new ImageUserService();
  Future pickImagefromGallery() async{
    final image=await ImagePicker().pickImage(source: ImageSource.gallery).then((value){
      if(value==null)return;
      final imageTemporary = File(value.path);
      setState(()=>this.image=imageTemporary);
    });


  }
  Future pickImagefromCamera() async{
    final image=await ImagePicker().pickImage(source: ImageSource.camera);

    if(image==null) {
      print("nulo");
      return;
    }
    final imageTemporary = File(image.path);

    setState((){
      this.image=imageTemporary;
      if(this.image!=null){
        print("imagen");

      }
    });




  }
  void PushImage(){

      this.imageUserService.getImageByUserId(widget.id).then((value){

        if(value.length!=0){
              ImageResource imageResource= value[0];
              this.imageUserService.delete(imageResource.id).then((value){
                       this.imageUserService.createimageforuser(widget.id, image!).then((value){
                         Navigator.of(context).pop();

                       });


              });

        }else{

          this.imageUserService.createimageforuser(widget.id, image!).then((value){
            Navigator.of(context).pop();

          });


        }



      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:Text(
              "Metodo para conseguir imagen",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton.icon(
              onPressed: (){
                pickImagefromGallery();
              },
              icon: Icon(
                Icons.image_outlined,
                size: 24.0,
              ),
              label: Text("Galeria")


          ),
          SizedBox(height: 10,),
          ElevatedButton.icon(
              onPressed: (){
                pickImagefromCamera();
              },
              icon: Icon(
                Icons.camera_alt_outlined,
                size: 24.0,
              ),
              label: Text("Camara")


          ),
          SizedBox(height: 30,),
          image != null
              ?Column(
              children: [
                Image.file(
                  image!,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10,),
                Container(
                  width: 200,
                  child: FloatingActionButton(
                    onPressed:(){
                      PushImage();
                    },
                    shape: RoundedRectangleBorder(),
                    child: Text(
                        "Update"
                    ),


                  ),
                )

              ],
          ) :Column(
            children: [
              FlutterLogo(size: 80),
              Text("Esperando Imagen")
            ],
          )

        ],
      ),

    );
  }
}
