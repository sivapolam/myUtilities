import 'package:flutter/material.dart';

class ChitCalculatorScreen extends StatefulWidget {
  const ChitCalculatorScreen({super.key});
  @override
  _ChitCalculatorScreenState createState() => _ChitCalculatorScreenState();
}

class _ChitCalculatorScreenState extends State<ChitCalculatorScreen> {
  double principalAmount = 0;
  double interestRate = 0;
  int numberOfMonths = 0;
  double monthlyPayment = 0;
  double totalPayout = 0;

  void calculateChit() {
    setState(() {
      monthlyPayment =
          (principalAmount + (principalAmount * interestRate / 100)) /
              numberOfMonths;
      totalPayout = principalAmount + (principalAmount * interestRate / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chit Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Principal Amount',
              ),
              onChanged: (value) {
                principalAmount = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Interest Rate (%)',
              ),
              onChanged: (value) {
                interestRate = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Months',
              ),
              onChanged: (value) {
                numberOfMonths = int.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: calculateChit,
              child: Text('Calculate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Monthly Payment: \$${monthlyPayment.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Payout: \$${totalPayout.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
