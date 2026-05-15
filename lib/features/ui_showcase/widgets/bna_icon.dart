import 'package:flutter/material.dart';

import '../bna_theme.dart';

class BnaIcon extends StatelessWidget {
  const BnaIcon({
    super.key,
    required this.icon,
    this.lightColor,
    this.darkColor,
    this.color,
    this.size = 24,
    this.strokeWidth,
    this.semanticLabel,
  });

  final IconData icon;
  final String? lightColor;
  final String? darkColor;
  final Color? color;
  final double size;
  final double? strokeWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final Brightness brightness = Theme.of(context).brightness;
    final IconThemeData inheritedTheme = IconTheme.of(context);

    return Icon(
      _resolveIcon(icon, strokeWidth),
      size: size,
      color: color ?? inheritedTheme.color ?? _resolveColor(colors, brightness),
      semanticLabel: semanticLabel,
    );
  }

  Color _resolveColor(BnaShowcaseColors colors, Brightness brightness) {
    final String? rawColor = switch (brightness) {
      Brightness.dark => darkColor,
      Brightness.light => lightColor,
    };

    if (rawColor != null) {
      return _parseHexColor(rawColor);
    }

    return colors.icon;
  }

  IconData _resolveIcon(IconData source, double? requestedStrokeWidth) {
    if (requestedStrokeWidth == null || source.fontFamily == null) {
      return source;
    }

    final String family = source.fontFamily!;
    if (!family.startsWith('Lucide')) {
      return source;
    }

    final String nextFamily = switch (_closestWeightToken(
      requestedStrokeWidth,
    )) {
      100 => 'Lucide100',
      200 => 'Lucide200',
      300 => 'Lucide300',
      400 => 'Lucide400',
      500 => 'Lucide500',
      600 => 'Lucide600',
      _ => 'Lucide',
    };

    return IconData(
      source.codePoint,
      fontFamily: nextFamily,
      fontPackage: source.fontPackage,
      matchTextDirection: source.matchTextDirection,
    );
  }

  int _closestWeightToken(double width) {
    const List<(int token, double width)> candidates = <(int, double)>[
      (100, 0.5),
      (200, 1.0),
      (300, 1.5),
      (400, 2.0),
      (500, 2.5),
      (600, 3.0),
    ];

    (int token, double width) best = candidates.first;
    double bestDelta = (width - best.$2).abs();
    for (final (int token, double candidateWidth) in candidates.skip(1)) {
      final double delta = (width - candidateWidth).abs();
      if (delta < bestDelta) {
        best = (token, candidateWidth);
        bestDelta = delta;
      }
    }
    return best.$1;
  }

  Color _parseHexColor(String raw) {
    final String value = raw.replaceFirst('#', '');
    final String normalized = value.length == 6 ? 'FF$value' : value;
    return Color(int.parse(normalized, radix: 16));
  }
}
