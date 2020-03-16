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
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json['address'],
        date: json['date'],
        from: json['from'],
        to: json['to']);
  }
}
