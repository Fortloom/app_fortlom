import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/core/service/ArtistService.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/EventService.dart';
import 'package:fortloom/core/service/ForumService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/EventResource.dart';
import 'package:fortloom/domain/entities/ForumResource.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';

import '../../../core/service/FanaticService.dart';
import '../../../core/service/PublicationService.dart';
import 'Messages.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String,dynamic>> messages = [];
  final PublicationService publicationService = PublicationService();
  final ArtistService artistService = ArtistService();
  final AuthService authService = AuthService();
  final EventService eventService = EventService();
  final FanaticService fanaticService = FanaticService();
  EventResource eventResource = EventResource(0, "name", "description", DateTime.now(),
      new ArtistResource(0, "username", "realname", "lastname", "email@gmail.com", "password", 0, null, null, null,"aa") , 0, "ticketLink", DateTime.now());
  ForumResource forumResource = ForumResource(0, "forumname", "forumdescription", "forumrules",new PersonResource(0, "username", "realname", "lastname", "email@gmail.com", "password"));
  final ForumService forumService = ForumService();
  var auxlinks = [];
  Message? obtainresponse = Message();
  var mayus;
  int userId=0;
  int contevent = 0;
  String username = "Usuario";
  bool ispremium = false;
  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();

    String tep;
    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Fortlom Bot"),
        actions: [
          Image.asset('assets/imgs/logo.png'),
          Padding(padding: EdgeInsets.only(right: 30))
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/imgs/background_chatbot.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages:messages)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8
              ),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(child:
                  TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                   )
                  ),
                  IconButton(onPressed: (){
                     sendMessage(_controller.text);
                     _controller.clear();
                  }, icon: Icon(Icons.send, color: Colors.white,))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async{
    if(text.isEmpty){
      print("Message is Empty");
    }else{
      setState(() {
        addMessages(Message(
          text: DialogText(text: [text])
        ),true);
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text))
      );
      if(response.message == null) return;
      obtainresponse = response.message;
      setState(() {

        if(obtainresponse!.text!.text!.first == "Se creo la publicación correctamente :D" || obtainresponse!.text!.text!.first == "Se creo el evento correctamente :D" || obtainresponse!.text!.text!.first == "Se creo el foro correctamente :D"){

        }else if(obtainresponse!.text!.text!.first == "Muy bien, que tipo de usuario es?"){
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              artistService.checkremiumartistid(userId).then((respremium){
                if(respremium == true){
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Es un artista con plan premium por lo cual puede crear publicaciones y eventos"])));
                  });
                }else{
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Es un artista con plan free o normal por lo cual puede crear solo publicaciones"])));
                  });
                }
              });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["Es un fanatico por lo cual no puede crear contenido mil disculpas :c"])));
              });
            }
          });
        }else if(obtainresponse!.text!.text!.first == "Perfecto! deseas crear un evento por favor coloque el nombre del evento a crear"){
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              artistService.checkremiumartistid(userId).then((respremium){
                if(respremium == true){
                  setState(() {
                    addMessages(response.message!);
                  });
                }else{
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Es un artista con plan free o normal por lo cual puede crear solo publicaciones"])));
                  });
                }
              });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["Es un fanatico por lo cual no puede crear contenido mil disculpas :c"])));
              });
            }
          });
        }else if(obtainresponse!.text!.text!.first == "Genial! ahora coloque la descripción que desea para su nuevo evento"){
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              artistService.checkremiumartistid(userId).then((respremium){
                if(respremium == true){
                  setState(() {
                    addMessages(response.message!);
                  });
                }else{
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Es un artista con plan free o normal por lo cual puede crear solo publicaciones"])));
                  });
                }
              });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["Es un fanatico por lo cual no puede crear contenido mil disculpas :c"])));
              });
            }
          });
        }else if(obtainresponse!.text!.text!.first == "Perfecto! deseas crear una publicación por favor coloque la descripción que desea colocar"){
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              setState(() {
                addMessages(response.message!);
              });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["Es un fanatico por lo cual no puede crear contenido mil disculpas :c"])));
              });
            }
          });
        }else if(obtainresponse!.text!.text!.first == "Usted es el siguiente tipo de usuario"){
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              artistService.checkremiumartistid(userId).then((respremium){
                if(respremium == true){
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Es un artista con plan premium"])));
                  });
                }else{
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Es un artista con plan free o normal"])));
                  });
                }
              });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["Es un fanatico"])));
              });
            }
          });
        }else if(obtainresponse!.text!.text!.first == "Los datos son los siguientes"){
          artistService.existartistId(userId).then((resartist){
            fanaticService.existfanaticId(userId).then((resfanatic){

              if(resartist == true){
                artistService.getArtistbyId(userId).then((resobjectartist){
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Nombre: ${resobjectartist.realname}\n Apellido: ${resobjectartist.lastname}\n Email: ${resobjectartist.email}\n Followers: ${resobjectartist.artistfollowers}"])));
                  });
                });
              }

              if(resfanatic == true){
                fanaticService.getFanaticbyId(userId).then((resobjectfanatic){
                  setState(() {
                    addMessages(Message(text: DialogText(text: ["Nombre: ${resobjectfanatic.realname}\n Apellido: ${resobjectfanatic.lastname}\n Email: ${resobjectfanatic.email}\n Alias: ${resobjectfanatic.fanaticalias}"])));
                  });
                });
              }

            });
          });
        }
        else{
          addMessages(response.message!);
        }

        print(text);
        print(obtainresponse!.text!.text!.first);

        //Para crear publicaciones
        if(obtainresponse!.text!.text!.first == "Se creo la publicación correctamente :D"){
          print(text);
          print(obtainresponse!.text!.text!.first);
          mayus = auxlinks.length > 0;
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              publicationService.addPost(text, userId, mayus.toString());
              setState(() {
                addMessages(response.message!);
              });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["No se creo correctamente! :c"])));
              });
              Fluttertoast.showToast(
                  msg: "No es un artista por tal motivo no puede crear publicaciones!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 7,
                  fontSize: 16.0
              );
            }
          });
        }

        //Para crear eventos
        //Para colocar el nombre del evento
        if(obtainresponse!.text!.text!.first == "Genial! ahora coloque la descripción que desea para su nuevo evento"){
          print(text);
          print(obtainresponse!.text!.text!.first);

          eventResource.name = text;
          print(eventResource);
          print(eventResource.name);
        }


        //Para colocar la descripcion del evento
        if(obtainresponse!.text!.text!.first == "Se creo el evento correctamente :D"){
          print(text);
          print(obtainresponse!.text!.text!.first);

          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
                artistService.checkremiumartistid(userId).then((responsepremium){
                  ispremium = responsepremium;

                  print(ispremium);

                  if(ispremium == true){
                    eventService.addEvents(eventResource.name,text,"https://teleticket.com.pe/","",userId);
                    setState(() {
                      addMessages(response.message!);
                    });
                  }else{
                    setState(() {
                      addMessages(Message(text: DialogText(text: ["No se creo correctamente! :c"])));
                    });
                    Fluttertoast.showToast(
                        msg: "No es artista premium, por favor mejorar su cuenta a premium para crear un evento!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 7,
                        fontSize: 16.0
                    );
                  }
                });
            }else{
              setState(() {
                addMessages(Message(text: DialogText(text: ["No se creo correctamente! :c"])));
              });
              Fluttertoast.showToast(
                  msg: "No es un artista por tal motivo no puede crear eventos!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 7,
                  fontSize: 16.0
              );
            }
          });
        }

        //Para crear foros
        //Para colocar su titulo del foro
        if(obtainresponse!.text!.text!.first == "Perfecto! ahora coloque la descripción que desea para su nuevo foro"){
          print(text);
          print(obtainresponse!.text!.text!.first);

          forumResource.forumname = text;
          print(forumResource);
          print(forumResource.forumname);
        }

        //Para colocar su descripcion del foro
        if(obtainresponse!.text!.text!.first == "Se creo el foro correctamente :D"){
          print(text);
          print(obtainresponse!.text!.text!.first);

          forumService.addForum(forumResource.forumname, text, userId);
          setState(() {
            addMessages(response.message!);
          });
        }

      });
    }
  }

  addMessages(Message message, [bool isUserMessage = false]){ //default value in the bool variable = false
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage
    });
  }
}
