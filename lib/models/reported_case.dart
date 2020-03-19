import 'package:equatable/equatable.dart';
import 'package:selftrackingapp/models/location.dart';

class ReportedCase extends Equatable {
  int id;
  String caseNumber;
  List<Location> locations;
  String message;
  DateTime createdAt;

  ReportedCase(
      {this.id, this.caseNumber, this.locations, this.message, this.createdAt});

  factory ReportedCase.fromJson(Map<String, dynamic> json) {
    List<Location> _locations = [];

    // Replace with map
    json['locations']
        .forEach((location) => _locations.add(Location.fromJson(location)));

    return ReportedCase(
        id: int.parse(json['id']),
        caseNumber: json['caseNumber'],
        locations: _locations,
        message: json['message'],
        createdAt: DateTime.parse(json['created']));
  }

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
