import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:selftrackingapp/app_localizations.dart';

class CustomText extends StatelessWidget {
  final String data;
  final TextAlign textAlign;
  final TextStyle style;
  final bool isChangeFontSize;

  CustomText(this.data,
      {this.textAlign, this.style, this.isChangeFontSize = true});

  @override
  Widget build(BuildContext context) {
    TextStyle style = this.style;

    var locale = AppLocalizations.of(context).locale;
    if (locale.languageCode == "ta" && this.isChangeFontSize && style != null) {
      double fontSize = style.fontSize != null ? style.fontSize * 75 / 100 : 14;
      style = style.copyWith(fontSize: fontSize);
    }

    return AutoSizeText(
      data,
      textAlign: textAlign,
      style: style,
    );
  }
}
