




import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

import '../../domain/entities/ImageResource.dart';
class ImageUserService{

  var log = Logger();
  var baseUrl = "https://fortlom-multimedia.herokuapp.com/api/v1/multimediaservice";


  Future<int> createimageforuser(int userId,File file) async{







    final postUri = Uri.parse("${baseUrl}/upload/users/${userId}/images");
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'multipartFile', file.path);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    log.i(response.statusCode);

    return response.statusCode;







  }
  Future<String> getUserImageforPublication (int UserId) async {
    final response = await http.get(Uri.parse(baseUrl+"/users/${UserId}/images"));
    List<ImageResource> lstPosts = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ImageResource imageResource=ImageResource(item["id"], item["imagenUrl"], item["userid"], item["imagenId"], item["publicationid"]);
      lstPosts.add(imageResource);
    }
    ImageResource imageResource=lstPosts[0];
    return imageResource.imagenUrl;

  }


  Future<List<ImageResource>>getImageByUserId(int publicationsId)async{
    final response = await http.get(Uri.parse(baseUrl+"/users/${publicationsId}/images"));
    List<ImageResource> lstPosts = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {

      ImageResource imageResource=ImageResource(item["id"], item["imagenUrl"], item["userid"], item["imagenId"], item["publicationid"]);
      lstPosts.add(imageResource);

    }
    return lstPosts;

  }
  Future<http.Response>delete(int id)async{
    final response = await http.delete(Uri.parse(baseUrl+"/delete/${id}"));
    log.i(response.body);
    log.i(response.statusCode);
    return response;

  }





}