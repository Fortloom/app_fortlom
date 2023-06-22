import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ReportService {
  var log = Logger();
  var baseUrl = "http://10.0.2.2:8087/api/v1/reportservice";
  Future<http.Response> createforpublication(int UserMainId, int UserReportedId,
      int publicationId, String description) async {
    Map data = {
      'description': '$description',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "${baseUrl}/usersmains/${UserMainId}/usersreports/${UserReportedId}/publications/${publicationId}/complaints"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> createforcomment(int UserMainId, int UserReportedId,
      int commentId, String description) async {
    Map data = {
      'description': '$description',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "${baseUrl}/usersmains/${UserMainId}/usersreports/${UserReportedId}/comments/${commentId}/complaints"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> createforforum(int UserMainId, int UserReportedId,
      int forumId, String description) async {
    Map data = {
      'description': '$description',
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(
            "${baseUrl}/usersmains/${UserMainId}/usersreports/${UserReportedId}/forums/${forumId}/complaints"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }
}
