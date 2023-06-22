import 'package:fortloom/domain/entities/ForumCommentResource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

import '../../domain/entities/ForumResource.dart';
import '../../domain/entities/PersonResource.dart';

String currentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}

class ForumCommentService {
  var baseUrl = "http://10.0.2.2:8084/api/v1/answerservice";
  var log = Logger();

  Future<List<ForumCommentResource>> getbyForumID(int id) async {
    final response =
        await http.get(Uri.parse(baseUrl + "/forums/${id}/forumcomments"));
    List<ForumCommentResource> comments = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      PersonResource personResource = PersonResource(
          item["userAccount"]["id"],
          item["userAccount"]["username"],
          item["userAccount"]["realname"],
          item["userAccount"]["lastname"],
          item["userAccount"]["email"],
          item["userAccount"]["password"]);
      PersonResource personResource2 =
          PersonResource(0, "null", "null", "null", "null", "null");
      ForumResource forumResource = ForumResource(
          item["forum"]["id"],
          item["forum"]["forumname"],
          item["forum"]["forumdescription"],
          item["forum"]["forumrules"],
          personResource2);

      if (item["registerdate"].runtimeType != Null) {
        print(item["registerdate"].runtimeType);
        DateTime tsdate =
            DateTime.fromMillisecondsSinceEpoch(item["registerdate"]);
        print(tsdate);
        ForumCommentResource forumCommentResource = new ForumCommentResource(
            item["id"],
            item["commentdescription"],
            tsdate,
            item["userid"],
            personResource,
            item["forumid"],
            forumResource);

        comments.add(forumCommentResource);
      } else {
        ForumCommentResource forumCommentResource = new ForumCommentResource(
            item["id"],
            item["commentdescription"],
            item["registerdate"],
            item["userid"],
            personResource,
            item["forumid"],
            forumResource);

        comments.add(forumCommentResource);
      }
    }

    return comments;
  }

  Future<http.Response> addForumComment(
      String commentdescription, int id, int personid) async {
    ;

    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String date = dateFormat.format(DateTime.now());
    print(date);
    Map data = {
      'registerdate': '$date',
      'commentdescription': '$commentdescription',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("${baseUrl}/user/${personid}/forums/${id}/forumcomments"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
}
