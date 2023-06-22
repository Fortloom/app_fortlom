import 'dart:ffi';

import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/TagResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

//192.168.43.65
//192.168.0.201
class ArtistService {
  var log = Logger();
  var baseUrl = "http://10.0.2.2:8081/api/v1/userservice/artists";

  Future<List<ArtistResource>> getallArtists() async {
    final response = await http.get(Uri.parse(baseUrl));
    List<ArtistResource> artists = [];
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ArtistResource artistResource = ArtistResource(
          item["id"],
          item["username"],
          item["realname"],
          item["lastname"],
          item["email"],
          item["password"],
          item["artistfollowers"],
          item["instagramLink"],
          item["facebookLink"],
          item["twitterLink"],
          item["aboutMe"]);

      artists.add(artistResource);
    }
    return artists;
  }

  Future<ArtistResource> getArtistbyId(int artistId) async {
    final response = await http.get(Uri.parse("$baseUrl/$artistId"));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    ArtistResource artistResource = ArtistResource(
        jsonData["id"],
        jsonData["username"],
        jsonData["realname"],
        jsonData["lastname"],
        jsonData["email"],
        jsonData["password"],
        jsonData["artistfollowers"],
        jsonData["instagramLink"],
        jsonData["facebookLink"],
        jsonData["twitterLink"],
        jsonData["aboutMe"]);
    return artistResource;
  }

  Future<ArtistResource> getArtistbyartistname(String artistname) async {
    final response = await http.get(Uri.parse("$baseUrl/username/$artistname"));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    ArtistResource artistResource = ArtistResource(
        jsonData["id"],
        jsonData["username"],
        jsonData["realname"],
        jsonData["lastname"],
        jsonData["email"],
        jsonData["password"],
        jsonData["artistfollowers"],
        jsonData["instagramLink"],
        jsonData["facebookLink"],
        jsonData["twitterLink"],
        jsonData["aboutMe"]);
    return artistResource;
  }

  Future<ArtistResource> getArtistbynameandLastname(
      String name, String lastname) async {
    final response =
        await http.get(Uri.parse("$baseUrl/name/$name/lastname/$lastname"));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    ArtistResource artistResource = ArtistResource(
        jsonData["id"],
        jsonData["username"],
        jsonData["realname"],
        jsonData["lastname"],
        jsonData["email"],
        jsonData["password"],
        jsonData["artistfollowers"],
        jsonData["instagramLink"],
        jsonData["facebookLink"],
        jsonData["twitterLink"],
        jsonData["aboutMe"]);
    return artistResource;
  }

  Future<http.Response> createTag(String name, int artistId) async {
    Map data = {'name': name};
    var body = json.encode(data);

    final response = await http.post(
        Uri.parse("$baseUrl/artist/$artistId/newtag"),
        headers: {"Content-Type": "application/json"},
        body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<List<TagResource>> GetTags(int artistId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/artist/$artistId/tags/"));
    log.i(response.body);
    log.i(response.statusCode);
    List<TagResource> tags = [];
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ArtistResource artistResource = ArtistResource(
          item["artist"]["id"],
          item["artist"]["username"],
          item["artist"]["realname"],
          item["artist"]["lastname"],
          item["artist"]["email"],
          item["artist"]["password"],
          item["artist"]["artistfollowers"],
          item["artist"]["instagramLink"],
          item["artist"]["facebookLink"],
          item["artist"]["twitterLink"],
          item["aboutMe"]);
      TagResource tagResource =
          TagResource(item["id"], item["name"], artistResource);
      tags.add(tagResource);
    }
    return tags;
  }

  Future<http.Response> updateTwitterAccount(
      int artistId, String TwitterAccount) async {
    Map data = {'twitterLink': TwitterAccount};
    var body = json.encode(data);
    final response = await http.put(
        Uri.parse("$baseUrl/artist/$artistId/TwitterAccount"),
        headers: {"Content-Type": "application/json"},
        body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> updateFacebookAccount(
      int artistId, String FacebookAccount) async {
    Map data = {'facebookLink': FacebookAccount};
    var body = json.encode(data);
    final response = await http.put(
        Uri.parse("$baseUrl/artist/$artistId/FacebookAccount"),
        headers: {"Content-Type": "application/json"},
        body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> updateInstagramAccount(
      int artistId, String InstagramAccount) async {
    Map data = {'instagramLink': InstagramAccount};
    var body = json.encode(data);
    final response = await http.put(
        Uri.parse("$baseUrl/artist/$artistId/InstagramAccount"),
        headers: {"Content-Type": "application/json"},
        body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> updateArtistPremium(int artistId) async {
    final response = await http.put(Uri.parse("$baseUrl/upgrade/$artistId"));
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }

  Future<bool> checkremiumartistid(int artistId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/checkpremium/$artistId"));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);

    return body == "true" ? true : false;
  }

  Future<bool> existartistId(int artistId) async {
    final response = await http.get(Uri.parse("$baseUrl/check/$artistId"));
    log.i(response.body);
    log.i(response.statusCode);
    String body = utf8.decode(response.bodyBytes);

    return body == "true" ? true : false;
  }

  Future<http.Response> updateArtist(int artistfollowers, int artistId) async {
    Map data = {'artistfollowers': '$artistfollowers'};
    var body = json.encode(data);
    final response = await http.put(Uri.parse("$baseUrl/artists/$artistId"),
        headers: {"Content-Type": "application/json"}, body: body);
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }
}
