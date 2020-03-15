import 'package:selftrackingapp/models/location.dart';

class Case {
  int id;
  Location location;

  Case({this.id, this.location});

  factory Case.fromJson(dynamic json) {
    return Case(id: json['id'], location: Location.fromJson(json['location']));
  }
}
