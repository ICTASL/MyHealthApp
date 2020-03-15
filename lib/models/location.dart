class Location {
  double longitude;
  double latitude;
  String title;
  DateTime recordedAt;

  Location({this.longitude, this.latitude, this.title, this.recordedAt});

  factory Location.fromJson(dynamic json) {
    return Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
        title: json['title'],
        recordedAt: json['at']);
  }
}
