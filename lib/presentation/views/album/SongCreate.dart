import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/core/service/MusicService.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';

import '../../../core/framework/globals.dart';

class SongCreate extends StatefulWidget {
  const SongCreate({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<SongCreate> createState() => _SongCreateState();
}

class _SongCreateState extends State<SongCreate> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController urlController = new TextEditingController();
  final MusicService musicService = new MusicService();
  final items = [
    'Rock',
    'Pop',
    'Metal',
    'Regueton',
    'Jazz',
    'Classic',
    'Blues',
    'Country'
  ];
  String? value;
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        body: Container(
      width: ScreenWH(context).width,
      height: ScreenWH(context).height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/imgs/Battlelogo.jpg"),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Text(
            "New Song",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 50, color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: nameController,
                  maxLength: 30,
                  decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.indigoAccent),
                      border: OutlineInputBorder(),
                      hintText: 'Song Name',
                      hintStyle: TextStyle(fontSize: 25),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      filled: true,
                      fillColor: Colors.white),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.indigoAccent),
                      border: OutlineInputBorder(),
                      hintText: 'URL',
                      hintStyle: TextStyle(fontSize: 25),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      filled: true,
                      fillColor: Colors.white),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.black,
                      ),
                      items: items.map(buildMenuItem).toList(),
                      onChanged: (value) => setState(() => this.value = value),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 300,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (this.urlController.text.contains("youtube")) {
                        this
                            .musicService
                            .addSong(nameController.text.trim(),
                                urlController.text.trim(), value!, widget.id)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Debe Ser un Link de youtube",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    icon: Icon(Icons.music_video, size: 40),
                    label: Text(
                      "Save Your Song",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
