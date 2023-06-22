import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:intl/intl.dart';

import '../../../core/service/EventService.dart';

class PostEventForm extends StatefulWidget {
  const PostEventForm({Key? key,required this.artist}) : super(key: key);
  final int artist;

  @override
  State<PostEventForm> createState() => _PostEventFormState();
}

class _PostEventFormState extends State<PostEventForm> {

  EventService eventService=new EventService();
  var nametextfield = TextEditingController();
  var descriptiontextfield = TextEditingController();
  var datetextfield = TextEditingController();
  var tickettextfield= TextEditingController();
  String fechastring = "fecha";
  DateTime fechadescription = DateTime(2022,06,15);
  DateTime fechapredefinida = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        body: Column(

          children: [
            Text("Create your Event!",style: TextStyle(
                fontSize: 30
            ),),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: 
              
              Column(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    controller: nametextfield,
                    maxLength: 50,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'EventName',
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: descriptiontextfield,
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 20,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'EventDescription',
                    ),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: tickettextfield,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'TicketLink',
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child:  IconButton(
                        onPressed: () async{
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              initialDate: fechapredefinida
                          );

                          if(newDate == null) return;
                          setState(() {
                            fechadescription = newDate;
                            print(fechadescription);
                          });
                        },
                        icon: Icon(Icons.calendar_month,size: 45,)
                    ),
                  ),

                ],


              ),
            ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  SizedBox(width: 10,),

                  Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: (){
                        print("Fecha a utilizar: $fechadescription");
                        String fechaevento = DateFormat('yyyy-MM-ddTHH:mm:ss').format(fechadescription); //parse me ayuda para convertir un string a Datetime y format de datetime a string
                        print("Nueva Fecha convertida: $fechaevento");
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context)=> AlertDialog(
                              title: Text("¿Quiere crear un evento?"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(32.0))
                              ),
                              actions: [
                                TextButton(onPressed:(){
                                  eventService.addEvents(nametextfield.text.trim(), descriptiontextfield.text.trim(), tickettextfield.text.trim(),
                                      fechaevento, widget.artist).then((value){
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });

                                }, child: Text(
                                    "Crear"
                                )),
                                TextButton(onPressed:(){

                                  Navigator.of(context).pop();
                                }, child: Text(
                                    "Cancelar"
                                )),
                              ],

                            ));

                      },
                      child:Text("Post",style: TextStyle(color: Colors.black,fontSize: 30),),
                      style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),

                    ),
                  ),
                  SizedBox(width: 40,),
                  Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        nametextfield.text = '';
                        descriptiontextfield.text = '';
                        datetextfield.text = '';
                      },
                      child:Text("Clean",style: TextStyle(color: Colors.black,fontSize: 30)),
                      style: TextButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),

                    ),
                  ),

                  SizedBox(width: 10,),

                ],
              ),




          ],
        )
    );
  }
}

