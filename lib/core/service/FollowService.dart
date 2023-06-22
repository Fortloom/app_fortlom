import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/FollowResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';


class FollowService {
  var log=Logger();
  var baseUrl = "https://fortlom-support.herokuapp.com/api/v1/supportservice";

  Future<http.Response> createFollow(int artistId, int fanaticId,bool followbool) async{
    final response = await http.post(Uri.parse("${baseUrl}/artists/${artistId}/fanatics/${fanaticId}/boolfollow/${followbool}/follows"));
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }

  Future<String> existbyartistoidandfanaticid(int artistId, int fanaticId)async{
    final response = await http.get(Uri.parse("${baseUrl}/check/${artistId}/fanatics/${fanaticId}"));
    log.i(response.body);
    log.i(response.statusCode);
    return response.body;
  }
  Future<List<FollowResource>>geybyartistoidandboleean(int artistId,bool boolagree)async{
    final response = await http.get(Uri.parse("${baseUrl}/artists/${artistId}/agreess/${boolagree}/opinions"));
    log.i(response.body);
    log.i(response.statusCode);
    List<FollowResource>folows=[];
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){
        FollowResource followResource=FollowResource(item["id"], item["artistid"], item["fanaticid"]);
       folows.add(followResource);

    }
    return folows;

  }
  Future<int>geybyartistoidandfanaticid(int artistId,int fanaticid)async{

    final response = await http.get(Uri.parse("${baseUrl}/artists/${artistId}/fanatics/${fanaticid}/follows"));
    log.i(response.body);
    log.i(response.statusCode);
    List<FollowResource>folows=[];
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){
      print(item["id"]);
      return item["id"];

    }
    return 0;

  }




  Future<List<FollowResource>> getFollowByartistId(int artistId)async{
    final response = await http.get(Uri.parse("${baseUrl}/artists/${artistId}/follows"));
    log.i(response.body);
    log.i(response.statusCode);
    List<FollowResource>folows=[];
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){
      FollowResource followResource=FollowResource(item["id"], item["artistid"], item["fanaticid"]);
      folows.add(followResource);

    }
    return folows;

  }
  Future<http.Response>update(int followId,bool boolfollow)async{
    final response = await http.put(Uri.parse("${baseUrl}/update/${followId}/follow/${boolfollow}"));
    log.i(response.body);
    log.i(response.statusCode);
    return response;

  }












}