import 'package:fortloom/domain/entities/PublicationResource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

import '../../domain/entities/ArtistResource.dart';

class PublicationService {
  var baseUrl = "http://10.0.2.2:8082/api/v1/contentservice";
  var log = Logger();

  Future<List<PublicationResource>> getall() async {
    final response = await http.get(Uri.parse(baseUrl + "/publications"));
    List<PublicationResource> lstPosts = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ArtistResource artist = ArtistResource(
          item["artist"]["id"],
          item["artist"]["username"],
          item["artist"]["realname"],
          item["artist"]["lastname"],
          item["artist"]["email"],
          item["artist"]["password"],
          item["artist"]["artistfollowers"],
          item["artist"]["instagramLink"],
          item["artist"]["facebookLink"],
          item["artist"]["twitterLink"],
          item["aboutMe"]);
      if (item["registerdate"].runtimeType != Null) {
        DateTime tsdate =
            DateTime.fromMillisecondsSinceEpoch(item["registerdate"]);
        PublicationResource publicationResource = PublicationResource(
            item["id"],
            item["description"],
            item["image"],
            tsdate,
            item["artistid"],
            artist);

        lstPosts.add(publicationResource);
      } else {
        PublicationResource publicationResource = PublicationResource(
            item["id"],
            item["description"],
            item["image"],
            null,
            item["artistid"],
            artist);

        lstPosts.add(publicationResource);
      }
    }
    return lstPosts;
  }

  Future<int> addPost(String description, int artistId, String type) async {
    Map data = {
      'description': '$description',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(baseUrl + "/artists/${artistId}/type/${type}/publications"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);
    String boydpage = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(boydpage);
    print(jsonData["id"]);
    return jsonData["id"];
  }
}
