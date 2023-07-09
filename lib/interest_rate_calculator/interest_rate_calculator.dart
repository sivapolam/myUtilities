import 'package:flutter/material.dart';
import 'package:my_utilities/widgets/textbox.dart';

import '../interest_calculator/text_custom.dart';
import '../ui_helper.dart';
import '../widgets/output.dart';
import '../widgets/slider.dart';

class InterestRateCalculatorScreen extends StatefulWidget {
  const InterestRateCalculatorScreen({super.key});

  @override
  _InterestRateCalculatorScreenState createState() =>
      _InterestRateCalculatorScreenState();
}

class _InterestRateCalculatorScreenState
    extends State<InterestRateCalculatorScreen> {
  TextEditingController tcAmount = TextEditingController();
  TextEditingController tcROI = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  double _principalAmount = 0.0;
  double _monthlyEMI = 0.0;
  double _loanTenure = 0.0;
  double _interestRate = 0.0;
  double _totalInterestPaid = 0.0;
  double _totalAmountPaid = 0.0;
  late Map<String, double> dataMap = {};

  _setSliderValue(double years) {
    _loanTenure = years;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Interest Rate Calculator', style: UiHelper.getTextStyle()),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  UiHelper.getSizeBox(),
                  TextBox(
                      "Enter Loan Amount", "", tcAmount, Icons.currency_rupee),
                  UiHelper.getSizeBox(),
                  TextBox('Enter EMI Amount ', 'Enter Amount', tcROI,
                      Icons.percent),
                  UiHelper.getSizeBox(),
                  MySlider(_setSliderValue, _loanTenure),
                  UiHelper.getSizeBox(),
                  ElevatedButton(
                    style: UiHelper.getButtonStyle,
                    onPressed: () {
                      _monthlyEMI =
                          double.parse(tcROI.text.replaceAll(',', ''));
                      _principalAmount =
                          double.parse(tcAmount.text.replaceAll(',', ''));
                      _calculateInterestRate();
                    },
                    child: Center(child: Text('Calculate'.toUpperCase())),
                  ),
                  SizedBox(height: 16.0),
                  Visibility(
                      visible: _interestRate != 0,
                      child: OutputWidget(
                        dataMap,
                        _interestRate,
                        _totalInterestPaid,
                        _totalAmountPaid,
                        firstHeader: "Interest Rate",
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  void _calculateInterestRate() {
    final totalAmountPaid = _monthlyEMI * _loanTenure * 12;
    final interest = totalAmountPaid - _principalAmount;
    _interestRate = (interest / _principalAmount) * 100;
    _totalInterestPaid = interest;
    _totalAmountPaid = totalAmountPaid;
    print("Interest Rate: $_interestRate");
    dataMap = {
      "Principal Loan Amount": _principalAmount,
      "Total Interest": _totalInterestPaid,
    };

    setState(() {});
  }
}
