import 'package:equatable/equatable.dart';
import 'package:selftrackingapp/models/location.dart';

class ReportedCase extends Equatable {
  int id;
  String caseNumber;
  List<Location> locations;
  String message;
  DateTime createdAt;
  // New properties - need to be added to backend
  bool isLocal = true;
  bool isFromFacility = true;

  ReportedCase(
      {this.id, this.caseNumber, this.locations, this.message, this.createdAt});

  factory ReportedCase.fromJson(Map<String, dynamic> json) {
    List<Location> _locations = [];
    // Replace with map
    json['locations']
        .forEach((location) => _locations.add(Location.fromJson(location)));

    ReportedCase _case = ReportedCase(
        id: int.parse(json['id']),
        caseNumber: json['caseNumber'],
        locations: _locations,
        message: json['message'],
        createdAt: DateTime.parse(json['created']));
    // isLocal
    if (json.containsKey('isLocal')) {
      _case.isLocal = json['isLocal'] as bool;
    }
    // Quarantine/home
    if (json.containsKey('detectedFrom')) {
      var from = json['detectedFrom'] as String;
      _case.isFromFacility = from == 'quarantine';
    }
    // print("CASE HAS BEEN REPORTED: ${_case.id}");
    return _case;
  }

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
