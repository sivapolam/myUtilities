import 'package:flutter/material.dart';
import 'package:my_utilities/interest_calculator/interest_calculator.dart';
import 'package:my_utilities/interest_rate_calculator/interest_rate_calculator.dart';

import 'chit_calculator/chit_calulator.dart';
import 'emi_calculator/emi_calculator_advances.dart';
import 'emi_calculator/emicalc.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    InterestCalculator(),
    InterestRateCalculatorScreen(),
    EMICalcWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Interest Calc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'ROI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'EMI Calc',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
