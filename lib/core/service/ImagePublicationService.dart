import 'dart:io' as io;

import 'package:fortloom/domain/entities/ImageResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class ImagePublicationService {
  var log = Logger();
  var baseUrl =
      "https://fortlom-multimedia.herokuapp.com/api/v1/multimediaservice";

  Future<int> createimageforpublication(
      int publicationsId, io.File image) async {
    final postUri =
        Uri.parse("${baseUrl}/upload/publications/${publicationsId}/images");
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('multipartFile', image.path);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    log.i(response.statusCode);

    return response.statusCode;
  }

  Future<int> createimageforalbum(int albumId, io.File image) async {
    final postUri = Uri.parse("${baseUrl}/upload/albums/${albumId}/images");
    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('multipartFile', image.path);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    log.i(response.statusCode);

    return response.statusCode;
  }

  Future<List<ImageResource>> getImageByPublicationId(
      int publicationsId) async {
    final response = await http
        .get(Uri.parse(baseUrl + "/publications/${publicationsId}/images"));
    List<ImageResource> lstPosts = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ImageResource imageResource = ImageResource(item["id"], item["imagenUrl"],
          item["userid"], item["imagenId"], item["publicationid"]);
      lstPosts.add(imageResource);
    }
    return lstPosts;
  }

  Future<List<ImageResource>> getImageByAlbumId(int albumId) async {
    final response =
        await http.get(Uri.parse(baseUrl + "/album/${albumId}/images"));
    List<ImageResource> lstPosts = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ImageResource imageResource = ImageResource(item["id"], item["imagenUrl"],
          item["userid"], item["imagenId"], item["publicationid"]);
      lstPosts.add(imageResource);
    }
    return lstPosts;
  }
}
