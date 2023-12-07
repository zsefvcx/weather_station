import 'package:flutter/material.dart';

///Расширение класса num
extension NumberTypeExtensions on num {

  ///виджет - вертикльный спейс с заданной высотой
  ///add vertical space with given height
  Widget get h => SizedBox(
    height: double.parse(toString()),
  );

  ///Виджет - горизонтальный спейс с заданной шириной
  ///add horizontal space with given width
  Widget get w => SizedBox(
    width: double.parse(toString()),
  );

}
