import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/core/service/AlbumService.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/framework/globals.dart';
import '../../../core/service/ImagePublicationService.dart';

class AlbumCreate extends StatefulWidget {
  const AlbumCreate({Key? key,required this.id}) : super(key: key);
  final int id;

  @override
  State<AlbumCreate> createState() => _AlbumCreateState();
}

class _AlbumCreateState extends State<AlbumCreate> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController DescriptionController =
  new TextEditingController();
  final AlbumService albumService= new AlbumService();
  File? image;
  ImagePublicationService imagePublicationService= new ImagePublicationService();
  Future pickImagefromGallery() async{
    final image=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image==null)return;
    final imageTemporary = File(image.path);
    setState(()=>this.image=imageTemporary);

  }
  Future pickImagefromCamera() async{
    final image=await ImagePicker().pickImage(source: ImageSource.camera);
    if(image==null)return;
    final imageTemporary = File(image.path);
    setState(()=>this.image=imageTemporary);

  }
  void PostImage(){

    if(this.image!=null){

      albumService.addAlbum(nameController.text.trim(), DescriptionController.text.trim(), widget.id).then((value){




        imagePublicationService.createimageforalbum(value, this.image as File).then((value) => {

          setState(()=>this.image=null),
           Navigator.pop(context)

        });



      });
    }else{
      albumService.addAlbum(nameController.text.trim(), DescriptionController.text.trim(), widget.id).then((value){

        Navigator.pop(context);

      });


    }






  }
  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        body: Container(
          width: ScreenWH(context).width,
          height: ScreenWH(context).height,

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/imgs/song.jpg"),
                  fit: BoxFit.fill
              )
          ),
          child: Column(
            children: [

            Text(
                  "Create New Album",
                  style: TextStyle(fontSize: 35,fontWeight:FontWeight.bold,color: Colors.greenAccent),
              textAlign: TextAlign.center,

                ),
              SizedBox(height: 30),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Container(
                      width: 300,
                      height: 200,
                      child: TextField(
                        controller: nameController,
                        maxLength: 30,
                        decoration: InputDecoration(
                            counterStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          hintText: 'Album Name',
                          hintStyle: TextStyle(
                            fontSize: 25
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          filled: true,
                          fillColor: Colors.white
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                width: 400,
                child: Center(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 20,
                    maxLength: 300,
                    controller: DescriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterStyle: TextStyle(color: Colors.white),
                      hintText: 'Description',
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(
                          fontSize: 25
                      ),
                    ),
                  ),
                )

              ),
              SizedBox(height: 30,),
              IconButton(
                  onPressed: () {

                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.grey,
                        child:  Container(
                          height:350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child:Text(
                                  "Metodo para conseguir imagen",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                width: 300,
                                height: 60,
                                child: ElevatedButton.icon(
                                    onPressed: (){
                                      pickImagefromGallery();
                                    },
                                    icon: Icon(
                                      Icons.image_outlined,
                                      size: 40.0,
                                    ),
                                    label: Text("Galeria",style: TextStyle(
                                        fontSize: 30
                                    ),)


                                ),
                              ),
                              SizedBox(height: 30,),
                              Container(
                                width: 300,
                                height: 60,
                                child:  ElevatedButton.icon(
                                    onPressed: (){
                                      pickImagefromCamera();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40.0,
                                    ),
                                    label: Text("Camara",style: TextStyle(
                                        fontSize: 30
                                    ),)


                                ),
                              ),

                              SizedBox(height: 30,),

                            ],
                          ),

                        ),





                      ),
                    );
                    //pickImage();
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  )),
              image != null
                  ?Image.file(
                image!,
                width: 100,
                height: 70,
                fit: BoxFit.cover,
              ):
              Text(""),
              SizedBox(height: 10,),
              Container(
                width: 300,
                height: 50,
                color: Colors.redAccent,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)
                  ),
                    onPressed: (){

                      PostImage();



                    },
                    icon: Icon(Icons.save,size: 30,),
                    label: Text("Save",style: TextStyle(
                        fontSize: 20
                    ),)),
              ),



            ],


          ),

        )



    );
  }
}
