import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class RegisterService {
  var log = Logger();
  final storage = new FlutterSecureStorage();

  Future<String> registerFanatic(String email, String passwrod, String Username,
      String realname, String lastname, String fanaticalias) async {
    Map data = {
      'username': Username,
      'realname': realname,
      'lastname': lastname,
      'email': email,
      'password': passwrod,
      'fanaticalias': fanaticalias,
      'role': []
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8081/auth/fanatic"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception("Error");
    }
    String body2 = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body2);

    return jsonData["message"];
  }

  Future<String> registerArtist(String email, String passwrod, String Username,
      String realname, String lastname) async {
    Map data = {
      'username': Username,
      'realname': realname,
      'lastname': lastname,
      'email': email,
      'password': passwrod,
      'roles': []
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8081/auth/artist"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);
    if (response.statusCode != 201) {
      throw Exception("Error");
    }
    String body2 = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body2);
    return jsonData["message"];
  }
}
