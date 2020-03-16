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
    List<Location> _locations =
        json['locations'].map((location) => Location.fromJson(location));

    return ReportedCase(
        id: json['id'],
        caseNumber: json['caseNumber'],
        locations: _locations,
        message: json['message'],
        createdAt: json['created']);
  }
}
