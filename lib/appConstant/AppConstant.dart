import 'package:flutter/material.dart';
class AppConsts {
  static Color primaryColor = Color.fromRGBO(20, 28, 43, 1);
  static Color secondaryColor = Color.fromRGBO(9, 1, 23, 1);
  static Color primaryTextColor = Colors.white;
  static Color secTextColor = Colors.black;
  static String appFont = 'Metropolis';
  static TextStyle whiteBold = TextStyle(
      color: AppConsts.primaryTextColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Metropolis ');
  static TextStyle whiteNormal = TextStyle(
      color: AppConsts.primaryTextColor,
      fontWeight: FontWeight.normal,
      fontFamily: 'Metropolis ');
  static TextStyle whiteBoldWithSpacing = TextStyle(
      color: AppConsts.primaryTextColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      fontFamily: 'Metropolis ');
  static TextStyle blackBold = TextStyle(
      color: AppConsts.secTextColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Metropolis ');
  static TextStyle blackNormal = TextStyle(
      color: AppConsts.secTextColor,
      fontWeight: FontWeight.normal,
      fontFamily: 'Metropolis ');
}
var darkMode = false;
