import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData({
    @required BuildContext context,
    @required bool isDark,
  }) {
    return ThemeData(
      primaryColor: isDark ? const Color(0xFF161B22) : Colors.white,
      accentColor: const Color(0xFF2F8D46),
      backgroundColor:
          isDark ? const Color(0xFF010409) : const Color(0xFFEEEEEE),
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: 'Mont-med',
      colorScheme: isDark
          ? const ColorScheme.dark(primary: Color(0xFF2F8D46))
          : const ColorScheme.light(primary: Color(0xFF2F8D46)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
