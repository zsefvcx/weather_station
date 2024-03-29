
import 'package:flutter/material.dart';
import 'package:weather_widget/core/theme/app_color.dart';

abstract final class  AppFonts {

  static const mainFont = 'SF UI Display';

  static const align = TextAlign.start;

  static const double fontSize = 15;
  static const double fontSizeLite = 10;

  static const style = TextStyle(
    fontFamily: mainFont,
    color: AppColors.black,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1,
  );
  static const styleLite = TextStyle(
    fontFamily: mainFont,
    color: AppColors.red,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1,
  );

}
