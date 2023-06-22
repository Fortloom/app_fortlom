 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProfileService {

  var baseUrl = 'http://10.0.2.2:8081/api/v1/userservice';
  var log=Logger();
  Future<http.Response> editProfile(int id, String realnameController,
      String lastnameController, String emailController) async {

    print(id);
    print(realnameController);
    print(lastnameController);
    print(emailController);


    Map data = {
      'realname': '$realnameController',
      'lastname': '$lastnameController',
      'email': '$emailController',


    };
    var body = json.encode(data);
    var idString = id.toString();
    final response = await http.put(Uri.parse("${baseUrl}/users/changeprofile/$idString"),

        headers: {"Content-Type": "application/json"}, body: body
    );

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> editPassword(int id, String passwordController) async {
    Map data = {

      'password': '$passwordController',

    };

    var body = json.encode(data);
    var idString = id.toString();
    final response= await http.put(Uri.parse("${baseUrl}/users/changepassword/$idString"),

        headers: {"Content-Type": "application/json"}, body: body
    );

    log.i(response.body);
    log.i(response.statusCode);
    return response;








  }
}
