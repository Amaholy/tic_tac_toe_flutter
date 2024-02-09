import 'package:flutter/material.dart';

TextStyle MyCustom(
        {double fontSize = 15.0,
        required Color color,
        FontWeight fontWeight = FontWeight.normal}) =>
    TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight);
