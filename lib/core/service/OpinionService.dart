import 'dart:ffi';

import 'package:fortloom/domain/entities/OpinionResource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class OpinionService {
  var log = Logger();
  var baseUrl = "http://10.0.2.2:8084/api/v1/answerservice";
  Future<int> getAllOpinionsByagreeandContentId(
      int contenid, bool agree) async {
    final response = await http.get(
        Uri.parse("${baseUrl}/content/${contenid}/agreess/${agree}/opinions"));
    List<OpinionResource> opinions = [];
    log.i(response.body);
    log.i(response.statusCode);
    print("opinion result");
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    print(jsonData["numberOfElements"]);
    return jsonData["numberOfElements"];
  }

  Future<int> getAllOpinionsByuserandcontenid(int userId, int contenid) async {
    final response =
        await http.get(Uri.parse("${baseUrl}/getby/${contenid}/${userId}"));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      print(item["id"]);
      return item["id"];
    }
    return 0;
  }

  Future<bool> existsbyUserandcontenid(int userid, int contentid) async {
    final response =
        await http.get(Uri.parse("${baseUrl}/check/${contentid}/${userid}"));
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    return jsonData;
  }

  Future<http.Response> createOpinion(
      bool agree, int usersId, int contentid) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String date = dateFormat.format(DateTime.now());
    Map data = {'agree': '$agree', 'registerdate': '$date'};
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("${baseUrl}/user/${usersId}/content/${contentid}/opinions"),
        headers: {"Content-Type": "application/json"},
        body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> updateOpinion(int opinionId, bool boolagree) async {
    final response = await http
        .put(Uri.parse("${baseUrl}/update/${opinionId}/agree/${boolagree}"));

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
}
