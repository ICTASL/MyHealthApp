import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:selftrackingapp/page/screen/qr_webview_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_localizations.dart';

class QrScanScreen extends StatefulWidget {
  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                height: 100,
                width: 100,
                color: Colors.white,
                child: Image.asset(
                  "assets/images/stay_safe.png",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).translate("qr_instruct"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => QrWebviewScreen(url: url)));
  }

  void _onQRViewCreated(QRViewController controller) {
    print("called");
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;

        if (qrText != "") {
          controller.pauseCamera();
          _handleURLButtonPress(context, qrText);
        }
      });
      // controller.resumeCamera();
    });
  }
}
