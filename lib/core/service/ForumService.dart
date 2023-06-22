import 'package:fortloom/domain/entities/CreateForumResource.dart';
import 'package:fortloom/domain/entities/ForumResource.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class ForumService {
  var baseUrl = "http://10.0.2.2:8083/api/v1/forumservice";
  var log = Logger();
  Future<List<ForumResource>> getall() async {
    final response = await http.get(Uri.parse("${baseUrl}/forums"));
    List<ForumResource> forums = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      PersonResource personResource = new PersonResource(
          item["userAccount"]["id"],
          item["userAccount"]["username"],
          item["userAccount"]["realname"],
          item["userAccount"]["lastname"],
          item["userAccount"]["email"],
          item["userAccount"]["password"]);
      ForumResource forumResource = new ForumResource(
          item["id"],
          item["forumname"],
          item["forumdescription"],
          item["forumrules"],
          personResource);

      forums.add(forumResource);
    }

    return forums;
  }

  Future<http.Response> addForum(
      String name, String description, int userID) async {
    Map data = {
      'forumname': '$name',
      'forumdescription': '$description',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("${baseUrl}/user/${userID}/forums"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> update(String forumrules, int forumId) async {
    Map data = {'forumrules': '$forumrules'};

    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("${baseUrl}/chagetules/${forumId}"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
}
