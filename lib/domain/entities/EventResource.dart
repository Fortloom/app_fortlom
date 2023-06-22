import 'dart:ffi';

import 'ArtistResource.dart';

class EventResource{

  final int id;
  String name;
  final String description;
  final DateTime registerdate;
  final ArtistResource artist;
  final int artistid;
  final String ticketLink;
  final DateTime? releasedDate;

  EventResource(this.id, this.name, this.description, this.registerdate, this.artist, this.artistid, this.ticketLink, this.releasedDate);
}
