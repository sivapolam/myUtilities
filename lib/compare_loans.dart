import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_utilities/ui_helper.dart';
import '../widgets/textbox.dart';
import '../widgets/chart.dart';
import '../widgets/output.dart';
import '../widgets/slider.dart';

class LoanComparisonScreen extends StatefulWidget {
  const LoanComparisonScreen({super.key});

  @override
  _LoanComparisonScreen createState() => _LoanComparisonScreen();
}

class _LoanComparisonScreen extends State<LoanComparisonScreen> {
  final Loan loan1 = Loan();
  final Loan loan2 = Loan();

  TextEditingController tcAmount1 = TextEditingController();
  TextEditingController tcROI1 = TextEditingController();

  TextEditingController tcAmount2 = TextEditingController();
  TextEditingController tcROI2 = TextEditingController();

  late double loanEMI = 0.0;
  late double interestPayable = 0.0;
  late double totalPayment = 0.0;

  @override
  void initState() {
    super.initState();
    loanEMI = 0;
  }

  _setSlider1Value(double years) {
    loan1.term = years;
    setState(() {});
  }

  _setSlider2Value(double years) {
    loan2.term = years;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Loan Comparison', style: UiHelper.getTextStyle()),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Loan 1",
                        style: UiHelper.getTextStyle(color: Colors.black),
                      ),
                      UiHelper.getSizeBox(width: 5),
                      Text(
                        "Loan 2",
                        style: UiHelper.getTextStyle(color: Colors.black),
                      )
                    ],
                  ),
                  UiHelper.getSizeBox(),
                  Row(
                    children: [
                      Expanded(
                        child: TextBox('Loan 1 Amount', 'Enter Amount',
                            tcAmount1, Icons.currency_rupee),
                      ),
                      UiHelper.getSizeBox(width: 5),
                      Expanded(
                        child: TextBox('Loan 2 Amount', 'Enter Amount',
                            tcAmount2, Icons.currency_rupee),
                      ),
                    ],
                  ),
                  UiHelper.getSizeBox(),
                  Row(
                    children: [
                      Expanded(
                          child: TextBox('ROI', 'Enter Percentage', tcROI1,
                              Icons.percent)),
                      UiHelper.getSizeBox(width: 5),
                      Expanded(
                          child: TextBox('ROI', 'Enter Percentage', tcROI2,
                              Icons.percent)),
                    ],
                  ),
                  UiHelper.getSizeBox(),
                  Row(
                    children: [
                      Expanded(child: MySlider(_setSlider1Value, loan1.term)),
                      UiHelper.getSizeBox(width: 5),
                      Expanded(child: MySlider(_setSlider2Value, loan2.term)),
                    ],
                  ),
                  UiHelper.getSizeBox(),
                  ElevatedButton(
                    style: UiHelper.getButtonStyle,
                    onPressed: () {
                      setState(() {
                        loan1.calculateLoan(
                            double.parse(tcAmount1.text.isNotEmpty
                                ? tcAmount1.text.replaceAll(",", "")
                                : "0"),
                            double.parse(tcROI1.text.isNotEmpty
                                ? tcROI1.text.replaceAll(",", "")
                                : "0"));

                        loan2.calculateLoan(
                            double.parse(tcAmount2.text.isNotEmpty
                                ? tcAmount2.text.replaceAll(",", "")
                                : "0"),
                            double.parse(tcROI2.text.isNotEmpty
                                ? tcROI2.text.replaceAll(",", "")
                                : "0"));
                      });
                    },
                    child: Text('calculate'.toUpperCase()),
                  ),
                  UiHelper.getSizeBox(),
                  Row(
                    children: [
                      Visibility(
                          visible: loan1.totalAmount != 0,
                          child: Expanded(
                            child: OutputWidget({}, loan1.emi,
                                loan1.interestAmount, loan1.totalAmount),
                          )),
                      UiHelper.getSizeBox(width: 5),
                      Visibility(
                          visible: loan2.totalAmount != 0,
                          child: Expanded(
                            child: OutputWidget({}, loan2.emi,
                                loan2.interestAmount, loan2.totalAmount),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class Loan {
  double amount;
  double interestRate;
  double term;

  double emi = 0.0;
  double interestAmount = 0.0;
  double totalAmount = 0.0;

  Loan({
    this.amount = 0.0,
    this.interestRate = 0.0,
    this.term = 0.0,
  });

  void calculateMonthlyPayment() {
    double monthlyInterestRate = interestRate / 12 / 100;
    double totalPayments = term * 12;

    emi = (amount *
            monthlyInterestRate *
            pow(1 + monthlyInterestRate, totalPayments)) /
        (pow(1 + monthlyInterestRate, totalPayments) - 1);
  }

  void calculateTotalPayment() {
    totalAmount = emi * term * 12;
  }

  void calculateTotalInterest() {
    interestAmount = totalAmount - amount;
  }

  void calculateLoan(double amountInput, double interestRateInput) {
    this.amount = amountInput;
    this.interestRate = interestRateInput;

    calculateMonthlyPayment();
    calculateTotalPayment();
    calculateTotalInterest();
  }
}
