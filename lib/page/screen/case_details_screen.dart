import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:selftrackingapp/models/location.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CaseDetailScreen extends StatefulWidget {
  @override
  State<CaseDetailScreen> createState() => CaseDetailScreenState();
}

class CaseDetailScreenState extends State<CaseDetailScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text(
        AppLocalizations.of(context).translate('case_details_screen_title'),
      )),
      body: GoogleMap(
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
