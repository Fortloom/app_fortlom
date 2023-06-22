import 'dart:ffi';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FanaticResource{



  final int id;

  final String username;

  final String realname;

  final String lastname;

  final String email;

  final String password;

  final String fanaticalias;


  FanaticResource(this.id, this.username, this.realname, this.lastname, this.email, this.password, this.fanaticalias);



}