import 'package:flutter/material.dart';

import '../bna_theme.dart';

enum BnaBadgeVariant { defaultStyle, secondary, destructive, outline, success }

class BnaBadge extends StatelessWidget {
  const BnaBadge({
    super.key,
    required this.child,
    this.variant = BnaBadgeVariant.defaultStyle,
    this.padding,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.width,
    this.height,
    this.minWidth,
    this.alignment = Alignment.center,
    this.semanticLabel,
  });

  final Widget child;
  final BnaBadgeVariant variant;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double? minWidth;
  final AlignmentGeometry alignment;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final _BadgePalette palette = _resolvePalette(colors);
    final TextStyle resolvedTextStyle = _capFontWeight(
      TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: foregroundColor ?? palette.foreground,
        height: 1.1,
      ).merge(textStyle),
    );

    final BoxConstraints constraints = BoxConstraints(
      minWidth: width ?? minWidth ?? 0,
      maxWidth: width ?? double.infinity,
      minHeight: height ?? 0,
      maxHeight: height ?? double.infinity,
    );

    Widget badge = ConstrainedBox(
      constraints: constraints,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? palette.background,
          borderRadius: BorderRadius.circular(
            borderRadius ?? BnaShowcaseMetrics.corners,
          ),
          border: (borderColor ?? palette.borderColor) != null
              ? Border.all(
                  color: borderColor ?? palette.borderColor!,
                  width: borderWidth ?? 1,
                )
              : null,
        ),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Align(
            alignment: alignment,
            widthFactor: width == null ? 1 : null,
            heightFactor: height == null ? 1 : null,
            child: DefaultTextStyle.merge(
              style: resolvedTextStyle,
              textAlign: TextAlign.center,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: resolvedTextStyle.color,
                  size: resolvedTextStyle.fontSize,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (semanticLabel != null) {
      badge = Semantics(container: true, label: semanticLabel, child: badge);
    }

    return badge;
  }

  _BadgePalette _resolvePalette(BnaShowcaseColors colors) {
    return switch (variant) {
      BnaBadgeVariant.secondary => _BadgePalette(
        background: colors.secondary,
        foreground: colors.secondaryForeground,
      ),
      BnaBadgeVariant.destructive => const _BadgePalette(
        background: Color(0xFFEF4444),
        foreground: Colors.white,
      ),
      BnaBadgeVariant.outline => _BadgePalette(
        background: Colors.transparent,
        foreground: colors.primary,
        borderColor: colors.border,
      ),
      BnaBadgeVariant.success => _BadgePalette(
        background: colors.green,
        foreground: colors.primaryForeground,
      ),
      BnaBadgeVariant.defaultStyle => _BadgePalette(
        background: colors.primary,
        foreground: colors.primaryForeground,
      ),
    };
  }

  TextStyle _capFontWeight(TextStyle style) {
    final FontWeight? weight = style.fontWeight;
    if (weight == null) {
      return style;
    }

    const List<FontWeight> orderedWeights = <FontWeight>[
      FontWeight.w100,
      FontWeight.w200,
      FontWeight.w300,
      FontWeight.w400,
      FontWeight.w500,
      FontWeight.w600,
      FontWeight.w700,
      FontWeight.w800,
      FontWeight.w900,
    ];

    final int index = orderedWeights.indexOf(weight);
    if (index == -1 || index <= 3) {
      return style;
    }

    return style.copyWith(fontWeight: FontWeight.w400);
  }
}

class _BadgePalette {
  const _BadgePalette({
    required this.background,
    required this.foreground,
    this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color? borderColor;
}
