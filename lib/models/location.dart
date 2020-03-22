import 'package:equatable/equatable.dart';

class Location extends Equatable {
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
        latitude: json["latitude"] == "" ? 0 : double.parse(json['latitude']),
        longitude:
            json["longitude"] == "" ? 0 : double.parse(json['longitude']),
        address: json['area'],
        date: DateTime.parse(json['date']),
        from: DateTime.now(),
        to: DateTime.now());
  }

  factory Location.fromBackgroundJson(Map<String, dynamic> json) {
    return Location(
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json['address'],
        date: DateTime.fromMillisecondsSinceEpoch(json['recordedAt']),
        from: json['from'],
        to: json['to']);
  }

  @override
  // TODO: implement props
  List<Object> get props => [date];
}
