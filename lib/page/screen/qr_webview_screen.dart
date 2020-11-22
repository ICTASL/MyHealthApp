import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:selftrackingapp/main.dart';
import 'package:selftrackingapp/page/screen/privacy_policy_screen.dart';
import 'package:selftrackingapp/page/screen/root_screen.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_localizations.dart';
import 'qr_scan_screen.dart';

class QrWebviewScreen extends StatefulWidget {
  final String url;

  const QrWebviewScreen({Key key, this.url}) : super(key: key);
  @override
  _QrWebviewScreenState createState() => _QrWebviewScreenState();
}

WebViewController controllerGlobal;

class _QrWebviewScreenState extends State<QrWebviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => HomeScreen()));
              }),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            AppLocalizations.of(context).translate("qr_title"),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: WebView(
          initialUrl: widget.url,
          // navigationDelegate: (NavigationRequest request) async {
          //   if (await canLaunch(request.url)) {
          //     await launch(request.url);
          //   } else {
          //     print("Cannot launch url");
          //   }
          //   return NavigationDecision.prevent;
          // },
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}
