


import 'dart:ffi';

import 'package:fortloom/domain/entities/RateResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
class RateService{
  var log=Logger();
  var baseUrl = "https://fortlom-support.herokuapp.com/api/v1/supportservice";



  Future<String>  existbyartistoidandfanaticid(int artistoid,int fanaticid)async{
    final response = await http.get(Uri.parse("${baseUrl}/check/${artistoid}/${fanaticid}/rates"));
    log.i(response.body);
    log.i(response.statusCode);
    return response.body;
  }
  Future<http.Response>createRate(int artistId,int fanaticId,double review)async{
    Map data ={
      'review': '$review',

    };
    var body = json.encode(data);
    final response = await http.post(Uri.parse("${baseUrl}/artists/${artistId}/fanatics/${fanaticId}/rates"),
        headers: {"Content-Type": "application/json"}, body: body
    );
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
  Future<int>getRateByartistIdandfanaticId(int artistId,int fanaticId)async{
    final response = await http.get(Uri.parse("${baseUrl}/artists/${artistId}/fanatics/${fanaticId}/rates"));
    List<RateResource>rates=[];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]){

      print(item["id"]);
      return item["id"];

    }
    return 0;
  }
  Future<http.Response>updateRate(int rateId,double review)async{
    Map data ={
      'review': '$review',

    };
    var body = json.encode(data);
    final response = await http.put(Uri.parse("${baseUrl}/update/${rateId}"),
        headers: {"Content-Type": "application/json"}, body: body
    );
    log.i(response.body);
    log.i(response.statusCode);

    return response;

  }
}