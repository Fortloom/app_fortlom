import 'dart:ffi';

import 'package:fortloom/domain/entities/PersonResource.dart';

class ComplaintResource{

  final int id;

  final String description;

  final int userMain;

  final int userReported;


  final int publicationId;

  final int forumId;

  final int commentId;

  final PersonResource userAccountMain;

  final PersonResource userAccountReported;

  ComplaintResource(this.id, this.description, this.userMain, this.userReported, this.publicationId, this.forumId, this.commentId, this.userAccountMain, this.userAccountReported);




}