import 'dart:ffi';

import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/FanaticResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

//192.168.43.65
//192.168.0.201
class FanaticService {
  var log=Logger();
  var baseUrl = "http://10.0.2.2:8081/api/v1/userservice/fanatics";


  Future<List<FanaticResource>> getallFanatics() async{
    final response = await http.get(Uri.parse(baseUrl));
    List<FanaticResource>fanatics=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){

      FanaticResource fanaticResource = new FanaticResource(item["id"],
          item["username"] ,item["realname"] ,item["lastname"] ,
          item["email"], item["password"], item["fanaticalias"]);

      fanatics.add(fanaticResource);
    }
    return fanatics;
  }






  Future<FanaticResource>getFanaticbyId(int fanaticId) async{
    final response = await http.get(Uri.parse(baseUrl+"/"+fanaticId.toString()));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    FanaticResource fanaticResource= new FanaticResource(jsonData["id"],
        jsonData["username"] ,jsonData["realname"] ,jsonData["lastname"] ,
        jsonData["email"], jsonData["password"], jsonData["fanaticalias"]);
    return fanaticResource;
  }

  Future<bool> existfanaticId(int fanaticId) async{
    final response = await http.get(Uri.parse(baseUrl+"/check/"+fanaticId.toString()));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);

    return body == "true" ? true:false;

  }

}