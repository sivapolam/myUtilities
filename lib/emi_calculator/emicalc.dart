import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_utilities/ui_helper.dart';
import 'package:pie_chart/pie_chart.dart';
import '../widgets/textbox.dart';
import '../widgets/chart.dart';
import '../widgets/output.dart';
import '../widgets/slider.dart';

class EMICalcWidget extends StatefulWidget {
  const EMICalcWidget({super.key});

  @override
  _EMICalcWidgetState createState() => _EMICalcWidgetState();
}

class _EMICalcWidgetState extends State<EMICalcWidget> {
  TextEditingController tcAmount = TextEditingController();
  TextEditingController tcROI = TextEditingController();
  late double loanEMI = 0.0;
  late double _years = 0.0;
  late double interestPayable = 0.0;
  late double totalPayment = 0.0;
  late Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    _years = 0;
    loanEMI = 0;
  }

  _setSliderValue(double years) {
    _years = years;
    setState(() {});
  }

  _calEMI({required principalAmount, required roi, required years}) {
    if (kDebugMode) {
      print(
          '==> inside the cal emi method .... ${principalAmount.runtimeType} , ${roi.runtimeType} ');
    }

    double n = years * 12;
    double r = roi / 12 / 100;
    loanEMI = (principalAmount * r * pow((1 + r), n) / (pow((1 + r), n) - 1));

    totalPayment = loanEMI * 12 * years;
    interestPayable = totalPayment - principalAmount;

    dataMap = {
      "Principal Loan Amount": principalAmount,
      "Total Interest": interestPayable,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EMI Calculator', style: UiHelper.getTextStyle()),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  UiHelper.getSizeBox(),
                  TextBox('Enter Loan Amount', 'Enter Amount in Rupees',
                      tcAmount, Icons.currency_rupee),
                  UiHelper.getSizeBox(),
                  TextBox(
                      'Enter ROI ', 'Enter Percentage', tcROI, Icons.percent),
                  UiHelper.getSizeBox(),
                  MySlider(_setSliderValue, _years),
                  UiHelper.getSizeBox(),
                  ElevatedButton(
                    style: UiHelper.getButtonStyle,
                    onPressed: () {
                      setState(() {
                        _calEMI(
                            principalAmount:
                                double.parse(tcAmount.text.replaceAll(",", "")),
                            roi: double.parse(tcROI.text.replaceAll(",", "")),
                            years: _years);
                      });
                    },
                    child: Text('calculate'.toUpperCase()),
                  ),
                  UiHelper.getSizeBox(),
                  Visibility(
                      visible: totalPayment != 0,
                      child: OutputWidget(
                          dataMap, loanEMI, interestPayable, totalPayment)),
                ],
              ),
            ),
          ),
        ));
  }
}
