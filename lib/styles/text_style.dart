import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//app title style
titleStyle() {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          letterSpacing: 5,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white));
}

//date style
dateStyle() {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.grey[200]));
}

//btnText

btntextStyle() {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.white));
}

saveButtonStyle() {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white));
}

//selected date Style

selectedColenderMonth() {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.white));
}

selectedColenderDay() {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          letterSpacing: 4,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white));
}
