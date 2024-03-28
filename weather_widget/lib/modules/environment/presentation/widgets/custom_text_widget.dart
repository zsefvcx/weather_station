
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_widget/core/core.dart';

class CustomTextWidget extends StatelessWidget {

  const CustomTextWidget(String? data, {
    super.key,
    bool failureMessage = false,
  }) : _data = data, _failureMessage = failureMessage;

  final bool    _failureMessage;
  final String? _data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: (_data??'').isNotEmpty,
        child: Row(
          mainAxisAlignment: !_failureMessage
              ?MainAxisAlignment.center
              :MainAxisAlignment.start,
          children: [
            if (_failureMessage) 15.w,
            Column(
              //https://www.fluttercampus.com/guide/382/text-overflow-not-working/
              children: [
                Text(_data??'',
                  style: !_failureMessage?style:styleLite,
                  textAlign: align,
                  overflow: TextOverflow.ellipsis,
                ),
                5.h,
              ],
            )
          ],
          ),
      ),
    );
  }
}
