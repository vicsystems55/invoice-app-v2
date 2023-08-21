import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:swiftinvoice2/dashboard.dart';
import 'package:swiftinvoice2/pages/login.dart';

import 'components/invoice_card.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  late Box box;

  bool isLoggedIn = false;

  box = await Hive.openBox('data');

  if (box.get('token') != null) {
    isLoggedIn = true;
    runApp(InvoiceAppz());
    FlutterNativeSplash.remove();
  } else {
    runApp(InvoiceApp());
    FlutterNativeSplash.remove();
  }
}

class InvoiceApp extends StatelessWidget {
  @override

  
  Widget build(BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blueGrey, // Change this color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invoice App',
      theme: ThemeData(
        // textTheme: const TextTheme(
        //   bodyLarge: TextStyle(fontFamily: 'Poppins'),
        //   bodyMedium: TextStyle(fontFamily: 'Poppins'),
        //   bodySmall: TextStyle(fontFamily: 'Poppins'),
        // ),
        fontFamily: 'Outfit',

        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class InvoiceAppz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invoice App',
      theme: ThemeData(
        // textTheme: const TextTheme(
        //   bodyLarge: TextStyle(fontFamily: 'Poppins'),
        //   bodyMedium: TextStyle(fontFamily: 'Poppins'),
        //   bodySmall: TextStyle(fontFamily: 'Poppins'),
        // ),
        fontFamily: 'Outfit',

        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}
