import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: WebView(
          initialUrl: widget.url,
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    print("cal");
    if (await controllerGlobal.canGoBack()) {
      print("onwill goback");
      controllerGlobal.goBack();
    } else {
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text("No back history item")),
      );
      return Future.value(false);
    }
  }
}
