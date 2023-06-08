import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_utilities/interest_calculator/text_custom.dart';
import 'package:my_utilities/interest_calculator/time_cycle.dart';

import 'interest_type.dart';

class InterestCalculator extends StatefulWidget {
  const InterestCalculator({super.key});

  @override
  _InterestCalculatorState createState() => _InterestCalculatorState();
}

class _InterestCalculatorState extends State<InterestCalculator> {
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  DateTime? givenDate;
  DateTime? returnDate;

  double simpleInterest = 0;
  double compoundInterest = 0;
  double totalAmount = 0;

  InterestType interestType = InterestType.Simple;

  TimeCycle timeCycle = TimeCycle.Annually;
  bool isCalculateEnabled = false;

  void calculateInterest() {
    double principal = double.tryParse(principalController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    if (givenDate != null && returnDate != null) {
      int days = returnDate!.difference(givenDate!).inDays;

      if (interestType == InterestType.Simple) {
        setState(() {
          simpleInterest = (principal * rate * days) / (100 * 365);
          compoundInterest = 0;
          totalAmount = principal + simpleInterest;
        });
      } else {
        double compoundRate = rate / 100;
        int n = 1;

        switch (timeCycle) {
          case TimeCycle.Annually:
            n = 1;
            break;
          case TimeCycle.SemiAnnually:
            n = 2;
            break;
          case TimeCycle.Quarterly:
            n = 4;
            break;
          case TimeCycle.Monthly:
            n = 12;
            break;
          case TimeCycle.OnceIn3Years:
            n = 3;
            break;
        }

        setState(() {
          compoundInterest =
              principal * (pow(1 + compoundRate / n, (n * days / 365))) -
                  principal;
          simpleInterest = 0;
          totalAmount = principal + compoundInterest;
        });
      }
    } else {
      setState(() {
        simpleInterest = 0;
        compoundInterest = 0;
        totalAmount = 0;
      });
    }
  }

  Future<void> selectGivenDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != givenDate) {
      setState(() {
        givenDate = picked;
        isCalculateEnabled = validateFields();
      });
    }
  }

  Future<void> selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != returnDate) {
      setState(() {
        returnDate = picked;
        isCalculateEnabled = validateFields();
      });
    }
  }

  bool validateFields() {
    return principalController.text.isNotEmpty &&
        rateController.text.isNotEmpty &&
        givenDate != null &&
        returnDate != null;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat = NumberFormat('#,##0.00');

    return Scaffold(
      appBar: AppBar(
        title: Text('Interest Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextCustom('Principal Amount'),
            SizedBox(height: 8.0),
            TextFormField(
              controller: principalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Principal Amount',
              ),
              onChanged: (value) {
                setState(() {
                  isCalculateEnabled = validateFields();
                });
              },
            ),
            SizedBox(height: 16.0),
            TextCustom('Rate of Interest'),
            SizedBox(height: 8.0),
            TextFormField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Rate of Interest',
              ),
              onChanged: (value) {
                setState(() {
                  isCalculateEnabled = validateFields();
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextCustom('Given Date'),
                TextButton(
                  onPressed: () => selectGivenDate(context),
                  child: Text(
                    givenDate != null
                        ? dateFormat.format(givenDate!)
                        : 'Select Date',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextCustom('Return Date'),
                TextButton(
                  onPressed: () => selectReturnDate(context),
                  child: Text(
                    returnDate != null
                        ? dateFormat.format(returnDate!)
                        : 'Select Date',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextCustom('Interest Type'),
                DropdownButton<InterestType>(
                  value: interestType,
                  onChanged: (InterestType? newValue) {
                    setState(() {
                      interestType = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem<InterestType>(
                      value: InterestType.Simple,
                      child: Text('Simple Interest'),
                    ),
                    DropdownMenuItem<InterestType>(
                      value: InterestType.Compound,
                      child: Text('Compound Interest'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Visibility(
              visible: interestType == InterestType.Compound,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextCustom('Time Cycle'),
                  DropdownButton<TimeCycle>(
                    value: timeCycle,
                    onChanged: (TimeCycle? newValue) {
                      setState(() {
                        timeCycle = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<TimeCycle>(
                        value: TimeCycle.Annually,
                        child: Text('Annually'),
                      ),
                      DropdownMenuItem<TimeCycle>(
                        value: TimeCycle.SemiAnnually,
                        child: Text('Semi-Annually'),
                      ),
                      DropdownMenuItem<TimeCycle>(
                        value: TimeCycle.Quarterly,
                        child: Text('Quarterly'),
                      ),
                      DropdownMenuItem<TimeCycle>(
                        value: TimeCycle.Monthly,
                        child: Text('Monthly'),
                      ),
                      DropdownMenuItem<TimeCycle>(
                        value: TimeCycle.OnceIn3Years,
                        child: Text('Once in 3 Years'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: isCalculateEnabled ? calculateInterest : null,
                child: Text('Calculate',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Visibility(
              visible: totalAmount != 0 && isCalculateEnabled,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextCustom('Interest Amount'),
                    SizedBox(height: 8.0),
                    Text(
                      interestType == InterestType.Simple
                          ? simpleInterest.toStringAsFixed(2)
                          : compoundInterest.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24.0),
                    TextCustom('Total Amount'),
                    SizedBox(height: 8.0),
                    Text(
                      totalAmount.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
