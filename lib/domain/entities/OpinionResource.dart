import 'dart:ffi';

class OpinionResource{

  final int id;

  final DateTime? registerdate;

  final int userid;

  final bool agree;

  final int contentid;


  OpinionResource(this.id, this.registerdate, this.userid, this.agree, this.contentid);

}