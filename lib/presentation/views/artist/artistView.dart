import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fortloom/core/service/ArtistService.dart';
import 'package:fortloom/core/service/FollowService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/presentation/views/artist/artistSupport.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';
import 'package:http/src/response.dart';

import '../../../core/framework/globals.dart';
import '../../../core/service/AuthService.dart';
import '../../../domain/entities/PersonResource.dart';
import '../../widgets/screenBase.dart';

class ArtistView extends StatefulWidget with NavigationStates {
  const ArtistView({Key? key}) : super(key: key);

  @override
  State<ArtistView> createState() => _ArtistState();
}

class _ArtistState extends State<ArtistView> {
  int likes = 11;
  String imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/640px-PNG_transparency_demonstration_1.png";
  ArtistService artistService=new ArtistService();
  AuthService authService= new AuthService();
  String username="Usuario";
  PersonResource personResource= new PersonResource(0, "username", "realname", "lastname", "email", "password");
  bool post = false;
  List<ArtistResource>artits=[];
  var nametextfield = TextEditingController();
  var descriptiontextfield = TextEditingController();
  var datetextfield = TextEditingController();
  String fechastring = "fecha";
  DateTime fechadescription = DateTime(2022,06,15);
  DateTime fechapredefinida = DateTime.now();
  int userid=0;
  void getdata(){
    artistService.getallArtists().then((value){
          this.artits=value;

    });
  }

  @override
  void initState() {
    this.getdata();
    super.initState();
    String tep;
    this.authService.getToken().then((result){
      setState(() {
        tep= result.toString();
        username=this.authService.GetUsername(tep);
        this.authService.getperson(username).then((result) {
          setState(() {
            personResource=result;
            this.userid=personResource.id;
          });
        });
      });
    }) ;
  }
  
  @override
  Widget build(BuildContext context) {
    Future<void> _pullRefresh() async {
      artistService.getallArtists().then((value) {
        setState(() {
          this.artits = value;
        });
      });

    }
    return ScreenBase(
        body: Container(
            height: ScreenWH(context).height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://cdn.discordapp.com/attachments/1011046180064604296/1041115572852752465/artistlist.jpg"),
                    fit: BoxFit.cover
                )
            ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Container(
                  width: 300,
                  child:  Text(
                      "Get to know some of",
                      style:TextStyle(fontSize: 30,
                          color: Color(0xfff5f5f5),
                          fontWeight: FontWeight.bold)

                  ),
                ),
                Container(
                  width: 300,
                  child:Center(
                    child: Text(
                        "the most trending",
                        style:TextStyle(fontSize: 30,
                            color: Color(0xfff5f5f5),
                            fontWeight: FontWeight.bold)

                    ),
                  ),

                ),
                Container(
                  width: 300,
                  child:Center(
                    child: Text(
                        "artist right now",
                        style:TextStyle(fontSize: 30,
                            color: Color(0xfff5f5f5),
                            fontWeight: FontWeight.bold)

                    ),
                  ),

                ),
                Expanded(
                  child: artits.isNotEmpty
                      ? RefreshIndicator(
                      child: ListView.builder(
                          itemCount: artits.length,
                          itemBuilder: (context, index) {
                            return artistSupport(artistid: artits[index],userid: userid);
                          }),
                      onRefresh: _pullRefresh)
                      : const Center(child: Text("No Artists")),
                )
              ],
            ),
          )),
        );


  }
}


//const Center(child: CircularProgressIndicator()



















class ItemList extends StatefulWidget {
  const ItemList({Key? key, required this.personResource, required this.artistList}) : super(key: key);
  final List<ArtistResource>? artistList;
  final PersonResource personResource;
  @override
  State<ItemList> createState() => _ItemListState(artistList: artistList, personResource: personResource);
}

class _ItemListState extends State<ItemList> {
  _ItemListState({Key? key, required this.personResource, required this.artistList});
  List<ArtistResource>? artistList;
  final PersonResource personResource;

  Future<Response> createFollow(int artistId, int fanaticId) {
    FollowService followService = new FollowService();
    var result = followService.createFollow(artistId, fanaticId,true);
    return result;
  }

  Future<Response> updateArtist(int artistfollowers,int artistId){
    ArtistService artistService = new ArtistService();
    var result = artistService.updateArtist(artistfollowers, artistId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBase(
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: artistList?.length,
          itemBuilder: (context, index) {
            return  Card(
              color: Colors.grey,
              child: Column(
                children: [
                 /* Container(
                    child: Image.network(artistList![index].content),
                    height: 200,
                  ),*/

                  ListTile(
                    title: Center(
                        child: Text(
                          artistList![index].username,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                    ),
                  ),

                  RatingBar(
                    initialRating: Random(artistList![index].id*9999).nextDouble()*5,
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
                      //here goes API call for updating rating
                    },
                  ),

                  Row(
                    children: [
                      Text(artistList![index].artistfollowers.toString()),
                      TextButton(
                          child:Text("FOLLOW"),
                          onPressed: (){
                            createFollow(artistList![index].artistfollowers, personResource.id);
                            updateArtist(artistList![index].artistfollowers+1, artistList![index].id);
                            setState(() {
                              artistList![index].artistfollowers++;
                            });
                          }
                      ),
                      TextButton(
                        child:Text("UNFOLLOW"),
                        onPressed: () {
                          updateArtist(artistList![index].artistfollowers-1, artistList![index].id);
                          setState(() {
                            artistList![index].artistfollowers --;
                          });
                        }
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  ),
                ],
              ),
              elevation: 8,
              shadowColor: Colors.black,
              margin: EdgeInsets.all(20),
              shape:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black, width: 1)
              ),
            )
            ;
          }
      ),
    );
  }
}

