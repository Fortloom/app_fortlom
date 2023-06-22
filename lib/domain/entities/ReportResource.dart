import 'dart:ffi';

import 'package:fortloom/domain/entities/PersonResource.dart';

class ReportResource{

final int id;

final String description;

final int userMain;

final int userReported;
final int publicationId;

final int forumId;

final int commentId;

      ReportResource(this.id, this.description, this.userMain, this.userReported, this.publicationId, this.forumId, this.commentId);


}