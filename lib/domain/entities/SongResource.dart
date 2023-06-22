import 'package:fortloom/domain/entities/AlbumResource.dart';

class SongResource{

  final int id;

  final String name;


  final String musicUrl;

  final String category;

  final AlbumResource albumResource;

  SongResource(this.id, this.name, this.musicUrl, this.category, this.albumResource);





}