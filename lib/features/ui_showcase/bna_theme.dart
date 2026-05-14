import 'package:flutter/material.dart';

class BnaShowcaseColors {
  const BnaShowcaseColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.icon,
    required this.green,
    required this.red,
    required this.blue,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color icon;
  final Color green;
  final Color red;
  final Color blue;

  static const BnaShowcaseColors light = BnaShowcaseColors(
    background: Color(0xFFF5F5F5),
    foreground: Color(0xFF000000),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF000000),
    primary: Color(0xFF18181B),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFF2F2F7),
    secondaryForeground: Color(0xFF18181B),
    border: Color(0xFFC6C6C8),
    text: Color(0xFF000000),
    textMuted: Color(0xFF71717A),
    icon: Color(0xFF71717A),
    green: Color(0xFF34C759),
    red: Color(0xFFFF3B30),
    blue: Color(0xFF007AFF),
  );

  static const BnaShowcaseColors dark = BnaShowcaseColors(
    background: Color(0xFF000000),
    foreground: Color(0xFFFFFFFF),
    card: Color(0xFF1C1C1E),
    cardForeground: Color(0xFFFFFFFF),
    primary: Color(0xFFE4E4E7),
    primaryForeground: Color(0xFF18181B),
    secondary: Color(0xFF1C1C1E),
    secondaryForeground: Color(0xFFFFFFFF),
    border: Color(0xFF38383A),
    text: Color(0xFFFFFFFF),
    textMuted: Color(0xFFA1A1AA),
    icon: Color(0xFFA1A1AA),
    green: Color(0xFF30D158),
    red: Color(0xFFFF453A),
    blue: Color(0xFF0A84FF),
  );

  static BnaShowcaseColors of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

class BnaShowcaseMetrics {
  static const double height = 48;
  static const double fontSize = 17;
  static const double borderRadius = 26;
  static const double corners = 999;
  static const double pagePadding = 20;
  static const double sectionGap = 24;
  static const double itemGap = 12;
}

class BnaShowcaseTextStyles {
  static TextStyle heading(BnaShowcaseColors colors) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: colors.text,
    height: 1.1,
  );

  static TextStyle title(BnaShowcaseColors colors) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: colors.text,
    height: 1.15,
  );

  static TextStyle subtitle(BnaShowcaseColors colors) => TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: colors.text,
    height: 1.2,
  );

  static TextStyle body(BnaShowcaseColors colors) => TextStyle(
    fontSize: BnaShowcaseMetrics.fontSize,
    fontWeight: FontWeight.w400,
    color: colors.text,
    height: 1.35,
  );

  static TextStyle caption(BnaShowcaseColors colors) => TextStyle(
    fontSize: BnaShowcaseMetrics.fontSize,
    fontWeight: FontWeight.w400,
    color: colors.textMuted,
    height: 1.3,
  );

  static TextStyle overline(BnaShowcaseColors colors) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: colors.textMuted,
    height: 1.2,
    letterSpacing: 0.2,
  );
}
