import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/widgets/case_item.dart';
import 'package:selftrackingapp/widgets/custom_text.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class SelectedCaseDetailScreen extends StatefulWidget {
  final ReportedCase reportedCase;

  const SelectedCaseDetailScreen({Key key, this.reportedCase})
      : super(key: key);

  @override
  _SelectedCaseDetailScreenState createState() =>
      _SelectedCaseDetailScreenState();
}

class _SelectedCaseDetailScreenState extends State<SelectedCaseDetailScreen> {
  static const MethodChannel _channel = MethodChannel('location');

  Completer<GoogleMapController> _controller = Completer();
  Position currentLocation;

  List<Marker> locationMarkers = [];

  @override
  void initState() {
    super.initState();

//    http://localhost:8000/application/dhis/patients

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.1, size: Size(0.5, 0.5)),
            "assets/images/user_icon.png")
        .then((userIcon) {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 0.1, size: Size(0.5, 0.5)),
              "assets/images/suspected_icon.png")
          .then((suspectIcon) {
        getLocationUpdate().then((List<Location> locations) {
          setState(() {
            locationMarkers = widget.reportedCase.locations.map((l) {
              return Marker(
                  icon: suspectIcon,
                  alpha: 0.5,
                  infoWindow: InfoWindow(
                      title:
                          "Suspected person is at ${dateFormat.format(l.date)}",
                      snippet: ""),
                  markerId: MarkerId("${l.date.millisecondsSinceEpoch}"),
                  position: LatLng(l.latitude, l.longitude));
            }).toList();

//            locationMarkers.addAll(locations.map((l) {
//              return Marker(
//                  icon: userIcon,
//                  alpha: 0.5,
//                  infoWindow: InfoWindow(
//                      title: "You where there at ${dateFormat.format(l.date)}",
//                      snippet: ""),
//                  markerId: MarkerId("${l.date.millisecondsSinceEpoch}"),
//                  position: LatLng(l.latitude, l.longitude));
//            }).toList(growable: false));
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
//    if (_locationTimer != null) _locationTimer.cancel();
//    if (_currentLoctimer != null) _currentLoctimer.cancel();
    print("CANCELLING timers");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getMapView(
          widget.reportedCase.locations), //initially this will be empty
    );
  }

  Widget getMapView(List<Location> entries) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: CustomText("${widget.reportedCase.caseNumber}",
            style: TextStyle(color: Colors.black)),
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        markers: getMapEntries(),
        circles: widget.reportedCase.locations.map((l) {
          return Circle(
              circleId: CircleId("${l.date.millisecondsSinceEpoch}"),
              center: LatLng(l.latitude, l.longitude),
              radius: 50,
              fillColor: Colors.red.withOpacity(0.5),
              strokeColor: Colors.transparent,
              strokeWidth: 0);
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
      ),
    );
  }

  Widget getListView(List<Location> entries) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomText(
              'Entry ${entries[index].longitude},${entries[index].latitude},${entries[index].date}');
        });
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

  getMapEntries() {
    return locationMarkers.toSet();
  }
}
