import 'package:fortloom/domain/entities/CreateEventResource.dart';
import 'package:fortloom/domain/entities/EventResource.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class EventService {
  var baseUrl = "http://10.0.2.2:8082/api/v1/contentservice";
  var log = Logger();

  Future<List<EventResource>> getallEvents() async {
    final response = await http.get(Uri.parse(baseUrl + "/events"));
    List<EventResource> events = [];

    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    for (var item in jsonData["content"]) {
      ArtistResource artistResource = new ArtistResource(
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

      if (item["releasedDate"].runtimeType != Null) {
        DateTime tsdate =
            DateTime.fromMillisecondsSinceEpoch(item["registerdate"]);
        DateTime tsdate2 =
            DateTime.fromMillisecondsSinceEpoch(item["releasedDate"]);

        EventResource eventResource = new EventResource(
            item["id"],
            item["name"],
            item["description"],
            tsdate,
            artistResource,
            item["artistid"],
            item["ticketLink"],
            tsdate2);

        events.add(eventResource);
      } else {
        DateTime tsdate =
            DateTime.fromMillisecondsSinceEpoch(item["registerdate"]);
        EventResource eventResource = new EventResource(
            item["id"],
            item["name"],
            item["description"],
            tsdate,
            artistResource,
            item["artistid"],
            item["ticketLink"],
            item["releasedDate"]);

        events.add(eventResource);
      }
    }

    return events;
  }

  Future<http.Response> addEvents(String eventName, String eventDescription,
      String ticketLink, String registerDate, int ArtistId) async {
    Map data = {
      'name': '$eventName',
      'description': '$eventDescription',
      'ticketLink': '$ticketLink',
      'releasedDate': '$registerDate'
    };
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(baseUrl + "/artist/" + ArtistId.toString() + "/events"),
        headers: {"Content-Type": "application/json"},
        body: body);

    log.i(response.body);
    log.i(response.statusCode);

    return response;
  }

  Future<http.Response> updateEvents(int EventId, String releasedate) async {
    final response = await http.put(Uri.parse(baseUrl +
        "/eventupdatereleseadedate/" +
        EventId.toString() +
        "/releasedate/" +
        releasedate));
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }
}
