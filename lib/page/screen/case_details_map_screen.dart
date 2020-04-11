import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/models/reported_case.dart';
import 'package:selftrackingapp/networking/api_client.dart';
import 'package:selftrackingapp/widgets/case_item_map_detail.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class CaseListMapDetailScreen extends StatefulWidget {
  const CaseListMapDetailScreen({Key key}) : super(key: key);

  @override
  _CaseListMapDetailScreenState createState() =>
      _CaseListMapDetailScreenState();
}

class _CaseListMapDetailScreenState extends State<CaseListMapDetailScreen> {
  static const MethodChannel _channel = MethodChannel('location');
  ReportedCase selectedCase;

  Completer<GoogleMapController> _controller = Completer();
  Position _currentLocation;
  double pinPillPosition = -1000;

  List<Marker> locationMarkers = [];

  Future<void> _fetchCases(BitmapDescriptor mapIcon) async {
    List<ReportedCase> _cases = [];
    int id = await ApiClient().getLastCaseId();
    if (id == -1) {
      return _cases;
    }
    for (int i = id; i > 0; i--) {
      ReportedCase reportedCase =
          await ApiClient().getCase(i, forceUpdate: false);
      if (reportedCase != null && reportedCase.locations != null) {
        Location l = reportedCase.locations[0];
        setState(() {
          locationMarkers.add(
            Marker(
                icon: mapIcon,
                alpha: 0.5,
                markerId: MarkerId("${l.date.millisecondsSinceEpoch}"),
                position: LatLng(l.latitude, l.longitude),
                onTap: () {
                  setState(() {
                    selectedCase = reportedCase;
                    pinPillPosition = MediaQuery.of(context).size.height / 10;
                  });
                }),
          );
        });
      }
    }
    print("Cases found Retreived: ${_cases.length}");
  }

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.1, size: Size(0.5, 0.5)),
            "assets/images/user_icon.png")
        .then((userIcon) {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 0.1, size: Size(0.5, 0.5)),
              "assets/images/suspected_icon.png")
          .then((suspectIcon) {
        _fetchCases(suspectIcon);
//        getLocationUpdate().then((List<Location> locations) {
//
//        });
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
      child: getMapView(), //initially this will be empty
    );
  }

  Widget getMapView() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.terrain,
            markers: getMapEntries(),
            initialCameraPosition: CameraPosition(
              target: _currentLocation != null
                  ? LatLng(
                      _currentLocation.latitude, _currentLocation.longitude)
                  : LatLng(6.9271, 79.8612),
              zoom: 12,
            ),
            mapToolbarEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -MediaQuery.of(context).size.height;
              });
            },
          ),
          AnimatedPositioned(
            bottom: pinPillPosition,
            right: 0,
            left: 0,
            duration: Duration(milliseconds: 300),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width * 7 / 8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            blurRadius: 20,
                            offset: Offset.zero,
                            color: Colors.grey.withOpacity(0.5))
                      ]),
                  child: selectedCase != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CaseItemMapInfo(selectedCase, () {
                            print("Click Card");
                            setState(() {
                              pinPillPosition =
                                  -MediaQuery.of(context).size.height;
                            });
                          }),
                        )
                      : Container(),
                )),
          )
        ],
      ),
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
