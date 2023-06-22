

import 'dart:ffi';

import 'package:fortloom/domain/entities/ArtistResource.dart';

class TagResource{

  final int id;

  final String name;

  final ArtistResource artist;

  TagResource(this.id, this.name, this.artist);


}