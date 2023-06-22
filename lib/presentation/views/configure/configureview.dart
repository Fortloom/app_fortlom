import 'dart:io';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fortloom/core/service/ArtistService.dart';
import 'package:fortloom/core/service/ImageUserService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/ImageResource.dart';

import 'package:fortloom/presentation/views/configure/configure_settingsview.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/framework/globals.dart';
import 'package:fortloom/core/service/ProfileService.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';

import 'package:url_launcher/url_launcher.dart';

import 'imageedit.dart';

class EditProfilePage extends StatefulWidget with NavigationStates {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = true;
  ProfileService profileService = ProfileService();
  AuthService authService = AuthService();
  ArtistService artistService = ArtistService();
  ImageUserService imageUserService = ImageUserService();
  final TextEditingController realnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  Uri _urlF = Uri.parse('https://www.facebook.com/?sk=welcome');
  Uri _urlI = Uri.parse('https://www.instagram.com');
  Uri _urlT = Uri.parse('https://twitter.com/i/flow/login');

  var list = [
    'Rock',
    'Jazz',
    'Indie',
    'Blues',
    'Classical',
    'Country',
    'Dance',
    'Electronic',
    'Rap',
    'Latin',
    'Metal',
    'Punk',
    'Reggae',
    'Funk',
    'Soul',
    'Pop',
    'Progressive',
    'Criolla',
    'Fusion',
    'Trap'
  ];
  File? image;
  String username = "Usuario";
  bool isartist = false;
  bool isupgrade = false;
  ArtistResource artistResource = ArtistResource(
      0,
      "username",
      "realname",
      "lastname",
      "email",
      "password",
      0,
      "instagramLink",
      "facebookLink",
      "twitterLink",
      "aboutMe");
  PersonResource personResource = PersonResource(
      0, "username", "realname", "lastname", "email", "password");
  ImageResource imageResource = ImageResource(
      0,
      "https://cdn.discordapp.com/attachments/1008578583251406990/1031677299101286451/unknown.png",
      0,
      "0",
      0);
  Future<void> _pullRefresh() async {
    String tep;

    authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = authService.GetUsername(tep);

        authService.getperson(username).then((result) {
          setState(() {
            personResource = result;
            newpasswordController.text = personResource.password;
            imageUserService.getImageByUserId(personResource.id).then((value) {
              setState(() {
                imageResource = value[0];
              });
            });
            artistService
                .getArtistbyartistname(personResource.username)
                .then((value) {
              setState(() {
                print(value.facebookLink);
                artistResource = value;
                if (value.facebookLink != null) {
                  _urlF = Uri.parse(value.facebookLink.toString());
                }
                if (value.instagramLink != null) {
                  _urlI = Uri.parse(value.instagramLink.toString());
                }
                if (value.twitterLink != null) {
                  _urlT = Uri.parse(value.twitterLink.toString());
                }
              });
            });
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    String tep;

    authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = authService.GetUsername(tep);
        isartist = authService.isartist(tep);
        isupgrade = authService.isartistupgrade(tep);
        authService.getperson(username).then((result) {
          setState(() {
            personResource = result;
            newpasswordController.text = personResource.password;
            imageUserService.getImageByUserId(personResource.id).then((value) {
              setState(() {
                imageResource = value[0];
              });
            });
            artistService
                .getArtistbyartistname(personResource.username)
                .then((value) {
              setState(() {
                print(value.facebookLink);
                artistResource = value;
                if (value.facebookLink != null) {
                  _urlF = Uri.parse(value.facebookLink.toString());
                }
                if (value.instagramLink != null) {
                  _urlI = Uri.parse(value.instagramLink.toString());
                }
                if (value.twitterLink != null) {
                  _urlT = Uri.parse(value.twitterLink.toString());
                }
              });
            });
          });
        });
      });
    });
  }

