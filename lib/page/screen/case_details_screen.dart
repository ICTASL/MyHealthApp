import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:selftrackingapp/models/location.dart';

class CaseDetailScreen extends StatefulWidget {
  @override
  State<CaseDetailScreen> createState() => CaseDetailScreenState();
}

class CaseDetailScreenState extends State<CaseDetailScreen> {
  static const MethodChannel _channel = MethodChannel('location');

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: getLocationHistoryView(),
    );
  }

//  GoogleMap(
//  mapType: MapType.terrain,
//  initialCameraPosition: CameraPosition(
//  target: LatLng(6.9271, 79.8612),
//  zoom: 12,
//  ),
//  onMapCreated: (GoogleMapController controller) {
//  _controller.complete(controller);
//  },
//  )

  Widget getLocationHistoryView() {
    return FutureBuilder<List<Location>>(
      future: getLocationUpdate(),
      builder: (BuildContext context, AsyncSnapshot<List<Location>> snapshot) {
        print(snapshot.error);
        if (snapshot.hasError) return Text("${snapshot.error}");
        List<Location> entries = snapshot.data;
        if (entries != null && entries.length > 0) {
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(
                    'Entry ${entries[index].longitude},${entries[index].latitude},${entries[index].date}');
              });
        } else {
          return Text("No data");
        }
      },
    );
  }

  Future<List<Location>> getLocationUpdate() async {
    try {
      final List<dynamic> locations =
          await _channel.invokeMethod('getLocation');
      print("locations $locations");
      return locations
          .map((v) => Location.fromBackgroundJson(json.decode(v)))
          .toList();
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}
