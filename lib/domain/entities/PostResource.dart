import 'package:fortloom/domain/entities/ArtistResource.dart';

class Post {
  final int id;
  final String publicationName;
  final String publicationDescription;
  int likes;
  final dynamic date;
  final ArtistResource artist;
  Post(this.id, this.publicationName, this.publicationDescription, this.likes,
      this.date, this.artist);
}
