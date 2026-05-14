import 'package:flutter/material.dart';

import '../bna_theme.dart';

enum BnaTextVariant { body, title, subtitle, caption, heading, link }

class BnaText extends StatelessWidget {
  const BnaText(
    this.data, {
    super.key,
    this.variant = BnaTextVariant.body,
    this.lightColor,
    this.darkColor,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : textSpan = null;

  const BnaText.rich(
    this.textSpan, {
    super.key,
    this.variant = BnaTextVariant.body,
    this.lightColor,
    this.darkColor,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : data = null;

  final String? data;
  final InlineSpan? textSpan;
  final BnaTextVariant variant;
  final String? lightColor;
  final String? darkColor;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final Brightness brightness = Theme.of(context).brightness;
    final TextStyle resolvedStyle = _baseStyle(
      colors,
    ).copyWith(color: _resolveColor(colors, brightness)).merge(style);

    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        style: resolvedStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return Text(
      data ?? '',
      style: resolvedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _baseStyle(BnaShowcaseColors colors) {
    return switch (variant) {
      BnaTextVariant.heading => BnaShowcaseTextStyles.heading(colors),
      BnaTextVariant.title => BnaShowcaseTextStyles.title(colors),
      BnaTextVariant.subtitle => BnaShowcaseTextStyles.subtitle(colors),
      BnaTextVariant.caption => BnaShowcaseTextStyles.caption(colors),
      BnaTextVariant.link => BnaShowcaseTextStyles.body(colors).copyWith(
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
      BnaTextVariant.body => BnaShowcaseTextStyles.body(colors),
    };
  }

  Color _resolveColor(BnaShowcaseColors colors, Brightness brightness) {
    final String? rawColor = switch (brightness) {
      Brightness.dark => darkColor,
      Brightness.light => lightColor,
    };

    if (rawColor != null) {
      return _parseHexColor(rawColor);
    }

    return variant == BnaTextVariant.caption ? colors.textMuted : colors.text;
  }

  Color _parseHexColor(String raw) {
    final String value = raw.replaceFirst('#', '');
    final String normalized = value.length == 6 ? 'FF$value' : value;
    return Color(int.parse(normalized, radix: 16));
  }
}
