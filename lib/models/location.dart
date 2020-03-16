class Location {
  double longitude;
  double latitude;
  String address;
  DateTime date, from, to;

  Location({
    this.longitude,
    this.latitude,
    this.address,
    this.date,
    this.from,
    this.to,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        address: json['address'],
        date: DateTime.parse(json['date']),
        from: DateTime.parse(json['from']),
        to: DateTime.parse(json['to']));
  }
}
