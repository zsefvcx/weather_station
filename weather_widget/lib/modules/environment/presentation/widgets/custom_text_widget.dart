
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';
import 'package:weather_widget/core/theme/app_fonts.dart';

class CustomTextWidget extends StatelessWidget {

  const CustomTextWidget(String? data, {
    super.key,
    int maxLines = 1,
    bool failureMessage = false,
    Color? color = AppColors.white,
    double? fontSize = AppFonts.fontSize,
  }) : _data = data,
       _failureMessage = failureMessage,
       _maxLines = maxLines,
       _color = color,
       _fontSize = fontSize;

  final bool    _failureMessage;
  final String? _data;
  final int _maxLines;
  final Color? _color;
  final double? _fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: (_data??'').isNotEmpty,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(_data??'',
            style: (!_failureMessage?AppFonts.style:AppFonts.styleLite).copyWith(
               color: !_failureMessage?_color:AppColors.red,
              fontSize: !_failureMessage?_fontSize:AppFonts.fontSizeLite,
            ),
            textAlign: AppFonts.align,
            overflow: TextOverflow.ellipsis,
            maxLines: _maxLines,
          ),
        ),
      ),
    );
  }
}
