import 'package:flutter/material.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/ForumService.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:fortloom/presentation/views/Forum/ForumSection.Dart.dart';

import '../../widgets/screenBase.dart';

class ForumCreate extends StatefulWidget {
  const ForumCreate({Key? key}) : super(key: key);

  @override
  State<ForumCreate> createState() => _ForumCreateState();
}

class _ForumCreateState extends State<ForumCreate> {
  ForumService forumService = new ForumService();
  AuthService authService = new AuthService();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController DescriptionController =
      new TextEditingController();
  String username = "Usuario";
  PersonResource personResource = new PersonResource(
      0, "username", "realname", "lastname", "email", "password");

  @override
  void initState() {
    super.initState();
    String tep;

    this.authService.getToken().then((result) {
      setState(() {

        tep = result.toString();
        print("tep");
        print(tep);
        username = this.authService.GetUsername(tep);
        print(username);
        this.authService.getperson(username).then((result) {
          setState(() {
            personResource = result;
          });
        });
      });
    });
  }

  void AddForum() {
    forumService
        .addForum(nameController.text.trim(), DescriptionController.text.trim(),
            personResource.id)
        .then((result) {
      setState(() {
        Navigator.pop(context, true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  ScreenBase(
        body: Card(
          child: Column(
            children: [

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Create Forum",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Row(
                  children: [
                    Text(
                      "Insert Name",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Forun Name',
                          isDense: true,
                          contentPadding: EdgeInsets.all(8),
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 20,
                maxLength: 1000,
                controller: DescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                ),
              ),
              SizedBox(height: 30),
               Container(
                 width: 300,
                 child:  FloatingActionButton(
                   onPressed: () {
                     heroTag:
                     "heroTag";
                     AddForum();
                   },
                   shape: RoundedRectangleBorder(),
                   child: Text("Create"),
                 ),
               ),


            ],
          ),
        ),
      );
  }
}
