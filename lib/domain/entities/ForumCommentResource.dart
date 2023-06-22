import 'dart:ffi';

import 'ForumResource.dart';
import 'PersonResource.dart';

class ForumCommentResource{


  final int id;

  final String commentdescription;

  final DateTime? registerdate;
  final int userid;
  final PersonResource userAccount;
  final int forumid;
  final ForumResource forum;


  ForumCommentResource(this.id, this.commentdescription, this.registerdate, this.userid, this.userAccount, this.forumid, this.forum);



}