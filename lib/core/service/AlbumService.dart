import 'dart:convert';

import 'package:fortloom/domain/entities/AlbumResource.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/ArtistResource.dart';
class AlbumService{

  var log=Logger();
  var baseUrl = "http://10.0.2.2:8081/api/v1/userservice/albums";


  Future<List<AlbumResource>> getall() async{

    final response = await http.get(Uri.parse(baseUrl));
    List<AlbumResource>albums=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){

      ArtistResource artistResource= new ArtistResource(item["artist"]["id"],item["artist"]["username"] ,item["artist"]["realname"] ,item["artist"]["lastname"] ,
          item["artist"]["email"], item["artist"]["password"],item["artist"]["artistfollowers"], item["artist"]["instagramLink"],
          item["artist"]["facebookLink"], item["artist"]["twitterLink"],item["aboutMe"]);

      AlbumResource albumResource= new AlbumResource(item["id"], item["name"], item["description"], artistResource);

      albums.add(albumResource);



    }
    return albums;






  }

  Future<List<AlbumResource>> getbyArtist(int artistId) async{



    final response = await http.get(Uri.parse("${baseUrl}/artist/${artistId.toString()}/albums"));
    List<AlbumResource>albums=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){

      ArtistResource artistResource= new ArtistResource(item["artist"]["id"],item["artist"]["username"] ,item["artist"]["realname"] ,item["artist"]["lastname"] ,
          item["artist"]["email"], item["artist"]["password"],item["artist"]["artistfollowers"], item["artist"]["instagramLink"],
          item["artist"]["facebookLink"], item["artist"]["twitterLink"],item["aboutMe"]);

      AlbumResource albumResource= new AlbumResource(item["id"], item["name"], item["description"], artistResource);

      albums.add(albumResource);



    }
    return albums;








  }

  Future<int> addAlbum(String name, String Description,int ArtistId) async {


    Map data ={
      'name': '$name',
      'description': '$Description',
    };
    var body = json.encode(data);
    final response = await http.post(Uri.parse(baseUrl + "/artist/"+ArtistId.toString()+"/newAlbum"),
        headers: {"Content-Type": "application/json"}, body: body);

    log.i(response.body);
    log.i(response.statusCode);


    String boydpage = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(boydpage);
    print(jsonData["id"]);
    return jsonData["id"];






  }














}