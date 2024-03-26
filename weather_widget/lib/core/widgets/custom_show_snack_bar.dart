import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';

class CustomShowSnackBar {

  static void showSnackBar(String massage, BuildContext context){
    final snackBar = SnackBar(
      content: Text(massage),
      action: SnackBarAction(
        label: 'Ok'.hardcoded,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
