import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UiHelper {
  static TextStyle getTextStyle(
      {double font = 25, Color color = Colors.white}) {
    return GoogleFonts.oswald(fontSize: font, color: color);
  }

  static ButtonStyle get getButtonStyle {
    return ElevatedButton.styleFrom(
      textStyle: UiHelper.getTextStyle(),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 4),
    );
  }

  static SizedBox getSizeBox({double height = 10, double width = 10}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
