import 'package:flutter/material.dart';
import 'package:my_utilities/home_page.dart';
import 'home_screen_sections.dart';
import 'interest_calculator/interest_calculator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  initializeAds();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyCalc',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: WillPopScope(
        onWillPop: () async {
          // Handle the back button press here
          // Return true to allow the app to be closed or
          // return false to prevent the app from being closed
          return true;
        },
        child: HomeScreen(),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('te', 'IN'), // Telugu
        Locale('hi', 'IN'), // Hindi
      ],
    );
  }
}

void initializeAds() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final testDeviceIds = ['0B9B8825F61A811CEBD0E664328AE070'];
  final requestConfig = RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(requestConfig);
}
