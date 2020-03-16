import 'dart:ffi';

class Location {
  double longitude;
  double latitude;
  String title;
  DateTime recordedAt;

  Location({this.longitude, this.latitude, this.title, this.recordedAt});

  factory Location.fromJson(dynamic json) {
    print("Home");
    print(json[2]);
    return Location(
        latitude: double.parse(json[0]),
        longitude: double.parse(json[1]),
        title: json[3],
        recordedAt:
            DateTime.fromMillisecondsSinceEpoch(int.parse(json[2]) * 1000));
  }
}
