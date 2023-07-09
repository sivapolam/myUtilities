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

class AdvancesEMICalcWidget extends StatefulWidget {
  const AdvancesEMICalcWidget({super.key});

  @override
  _EMICalcWidgetState createState() => _EMICalcWidgetState();
}

class _EMICalcWidgetState extends State<AdvancesEMICalcWidget> {
  TextEditingController tcAmount = TextEditingController();
  TextEditingController tcROI = TextEditingController();
  TextEditingController tcTenure = TextEditingController();
  TextEditingController tcGST = TextEditingController();
  TextEditingController tcFee = TextEditingController();
  late double loanEMI = 0.0;
  late double _years = 0.0;
  late double interestPayable = 0.0;
  late double totalPayment = 0.0;
  double gstOnInterest = 0.0;
  double gstOnProcessingFee = 0.0;
  double processingFee = 0.0;

  late Map<String, double> dataMap = {};

  bool _isReducedRate = false;
  List interestType = ['Reduced', 'Flat'];
  String _interestType = "Reduced";

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

  _calEMI({
    required principalAmount,
    required roi,
    required years,
    double processingRate = 0.0,
    double gstRate = 0.0,
    bool isReducedInterest = true,
    bool isEMIInArrears = true,
  }) {
    if (kDebugMode) {
      print(
          '==> inside the cal emi method .... ${principalAmount.runtimeType} , ${roi.runtimeType} ');
    }
    reset();
    if (principalAmount == 0 || roi == 0 || years == 0) {
      return;
    }

    double loanAmount = principalAmount;

    double n = years * 12;
    double r = roi / 12 / 100;
    if (isReducedInterest) {
      loanEMI = (principalAmount * r * pow((1 + r), n) / (pow((1 + r), n) - 1));
    } else {
      loanEMI = (principalAmount + (principalAmount * roi * years) / 100) / n;
    }

    totalPayment = loanEMI * 12 * years;
    interestPayable = totalPayment - principalAmount;

    // Apply processing fee if applicable
    if (processingRate > 0) {
      processingFee = (processingRate / 100) * principalAmount;
      gstOnProcessingFee = (18 / 100) * processingFee;
      print("gstRate: $gstRate");
      print("Processing Fee: $processingFee");
      print("GST on Processing Fee: $gstOnProcessingFee");
      loanAmount = loanAmount + processingFee + gstOnProcessingFee;
      // loanAmount = loanAmount + processingFee;
    }

    totalPayment = loanAmount + interestPayable;

    // Apply GST on interest if applicable
    if (gstRate > 0) {
      gstOnInterest = (gstRate / 100) * interestPayable;
      totalPayment += gstOnInterest;
      print("gstOnInterest Fee: $gstOnInterest");
    }

    dataMap = {
      "Principal Loan Amount": principalAmount,
      "Total Interest": interestPayable,
    };
  }

  void reset() {
    gstOnInterest = 0.0;
    gstOnProcessingFee = 0.0;
    processingFee = 0.0;
    totalPayment = 0.0;
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
                  roiTextBox(),
                  UiHelper.getSizeBox(),
                  MySlider(_setSliderValue, _years),
                  // TextBox('Enter Tenure', 'Years', tcTenure, Icons.percent),
                  UiHelper.getSizeBox(),
                  TextBox('Processing Fee (Optional)', 'Enter Percentage',
                      tcFee, Icons.percent),
                  UiHelper.getSizeBox(),
                  TextBox('Enter GST (Optional)', 'Enter Percentage', tcGST,
                      Icons.percent),
                  UiHelper.getSizeBox(),

                  ElevatedButton(
                    style: UiHelper.getButtonStyle,
                    onPressed: () {
                      setState(() {
                        _calEMI(
                            principalAmount: double.parse(
                                tcAmount.text.isNotEmpty
                                    ? tcAmount.text.replaceAll(",", "")
                                    : "0"),
                            roi: double.parse(tcROI.text.isNotEmpty
                                ? tcROI.text.replaceAll(",", "")
                                : "0"),
                            // years: double.parse(tcTenure.text.isNotEmpty ? tcTenure.text : "0"),
                            years: _years,
                            processingRate: double.parse(tcFee.text.isNotEmpty
                                ? tcFee.text.replaceAll(",", "")
                                : "0"),
                            gstRate: double.parse(tcGST.text.isNotEmpty
                                ? tcGST.text.replaceAll(",", "")
                                : "0"),
                            isReducedInterest: !_isReducedRate);
                      });
                    },
                    child: Text('calculate'.toUpperCase()),
                  ),
                  UiHelper.getSizeBox(),
                  Visibility(
                      visible: totalPayment != 0,
                      child: OutputWidget(
                        dataMap,
                        loanEMI,
                        interestPayable,
                        totalPayment,
                        subText:
                            "Interest + GST(${(gstOnInterest + gstOnProcessingFee).toStringAsFixed(0)}) + Processing(${processingFee.toStringAsFixed(0)})",
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  Stack roiTextBox() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextBox('Enter ROI ', 'Enter Percentage', tcROI, Icons.percent),
        Positioned(
          right: 12.0,
          child: Row(
            children: [
              Text("Reduced"),
              Switch(
                value: _isReducedRate,
                onChanged: (value) {
                  _isReducedRate = value;
                  setState(() {});
                  // switchFunction!(value);
                },
              ),
              Text("Flat"),
            ],
          ),
        ),
      ],
    );

    // box.setFunction(_setInterestTypeValue);
    // return box;
  }

  _setInterestTypeValue(bool isReducedRate) {
    _isReducedRate = isReducedRate;
    setState(() {});
  }
}
