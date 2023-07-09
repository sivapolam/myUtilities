import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils.dart';
import './chart.dart';

class OutputWidget extends StatelessWidget {
  late Map<String, double> dataMap;
  late String loanEMI;
  late String interestPayable;
  late String totalPayment;
  late String subText;
  late String firstHeader;

  OutputWidget(Map<String, double> dataMap, double loanEMI,
      double interestPayable, double totalPayment,
      {String subText = "", String firstHeader = ""}) {
    this.dataMap = dataMap;
    this.loanEMI = loanEMI.toStringAsFixed(2);
    this.interestPayable = interestPayable.toStringAsFixed(2);
    this.totalPayment = totalPayment.toStringAsFixed(2);
    this.subText = subText;
    this.firstHeader = firstHeader;
  }

  _getResultBox(Size deviceSize,
      {required String heading, required String value, String subText = ""}) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        height: 90,
        width: deviceSize.width / 2 - 20,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              heading,
              style: _getStyle(size: 18, color: Colors.purple),
            ),
            Visibility(
              visible: subText.isNotEmpty,
              child: Text(
                subText,
                style: _getStyle(size: 10, color: Colors.blueGrey),
              ),
            ),
            Text(
              getFormattedNumber(double.parse(value)),
              style: _getStyle(size: 18, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  _getStyle(
      {required double size,
      required Color color,
      FontWeight = FontWeight.bold}) {
    return GoogleFonts.oswald(
        fontSize: size, fontWeight: FontWeight, color: color);
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getResultBox(deviceSize,
                heading: firstHeader.isNotEmpty ? firstHeader : 'Loan EMI',
                value: loanEMI),
            _getResultBox(deviceSize,
                heading: 'Interest Payable', value: interestPayable),
            _getResultBox(deviceSize,
                heading: 'Total Payable Amount',
                value: totalPayment,
                subText: subText),
          ],
        ),
        Visibility(
          visible: dataMap.isNotEmpty,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Break-up for total Payment',
                  style: _getStyle(
                      size: 15,
                      color: Colors.black,
                      FontWeight: FontWeight.bold)),
              Piechart(dataMap)
            ],
          ),
        )
      ],
    );
  }
}
