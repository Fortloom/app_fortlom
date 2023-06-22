import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/CommentResource.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:fortloom/domain/entities/PostResource.dart';
import 'package:fortloom/domain/entities/PublicationCommentResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';
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

class CommentService {
  var baseUrl = "http://10.0.2.2:8084/api/v1/answerservice";
  var log = Logger();

  Future<List<PublicationCommentResource>> getallByPostId(int postId) async {
    final response = await http.get(
        Uri.parse("${baseUrl}/publications/${postId}/publicationcomments"));
    List<PublicationCommentResource> lstComments = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);

    for (var item in jsonData["content"]) {
      if (item["registerdate"].runtimeType != Null) {
        DateTime tsdate =
            DateTime.fromMillisecondsSinceEpoch(item["registerdate"]);
        DateTime tsdate2 = DateTime.fromMillisecondsSinceEpoch(
            item["publication"]["registerdate"]);
        PersonResource personResource = PersonResource(
            item["userAccount"]["id"],
            item["userAccount"]["username"],
            item["userAccount"]["realname"],
            item["userAccount"]["lastname"],
            item["userAccount"]["email"],
            item["userAccount"]["password"]);
        ArtistResource artistResource = ArtistResource(
            0,
            "username",
            "realname",
            "lastname",
            "email",
            "password",
            0,
            "instagramLink",
            "facebookLink",
            "twitterLink",
            "AboutMe");
        PublicationResource publicationResource = PublicationResource(
            item["publication"]["id"],
            item["publication"]["description"],
            item["publication"]["image"],
            tsdate2,
            0,
            artistResource);
        PublicationCommentResource publicationCommentResource =
            PublicationCommentResource(
                item["id"],
                tsdate,
                item["userid"],
                personResource,
                item["commentdescription"],
                item["publicationid"],
                publicationResource);

        lstComments.add(publicationCommentResource);
      } else {
        PersonResource personResource = PersonResource(
            item["userAccount"]["id"],
            item["userAccount"]["username"],
            item["userAccount"]["realname"],
            item["userAccount"]["lastname"],
            item["userAccount"]["email"],
            item["userAccount"]["password"]);
        ArtistResource artistResource = ArtistResource(
            0,
            "username",
            "realname",
            "lastname",
            "email",
            "password",
            0,
            "instagramLink",
            "facebookLink",
            "twitterLink",
            "Aboutme");
        PublicationResource publicationResource = PublicationResource(
            item["publication"]["id"],
            item["publication"]["description"],
            item["publication"]["image"],
            null,
            item["publication"]["artistid"],
            artistResource);
        PublicationCommentResource publicationCommentResource =
            PublicationCommentResource(
                item["id"],
                null,
                0,
                personResource,
                item["commentdescription"],
                item["publicationid"],
                publicationResource);

        lstComments.add(publicationCommentResource);
      }
    }

    return lstComments;
  }

  Future<http.Response> addComment(
      String commentdescription, int publicationId, int userId) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String date = dateFormat.format(DateTime.now());
    Map data = {
      'commentdescription': '$commentdescription',
      'registerdate': '$date',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "${baseUrl}/user/${userId}/publications/${publicationId}/publicationcomments"),
        headers: {"Content-Type": "application/json"},
        body: body);
    return response;
  }

  // Future<http.Response> addPost(
  //     String name, String description, int artistId) async {
  //   Map data = {
  //     'publicationName': '$name',
  //     'publicationdescription': '$description',
  //     'likes': 0,
  //   };
  //   var body = json.encode(data);
  //   final response = await http.post(
  //       Uri.parse(
  //           "http://192.168.0.102:8080/api/v1/artists/${artistId}/publications"),
  //       headers: {"Content-Type": "application/json"},
  //       body: body);
  //   log.i(response.body);
  //   log.i(response.statusCode);

  //   return response;
  // }
}
