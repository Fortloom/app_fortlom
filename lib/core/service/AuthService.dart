import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class AuthService {
  var log = Logger();
  final storage = new FlutterSecureStorage();
  Future<String> Login(String email, String password) async {
    Map data = {'nombreUsuario': '$email', 'password': '$password'};
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse("http://10.0.2.2:8081/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: body);
    log.i(response.body);
    log.i(response.statusCode);
    if (response.statusCode != 200) {
      Fluttertoast.showToast(
          msg: "Usuario o contraseña incorrectos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          fontSize: 16.0

      );
      throw Exception("Error");
    }
    String body2 = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body2);
    StoreToken(jsonData["token"]);
    String token = jsonData["token"];

    print(GetUsername(token));
    return jsonData["token"];
  }

  Future<PersonResource> getperson(String getUsername) async {
    final response = await http.get(Uri.parse(
        "http://10.0.2.2:8081/api/v1/userservice/users/users/Username/" + getUsername));



    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    PersonResource personResource = new PersonResource(
        jsonData["id"],
        jsonData["username"],
        jsonData["realname"],
        jsonData["lastname"],
        jsonData["email"],
        jsonData["password"]);
    return personResource;
  }

  Future<void> StoreToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  String GetUsername(String token) {
    final parts = token.split(".");
    final payload = parts[1];
    String payloadDecoded = base64Url.normalize(payload);
    String prevalues = utf8.decode(base64Url.decode(payloadDecoded));
    final values = jsonDecode(prevalues);
    String username = values["sub"];
    return username;
  }
    bool isfanatic(String token){
    final parts = token.split(".");
    final payload = parts[1];
    String payloadDecoded = base64Url.normalize(payload);
    String prevalues = utf8.decode(base64Url.decode(payloadDecoded));
    final values = jsonDecode(prevalues);
    List<dynamic> roles = values["roles"];
    if (roles.indexOf('Role_Fanatic') < 0) {
      print("artista");
      return false;
    }
    print("fanatico");
    return true;

  }
  bool isartist(String token){
    final parts = token.split(".");
    final payload = parts[1];
    String payloadDecoded = base64Url.normalize(payload);
    String prevalues = utf8.decode(base64Url.decode(payloadDecoded));
    final values = jsonDecode(prevalues);
    List<dynamic> roles = values["roles"];
    if (roles.indexOf('Role_Artist') < 0) {
      //print("artista");
      return false;
    }
    print("artista");
    return true;

  }
  bool isartistupgrade(String token){
    final parts = token.split(".");
    final payload = parts[1];
    String payloadDecoded = base64Url.normalize(payload);
    String prevalues = utf8.decode(base64Url.decode(payloadDecoded));
    final values = jsonDecode(prevalues);
    List<dynamic> roles = values["roles"];
    if (roles.indexOf('Role_Upgrade_Artist') < 0) {
      //print("artista");
      return false;
    }
    print("artista");
    return true;

  }
}
