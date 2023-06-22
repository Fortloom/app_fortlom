
import 'package:fortloom/domain/entities/AlbumResource.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/SongResource.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MusicService{


  var log=Logger();
  var baseUrl = "http://10.0.2.2:8081/api/v1/userservice/songs";


  Future<List<SongResource>> getbyAlbum(int albumId) async{

    final response = await http.get(Uri.parse("${baseUrl}/album/${albumId.toString()}/songs"));
    List<SongResource>songs=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){
      ArtistResource artistResource= new ArtistResource(item["album"]["artist"]["id"],item["album"]["artist"]["username"] ,item["album"]["artist"]["realname"] ,item["album"]["artist"]["lastname"] ,
          item["album"]["artist"]["email"], item["album"]["artist"]["password"],item["album"]["artist"]["artistfollowers"], item["album"]["artist"]["instagramLink"],
          item["album"]["artist"]["facebookLink"], item["album"]["artist"]["twitterLink"],item["aboutMe"]);
        AlbumResource albumResource= new AlbumResource(item["album"]["id"], item["album"]["name"], item["album"]["description"], artistResource);
        SongResource songResource= new SongResource(item["id"], item["name"],item["musicUrl"] , item["category"], albumResource);
        songs.add(songResource);

    }
    return songs;


  }
  Future<http.Response> addSong(String name, String musicUrl,String category,int albumid) async {

    Map data ={
      'name': '$name',
      'musicUrl': '$musicUrl',
      'category': '$category',
    };
    var body = json.encode(data);
    final response = await http.post(Uri.parse(baseUrl + "/album/"+albumid.toString()+"/newSong"),
        headers: {"Content-Type": "application/json"}, body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;




  }














}