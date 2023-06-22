import 'dart:ffi';

import 'package:fortloom/domain/entities/PersonResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';

class PublicationCommentResource{


  final int id;

  final DateTime? registerdate;

  final int userid;
  final PersonResource userAccount;
  final String commentdescription;
  final int publicationid;

  final PublicationResource publication;



  PublicationCommentResource(this.id, this.registerdate, this.userid, this.userAccount, this.commentdescription, this.publicationid, this.publication);







}