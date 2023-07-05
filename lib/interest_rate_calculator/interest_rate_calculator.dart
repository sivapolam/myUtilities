import 'package:flutter/material.dart';

import '../interest_calculator/text_custom.dart';

class InterestRateCalculatorScreen extends StatefulWidget {
  const InterestRateCalculatorScreen({super.key});

  @override
  _InterestRateCalculatorScreenState createState() =>
      _InterestRateCalculatorScreenState();
}

class _InterestRateCalculatorScreenState
    extends State<InterestRateCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double _principalAmount = 0.0;
  double _monthlyEMI = 0.0;
  double _loanTenure = 0.0;
  double _interestRate = 0.0;
  double _totalInterestPaid = 0.0;
  double _totalAmountPaid = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interest Rate Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Principal Amount'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the principal amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _principalAmount = double.parse(value!);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Monthly EMI'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the monthly EMI';
                  }
                  return null;
                },
                onSaved: (value) {
                  _monthlyEMI = double.parse(value!);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Loan Tenure (in months)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the loan tenure';
                  }
                  return null;
                },
                onSaved: (value) {
                  _loanTenure = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _calculateInterestRate();
                  }
                },
                child: Center(child: Text('Calculate')),
              ),
              SizedBox(height: 16.0),
              Visibility(
                  visible: _interestRate != 0,
                  child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const TextCustom('Total Interest'),
                    SizedBox(height: 4.0),
                    Text(
                      '${_interestRate.toStringAsFixed(2)}%',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    const TextCustom('Total Interest Paid'),
                    SizedBox(height: 4.0),
                    Text(
                      '${_totalInterestPaid.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    const TextCustom('Total Amount Paid'),
                    SizedBox(height: 4.0),
                    Text(
                      '${_totalAmountPaid.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ])))
            ],
          ),
        ),
      ),
    );
  }

  void _calculateInterestRate() {
    final totalAmountPaid = _monthlyEMI * _loanTenure;
    final interest = totalAmountPaid - _principalAmount;
    _interestRate = (interest / _principalAmount) * 100;
    _totalInterestPaid = interest;
    _totalAmountPaid = totalAmountPaid;
    setState(() {});
  }
}
