import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:selftrackingapp/app_localizations.dart';
import 'package:selftrackingapp/networking/data_repository.dart';
import 'package:selftrackingapp/networking/db.dart';
import 'package:selftrackingapp/page/screen/welcome_screen.dart';

void main() {
  GetIt.instance
      .registerSingleton<DataRepository>(AppDataRepository(AppDatabase()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19 Tracker',
      theme: ThemeData(
          primarySwatch: Colors.green,
          backgroundColor: Color(0xfff6f6f9),
          textTheme: TextTheme(
            display1: TextStyle(color: Colors.black, fontSize: 15.0),
            display2: TextStyle(color: Colors.black54, fontSize: 12.0),
            body1: TextStyle(color: Colors.black54, fontSize: 15.0),
          )),
      supportedLocales: [Locale('en', "US"), Locale('si', "LK")],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      home: WelcomeScreen(),
    );
  }
}
