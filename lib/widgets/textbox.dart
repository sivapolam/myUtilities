import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_utilities/utils.dart';

class TextBox extends StatelessWidget {
  String label;
  String helpertext;
  TextEditingController tc;
  IconData icon;
  Function? switchFunction;
  bool isReducedRate = false;

  TextBox(
    this.label,
    this.helpertext,
    this.tc,
    this.icon,
  );

  void setFunction(Function fn) {
    this.switchFunction = fn;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: tc,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label.toUpperCase(),
        labelStyle: GoogleFonts.roboto(
          fontSize: 18,
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
        hintText: 'Type Here...',
        hintStyle: GoogleFonts.openSans(fontSize: 16),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          String formattedValue =
              getFormattedNumber(double.parse(value.replaceAll(',', '')));
          tc.value = tc.value.copyWith(
            text: formattedValue,
            selection: TextSelection.collapsed(offset: formattedValue.length),
          );
        }
      },
    );
  }
}
