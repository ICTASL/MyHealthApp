import 'package:selftrackingapp/models/location.dart';

class ReportedCase {
  int id;
  String caseNumber;
  List<Location> locations;
  String message;
  DateTime createdAt;

  ReportedCase(
      {this.id, this.caseNumber, this.locations, this.message, this.createdAt});

  factory ReportedCase.fromJson(Map<String, dynamic> json) {
    List<Location> _locations = List();
    (json['locations'] as List).forEach((e) {
      _locations.add(Location.fromJson(e));
    });

    return ReportedCase(
        id: int.parse(json['id']),
        caseNumber: json['caseNumber'],
        locations: _locations,
        message: json['message'],
        createdAt: DateTime.parse(json['created']));
  }
}
