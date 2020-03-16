import 'dart:convert';

class Location {
  double longitude;
  double latitude;
  String title;
  DateTime recordedAt;

  Location({this.longitude, this.latitude, this.title, this.recordedAt});

  factory Location.fromJson(dynamic jsonString) {
    var json = jsonDecode(jsonString);
    print(json);

    return Location(
        latitude: json["latitude"],
        longitude: json["longitude"],
        title: "Title",
        recordedAt:
            DateTime.fromMillisecondsSinceEpoch(json["recordedAt"] * 1000));
  }
}
