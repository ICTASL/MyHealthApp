import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:selftrackingapp/models/reported_case.dart';

class CaseDetailScreen extends StatefulWidget {
  final ReportedCase reportedCase;

  const CaseDetailScreen({Key key, this.reportedCase}) : super(key: key);

  @override
  State<CaseDetailScreen> createState() => CaseDetailScreenState();
}

class CaseDetailScreenState extends State<CaseDetailScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<MarkerId, Marker> _markers = Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final MarkerId markerId = MarkerId((_markers.length + 1).toString());

    widget.reportedCase.locations.forEach((location) {
      Marker newMarker = Marker(
          infoWindow: InfoWindow(title: location.address),
          markerId: markerId,
          position: LatLng(location.longitude, location.latitude));
      _markers[markerId] = newMarker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.of(context).translate('case_details_screen_title'),
      )),
      body: GoogleMap(
        markers: Set<Marker>.of(_markers.values),
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(6.9271, 79.8612),
          zoom: 10,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
