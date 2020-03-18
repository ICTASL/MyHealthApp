import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:selftrackingapp/models/location.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class CaseDetailScreen extends StatefulWidget {
  @override
  State<CaseDetailScreen> createState() => CaseDetailScreenState();
}

class CaseDetailScreenState extends State<CaseDetailScreen> {
  static const MethodChannel _channel = MethodChannel('location');

  Completer<GoogleMapController> _controller = Completer();
  Position currentLocation;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: getLocationHistoryView(),
    );
  }

  Widget getMapView(List<Location> entries) {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) {
      setState(() {
        currentLocation = position;
      });
    });

    return GoogleMap(
      mapType: MapType.terrain,
      markers: entries.map((l) {
        return Marker(
            infoWindow: InfoWindow(
                title: "You are at ${dateFormat.format(l.date)}",
                snippet: "No issue found"),
            markerId: MarkerId("${l.date.millisecondsSinceEpoch}"),
            position: LatLng(l.latitude, l.longitude));
      }).toSet(),
      initialCameraPosition: CameraPosition(
        target: currentLocation != null
            ? LatLng(currentLocation.latitude, currentLocation.longitude)
            : LatLng(6.9271, 79.8612),
        zoom: 12,
      ),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Widget getListView(List<Location> entries) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(
              'Entry ${entries[index].longitude},${entries[index].latitude},${entries[index].date}');
        });
  }

  Widget getLocationHistoryView() {
    return FutureBuilder<List<Location>>(
      future: getLocationUpdate(),
      builder: (BuildContext context, AsyncSnapshot<List<Location>> snapshot) {
        print(snapshot.error);
        if (snapshot.hasError) return Text("${snapshot.error}");
        List<Location> entries = snapshot.data;
        if (entries != null && entries.length > 0) {
          return getMapView(entries);
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
