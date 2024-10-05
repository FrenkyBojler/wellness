import 'package:flutter/material.dart';

class Styles {
  static TextStyle headerStyle() {
    return const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    );
  }
}

extension TextStyleExtension on TextStyle {
  withColor(Color color) {
    return copyWith(color: color);
  }
}
