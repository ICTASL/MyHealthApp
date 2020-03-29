import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/widgets/custom_text.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class CaseDetailScreen extends StatefulWidget {
  @override
  State<CaseDetailScreen> createState() => CaseDetailScreenState();
}

class CaseDetailScreenState extends State<CaseDetailScreen> {
  static const MethodChannel _channel = MethodChannel('location');

  Completer<GoogleMapController> _controller = Completer();

  Position currentLocation;
  List<Location> entries = List();
  List<Marker> hospitalLocations = List();
  Timer _locationTimer;

  Timer _currentLoctimer;
  bool _isInitialLocationAdded = false;

  Future<void> updateLocation() async {
    List<Location> newEntries = await getLocationUpdate();
    print("LOCATIONS Fetched: ${newEntries.length}");
    if (this.mounted) {
      setState(() {
//        entries.clear();
        newEntries.forEach((e) {
          if (!entries.contains(e)) {
            entries.add(e);
            //location id should be used here to prevent duplicate locations from being added
          }
        });
        print("POLLED locations: ${newEntries.length}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateLocation();

    parseJsonFromAssets("assets/hospitals.json").then((data) {
      BitmapDescriptor.fromAssetImage(
              ImageConfiguration(devicePixelRatio: 0.5, size: Size(5, 5)),
              "assets/images/hospital_sign_map.png")
          .then((icon) {
        for (var h in data["hospitals"]) {
          setState(() {
            hospitalLocations.add(Marker(
                icon: icon,
                markerId: MarkerId("${h["id"]}_id"),
                infoWindow: InfoWindow(title: "${h["name"]}"),
                position: LatLng(h["lon"], h["lat"])));
          });
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _channel.invokeMethod('requestLocationPermission').then((res) {
        _channel.invokeMethod('openLocationService').then((res) {});
      });

      _locationTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
        print("POLLING the locations");
        await updateLocation();
      });

      _currentLoctimer = Timer.periodic(Duration(seconds: 2), (_) {
        Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((position) {
          if (this.mounted) {
            setState(() {
              if (!_isInitialLocationAdded) {
                Location location = new Location(
                    longitude: position.longitude,
                    latitude: position.latitude,
                    date: position.timestamp,
                    from: position.timestamp,
                    to: position.timestamp,
                    address: 'Current Location');
                _isInitialLocationAdded = true;
                entries.add(location);
                moveMapToCurrentLoc();
              }
              currentLocation = position;
            });
          }
        });
        print("Current Location Updated");
      });
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  void moveMapToCurrentLoc() async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition _camPos = CameraPosition(
        zoom: 15.0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude));
    controller.animateCamera(CameraUpdate.newCameraPosition(_camPos));
  }

  @override
  void dispose() {
    super.dispose();
    if (_locationTimer != null) _locationTimer.cancel();
    if (_currentLoctimer != null) _currentLoctimer.cancel();
    print("CANCELLING timers");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getMapView(entries), //initially this will be empty
    );
  }

  Widget getMapView(List<Location> entries) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: hospitalLocations.toSet(),
      circles: entries.map((l) {
        return Circle(
            circleId: CircleId("${l.date.millisecondsSinceEpoch}"),
            fillColor: Colors.blue.withOpacity(0.2),
            strokeColor: Colors.blue,
            strokeWidth: 1,
            center: LatLng(l.latitude, l.longitude),
            radius: 150,
            consumeTapEvents: true,
            onTap: () {
              _showDialog(l);
            });
      }).toSet(),
      initialCameraPosition: CameraPosition(
        target: currentLocation != null
            ? LatLng(currentLocation.latitude, currentLocation.longitude)
            : LatLng(6.9271, 79.8612),
        zoom: 12,
      ),
      myLocationButtonEnabled: true,
      trafficEnabled: true,
//      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  void _showDialog(Location location) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new CustomText("Your location"),
          content: new CustomText(
              "You were here at  ${dateFormat.format(location.date)}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new CustomText("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
}