  List<Widget> lstChips = [];

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
        body: SingleChildScrollView(
            child: RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage(
                          artist: artistResource,
                          isartist: isartist,
                          isupgrade: isupgrade,
                        )));
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 16, top: 25, right: 16, bottom: 25),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(imageResource.imagenUrl))),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: Colors.black),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0.0,
                                      backgroundColor: Colors.grey,
                                      child: Editimage(id: artistResource.id),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Wrap(children: [
                      addChipButton(),
                    ]),
                  ),
                  Center(
                    child: Wrap(children: [
                      Container(
                          width: 400,
                          height: 50,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: lstChips.length,
                              itemBuilder: (context, index) {
                                return lstChips[index];
                              }))
                    ]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (isartist || isupgrade) ...[
                    Center(
                      child: Wrap(children: [
                        buildSocialNetwork(1),
                        buildSocialNetwork(2),
                        buildSocialNetwork(3),
                      ]),
                    ),
                  ],
                  const SizedBox(
                    height: 35,
                  ),
                  buildTextField("Full Name", personResource.realname,
                      realnameController, false),
                  buildTextField("Full Name", personResource.lastname,
                      lastnameController, false),
                  buildTextField(
                      "E-mail", personResource.email, emailController, false),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          realnameController.text = personResource.realname;
                          lastnameController.text = personResource.lastname;
                          emailController.text = personResource.email;
                          //newpasswordController.text=personResource.password;
                        },
                        child: const Text("Cancel",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (realnameController.text == '') {
                            realnameController.text = personResource.realname;
                          }
                          if (lastnameController.text == '') {
                            lastnameController.text = personResource.lastname;
                          }
                          if (emailController.text == '') {
                            emailController.text = personResource.email;
                          }
                          profileService.editProfile(
                              personResource.id,
                              realnameController.text.trim(),
                              lastnameController.text.trim(),
                              emailController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  buildTextField(
                      " New Password", "", newpasswordController, true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          newpasswordController.text = personResource.password;
                        },
                        child: const Text("Cancel",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (newpasswordController.text == '' ||
                              newpasswordController.text ==
                                  personResource.password) {
                            Fluttertoast.showToast(
                                msg: "Ingresepalabra",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            profileService.editPassword(personResource.id,
                                newpasswordController.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )));
  }

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget buildChip() {
    //para cambiar el orden de todos los elementos de la lista aleatoriamente
    //y devolver el primer elemento de la lista
    var randomItem = (list..shuffle()).first;
    list.removeAt(0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Chip(
        backgroundColor: Colors.black,
        label: Text(
          randomItem,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget addChipButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateTag();
                });
          },
          icon: const Icon(Icons.add),
          iconSize: 35,
          splashRadius: 24,
        ));
  }

  Widget CreateTag() {
    final TextEditingController tagController = TextEditingController();

    return AlertDialog(
      title: const Center(
        child: Text(
          "Create Tag",
          style: TextStyle(fontSize: 20),
        ),
      ),
      content: TextField(
        controller: tagController,
        maxLength: 30,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Tag Name',
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          filled: true,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              artistService
                  .createTag(tagController.text.trim(), artistResource.id)
                  .then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text("Create")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"))
      ],
    );
  }

  Widget buildSocialNetwork(int index) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: index == 1
            ? IconButton(
                onPressed: () {
                  _launchUrl(_urlF);
                },
                icon: const Icon(FontAwesomeIcons.facebook),
                iconSize: 35,
                splashRadius: 24,
              )
            : index == 2
                ? IconButton(
                    onPressed: () {
                      _launchUrl(_urlI);
                    },
                    icon: const Icon(FontAwesomeIcons.instagram),
                    iconSize: 35,
                    splashRadius: 24,
                  )
                : IconButton(
                    onPressed: () {
                      _launchUrl(_urlT);
                    },
                    icon: const Icon(FontAwesomeIcons.twitter),
                    iconSize: 35,
                    splashRadius: 24,
                  ));
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }
}
