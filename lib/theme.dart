import 'package:flutter/material.dart';

const primaryColor = Color(0xFF615ed8);
const primaryColorText = Color(0xFF242424);
const secondaryColorText = Color(0xFF615ed8);

const primaryColorSwitch = Color(0xFF615ed8);
const colorBackground = Color(0xFF242424);
const colorAccentBackground = Color(0xFFFFFFFF);
const colorBackgroundItemBorder = Color(0xFF707070);
const colorDefaultCardBackground = Color(0xFF615ed8);
const colorOne = Color(0xFF951288);

var backgroundShadowColor = Colors.black.withOpacity(0.48);

var titleBackgroundColor = colorOne;

const textColor = Color(0xFFFFFFFF);
const textLinkColor = Colors.white;
const textUnderLineColor = Color(0xFFFFFFFF);
const textSecondColor = Color(0xFFf9f871);

const defaultButtonColor = Color(0xFFff8e6f);
const defaultButtonTextColor = Color(0xFFFFFFFF);

const warningButtonColor = Color(0xFFEF7801);
const warningButtonTextColor = Color(0xFFFFFFFF);
const warningButtonFlipTextColor = Color(0xFFEF7801);

const mainButtonColor = Color(0xFFE849F3);
const mainButtonTextColor = Color(0xFFFFFFFF);

const successButtonColor = Color(0xFF7C28C7);
const successButtonTextColor = Color(0xFFFFFFFF);
const successButtonFlipTextColor = Color(0xFF7C28C7);

// Text StyleElement
const h1TextStyle = TextStyle(fontSize: 34.0, color: textColor);
const h2TextStyle = TextStyle(fontSize: 24.0, color: textColor);
const h3TextStyle = TextStyle(fontSize: 20.0, color: textColor);
const h4TextStyle = TextStyle(fontSize: 18.0, color: textColor);
const h5TextStyle = TextStyle(fontSize: 16.0, color: textColor);
const h6TextStyle = TextStyle(fontSize: 14.0, color: textColor);

var linkButtonTextStyle = h5TextStyle.copyWith(color: Colors.white);

var backgroundTextShadow = Shadow(
  blurRadius: 10.0,
  color: backgroundShadowColor,
  offset: Offset(5.0, 10.0),
);
var backgroundBoxShadow = BoxShadow(
  blurRadius: 10.0,
  color: backgroundShadowColor,
  offset: Offset(5.0, 10.0),
);
