import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:my_utilities/ad_helper.dart';
import 'package:my_utilities/interest_calculator/text_custom.dart';
import 'package:my_utilities/interest_calculator/time_cycle.dart';
import 'package:my_utilities/ui_helper.dart';
import 'package:share/share.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  DateTime? returnDate = DateTime.now();

  double simpleInterest = 0;
  double compoundInterest = 0;
  double totalAmount = 0;
  String interestTypeShare = "Simple Interest";

  InterestType interestType = InterestType.Simple;
  TimeCycle timeCycle = TimeCycle.Annually;

  bool isCalculateEnabled = false;
  bool isAmountCalculated = false;

  String selectedLanguage = 'en'; // Default language is English
  List<String> languages = ['English', 'తెలుగు', 'हिन्दी'];
  String differenceFormatted = "";
  late Duration difference;

  double principal = 0.0;
  double rate = 0.0;

  late BannerAd _bannerAd;
  static String get bannerAdUnitId =>
      'ca-app-pub-3940256099942544/6300978111'; // Test Ad Unit ID

  @override
  void initState() {
    initializeAds();
    super.initState();
  }

  void initializeAds() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  void calculateInterest() {
    principal = double.tryParse(principalController.text) ?? 0;
    rate = (double.tryParse(rateController.text) ?? 0) * 12;

    if (givenDate != null && returnDate != null) {
      Duration difference = returnDate!.difference(givenDate!);
      int days = difference.inDays;

      // Calculate the difference between the dates
      int years = returnDate!.year - givenDate!.year;
      int months = returnDate!.month - givenDate!.month;
      int remainingDays = returnDate!.day - givenDate!.day;

      if (remainingDays < 0) {
        months--;
        remainingDays +=
            DateTime(returnDate!.year, returnDate!.month + 1, 0).day;
      }

      if (months < 0) {
        years--;
        months += 12;
      }
      // Calculate total months
      int totalmonths = (years * 12) + months;
      if (interestType == InterestType.Simple) {
        interestTypeShare = "Simple Interest";
        // Calculate total months and remaining days
        double totalMonthInDays = totalmonths + (remainingDays / 30);
        print(totalMonthInDays);

        setState(() {
          simpleInterest = (principal * rate * totalMonthInDays) / (100 * 12);
          compoundInterest = 0;
          totalAmount = principal + simpleInterest;
          isAmountCalculated = true;

          differenceFormatted = '$years year $months month $remainingDays days';
          print(differenceFormatted);
          print(
              'principal: $principal, rate: $rate, totalMonthInDays: $totalMonthInDays, simpleInterest: $simpleInterest');
        });
      } else {
        double compoundRate = rate / 100;
        double n = 1;

        switch (timeCycle) {
          case TimeCycle.Annually:
            interestTypeShare = "Compound Interest (1 Year)";
            n = 1;
            break;
          case TimeCycle.SemiAnnually:
            interestTypeShare = "Compound Interest (6 Months)";
            n = 2;
            break;
          case TimeCycle.Quarterly:
            interestTypeShare = "Compound Interest (3 Months)";
            n = 4;
            break;
          case TimeCycle.Monthly:
            interestTypeShare = "Compound Interest (1 Month)";
            n = 12;
            break;
          // case TimeCycle.OnceIn3Years:
          // n = 3 / 4;
          // break;
        }

        setState(() {
          // compoundInterest = principal * (pow(1 + compoundRate / n, (n * days / 365))) - principal;
          double year = totalmonths / 12;
          print(
              'principal: $principal, rate: $compoundRate, years: $year, months: $months, n: $n');
          totalAmount = principal * pow(1 + (compoundRate / n), year * n);
          log(principal * pow(1 + (compoundRate / n), years * n));
          compoundInterest = totalAmount - principal;

          simpleInterest = 0;
          // totalAmount = principal + compoundInterest;
          isAmountCalculated = true;
          differenceFormatted = '$years year $months month $remainingDays days';
        });
      }

      // Hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      setState(() {
        simpleInterest = 0;
        compoundInterest = 0;
        totalAmount = 0;
      });
    }
  }

  Future<void> selectGivenDate(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        theme: const DatePickerTheme(
          headerColor: Colors.deepPurple,
          backgroundColor: Colors.white,
          itemStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          doneStyle: TextStyle(color: Colors.white, fontSize: 16),
          cancelStyle: TextStyle(color: Colors.red, fontSize: 16),
        ), onConfirm: (date) {
      setState(() {
        givenDate = date;
        isCalculateEnabled = validateFields();
        isAmountCalculated = false;
      });
    }, currentTime: givenDate ?? DateTime.now(), maxTime: DateTime.now());
  }

  Future<void> selectReturnDate(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      theme: const DatePickerTheme(
        headerColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        itemStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        doneStyle: TextStyle(color: Colors.white, fontSize: 16),
        cancelStyle: TextStyle(color: Colors.red, fontSize: 16),
      ),
      onConfirm: (date) {
        setState(() {
          returnDate = date;
          isCalculateEnabled = validateFields();
          isAmountCalculated = false;
        });
      },
      currentTime: returnDate ?? DateTime.now(),
      minTime: givenDate != null ? givenDate! : DateTime(2000),
    );
  }

  bool validateFields() {
    return principalController.text.isNotEmpty &&
        rateController.text.isNotEmpty &&
        givenDate != null &&
        returnDate != null;
  }

  void setLocale(BuildContext context, String languageCode) {
    Locale _temp;
    switch (languageCode) {
      case 'en':
        _temp = Locale(languageCode, 'US');
        break;
      case 'te':
        _temp = Locale(languageCode, 'IN');
        break;
      case 'hi':
        _temp = Locale(languageCode, 'IN');
        break;
      default:
        _temp = Locale('en', 'US');
    }
    _InterestCalculatorState state =
        context.findAncestorStateOfType<_InterestCalculatorState>()!;
    state.changeLanguage(_temp);
  }

  void changeLanguage(Locale locale) {
    setState(() {
      // Implement your logic to change the app's language here
      // You can use packages like 'flutter_localizations' or 'intl' for localization
    });
  }

  void _shareApp() {
    String playStoreLink =
        "https://play.google.com/store/apps/details?id=com.makemobiapps.moneycalc";
    String text = "Checkout this Money Calculator App: \n$playStoreLink";

    if (isAmountCalculated) {
      String principleAmount = 'Principle Amount: $principal';
      String formattedGivenDate = dateFormat.format(givenDate!);
      String formattedReturnDate = dateFormat.format(returnDate!);

      double interestRate = rate / 12;
      String interest = totalInterest();
      String total = totalAmount.toStringAsFixed(2);
      text =
          'Principle Amount: $principal \nGiven Date: $formattedGivenDate\nReturn Date: $formattedReturnDate\nDuration: $differenceFormatted\nInterest Rate: $interestRate\nInterest: $interest\nTotal Amount: $total\nInterest Type: $interestTypeShare\n\n$text';
    }
    Share.share(text);
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat = NumberFormat("#,##,###.00");

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Interest Calculator', style: UiHelper.getTextStyle())),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareApp();
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: GestureDetector(
        onTap: () {
          // Hide the keyboard when the user taps outside the text fields
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // DropdownButton<String>(

              //   value: selectedLanguage,
              //   items: languages.map((String language) {
              //     return DropdownMenuItem<String>(
              //       value: language.substring(0, 2).toLowerCase(),
              //       child: Text(language),
              //     );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selectedLanguage = newValue!;
              //     });
              //     setLocale(context, selectedLanguage);
              //   },
              // ),
              // SizedBox(height: 16.0),
              const TextCustom('Principal Amount'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: principalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Principal Amount',
                ),
                onChanged: (value) {
                  setState(() {
                    isCalculateEnabled = validateFields();
                    isAmountCalculated = false;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const TextCustom('Interest Rate (In Rupees)'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: rateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Interest Rate in Rupees',
                ),
                onChanged: (value) {
                  setState(() {
                    isCalculateEnabled = validateFields();
                    isAmountCalculated = false;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextCustom('Given Date'),
                  TextButton(
                    onPressed: () => selectGivenDate(context),
                    child: Text(
                      givenDate != null
                          ? dateFormat.format(givenDate!)
                          : 'Select Date',
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextCustom('Return Date'),
                  TextButton(
                    onPressed: () => selectReturnDate(context),
                    child: Text(
                        returnDate != null
                            ? dateFormat.format(returnDate!)
                            : dateFormat.format(DateTime.now()),
                        style: const TextStyle(
                            color: Colors.blue, fontSize: 18.0)),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const TextCustom('Interest Type'),
                  DropdownButton<InterestType>(
                    value: interestType,
                    onChanged: (InterestType? newValue) {
                      setState(() {
                        interestType = newValue!;
                        isAmountCalculated = false;
                      });
                    },
                    items: const [
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
              const SizedBox(height: 8.0),
              Visibility(
                visible: interestType == InterestType.Compound,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const TextCustom('Time Cycle'),
                    DropdownButton<TimeCycle>(
                      value: timeCycle,
                      onChanged: (TimeCycle? newValue) {
                        setState(() {
                          timeCycle = newValue!;
                          isAmountCalculated = false;
                        });
                      },
                      items: dropDownItems,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: ElevatedButton(
                  onPressed: isCalculateEnabled ? calculateInterest : null,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: const Text('Calculate',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                ),
              ),
              const SizedBox(height: 8.0),
              Visibility(
                visible: totalAmount != 0 && isAmountCalculated,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TextCustom('Interest Amount'),
                      const SizedBox(height: 8.0),
                      Text(
                        currencyFormat
                            .format(double.tryParse(totalInterest()) ?? 0),
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      const SizedBox(height: 16.0),
                      const TextCustom('Total Amount'),
                      const SizedBox(height: 8.0),
                      Text(
                        currencyFormat.format(
                            double.tryParse(totalAmount.toStringAsFixed(2)) ??
                                0),
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 8.0),
                      TextCustom('Duration: $differenceFormatted'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String totalInterest() {
    return interestType == InterestType.Simple
        ? simpleInterest.toStringAsFixed(2)
        : compoundInterest.toStringAsFixed(2);
  }

  List<DropdownMenuItem<TimeCycle>> get dropDownItems {
    return const [
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
      // DropdownMenuItem<TimeCycle>(
      //   value: TimeCycle.OnceIn3Years,
      //   child: Text('Once in 3 Years'),
      // ),
    ];
  }
}
