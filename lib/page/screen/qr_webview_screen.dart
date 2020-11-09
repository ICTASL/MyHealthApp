import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_localizations.dart';

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
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            AppLocalizations.of(context).translate("qr_title"),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: WebView(
          initialUrl: widget.url,
          navigationDelegate: (NavigationRequest request) async {
            if (await canLaunch(request.url)) {
              await launch(request.url);
            } else {
              print("Cannot launch url");
            }
            return NavigationDecision.prevent;
          },
          javascriptMode: JavascriptMode.unrestricted,
        ));

    //  WillPopScope(
    //   onWillPop: () => _exitApp(context),
    //   child: Scaffold(
    //     body: WebView(
    //       javascriptMode: JavascriptMode.unrestricted,
    //       initialUrl: widget.url,
    //     ),
    //   ),
    // );
  }

  // Future<bool> _exitApp(BuildContext context) async {
  //   print("cal");
  //   if (await controllerGlobal.canGoBack()) {
  //     print("onwill goback");
  //     controllerGlobal.goBack();
  //   } else {
  //     Scaffold.of(context).showSnackBar(
  //       const SnackBar(content: Text("No back history item")),
  //     );
  //     return Future.value(false);
  //   }
  // }
}
