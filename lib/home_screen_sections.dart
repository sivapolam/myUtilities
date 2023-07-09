import 'package:flutter/material.dart';
import 'package:my_utilities/interest_calculator/interest_calculator.dart';
import 'package:my_utilities/interest_rate_calculator/interest_rate_calculator.dart';
import 'package:my_utilities/ui_helper.dart';

import 'compare_loans.dart';
import 'emi_calculator/emi_calculator_advances.dart';
import 'emi_calculator/emicalc.dart';

class HomeScreen extends StatelessWidget {
  final List<Section> sections = [
    Section(
      title: 'EMI Calculator',
      icon: Icons.calculate,
      subItems: [
        SubItem(title: 'EMI Calculator', screen: const EMICalcWidget()),
        SubItem(title: 'Advanced EMI', screen: AdvancesEMICalcWidget()),
        SubItem(title: 'Compare Loans', screen: LoanComparisonScreen()),
      ],
    ),
    Section(
      title: 'Banking Calculator',
      icon: Icons.account_balance,
      subItems: [
        SubItem(title: 'Interest Calculator', screen: InterestCalculator()),
        SubItem(title: 'Savings Calculator', screen: SavingsCalculatorScreen()),
        SubItem(
            title: 'Mortgage Calculator', screen: MortgageCalculatorScreen()),
        SubItem(title: 'FD Calculator', screen: SavingsCalculatorScreen()),
        SubItem(title: 'RD Calculator', screen: SavingsCalculatorScreen()),
        SubItem(title: 'PPF Calculator', screen: SavingsCalculatorScreen()),
      ],
    ),
    Section(
      title: 'Loan Calculator',
      icon: Icons.monetization_on,
      subItems: [
        SubItem(
            title: 'Loan Amount Calculator',
            screen: SimpleLoanCalculatorScreen()),
        SubItem(
            title: 'Loan Tenure Calculator',
            screen: AdvancedLoanCalculatorScreen()),
        SubItem(
            title: 'Interest Rate Calculator',
            screen: const InterestRateCalculatorScreen()),
      ],
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Calc'),
      ),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(section.icon),
                title: Text(section.title,
                    style: UiHelper.getTextStyle(color: Colors.orange)),
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                children: sections[index]
                    .subItems
                    .map((subItem) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GridItem(
                            title: subItem.title,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => subItem.screen,
                                ),
                              );
                            },
                          ),
                        ))
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Section {
  final String title;
  final IconData icon;
  final List<SubItem> subItems;

  Section({required this.title, required this.icon, required this.subItems});
}

class SubItem {
  final String title;
  final Widget screen;

  SubItem({required this.title, required this.screen});
}

class GridItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const GridItem({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2.0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calculate, size: 36.0, color: Colors.black),
              SizedBox(height: 8.0),
              Text(
                title,
                style: UiHelper.getTextStyle(font: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleEMICalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple EMI Calculator'),
      ),
      body: Center(
        child: Text('Simple EMI Calculator Screen'),
      ),
    );
  }
}

class AdvancedEMICalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced EMI Calculator'),
      ),
      body: Center(
        child: Text('Advanced EMI Calculator Screen'),
      ),
    );
  }
}

class EMICalculatorHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EMI Calculator History'),
      ),
      body: Center(
        child: Text('EMI Calculator History Screen'),
      ),
    );
  }
}

class SimpleLoanCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Loan Calculator'),
      ),
      body: Center(
        child: Text('Simple Loan Calculator Screen'),
      ),
    );
  }
}

class AdvancedLoanCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Loan Calculator'),
      ),
      body: Center(
        child: Text('Advanced Loan Calculator Screen'),
      ),
    );
  }
}

class SavingsCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings Calculator'),
      ),
      body: Center(
        child: Text('Savings Calculator Screen'),
      ),
    );
  }
}

class MortgageCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mortgage Calculator'),
      ),
      body: Center(
        child: Text('Mortgage Calculator Screen'),
      ),
    );
  }
}
