

import 'dart:ffi';

import 'package:fortloom/domain/entities/ArtistResource.dart';

class PublicationResource{


  final int id;


  final String description;



  final bool image;


  final DateTime? registerdate;



  final int artistid;
  final ArtistResource artist;


  PublicationResource(this.id, this.description, this.image, this.registerdate, this.artistid, this.artist);










}