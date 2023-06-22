import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/PostResource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

String currentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}

class PostService {
  var baseUrl = "http://10.0.2.2:8082/api/v1/contentservice";
  var log = Logger();
  Future<List<Post>> getall() async {
    final response = await http.get(Uri.parse(baseUrl + "/publications"));
    List<Post> lstPosts = [];
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

      Post postResource = Post(
          item["id"],
          item["publicationName"],
          item["description"],
          item["likes"],
          item["date"] ?? currentDate(),
          artist);
      lstPosts.add(postResource);
    }

    return lstPosts;
  }

  Future<http.Response> addPost(
      String name, String description, int artistId) async {
    Map data = {
      'publicationName': '$name',
      'publicationdescription': '$description',
      'likes': 0,
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "http://192.168.0.102:8080/api/v1/artists/${artistId}/publications"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> uptPost(Post post) async {
    Map data = {
      'publicationName': post.publicationName,
      'publicationdescription': post.publicationDescription,
      'likes': post.likes,
    };
    var body = json.encode(data);
    final response = await http.put(
        Uri.parse("http://192.168.0.102:8080/api/v1/publications/${post.id}"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }
}
