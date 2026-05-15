import 'package:flutter/material.dart';

import '../bna_theme.dart';

enum BnaSeparatorOrientation { horizontal, vertical }

class BnaSeparator extends StatelessWidget {
  const BnaSeparator({
    super.key,
    this.orientation = BnaSeparatorOrientation.horizontal,
    this.color,
    this.width,
    this.height,
    this.margin,
    this.borderRadius,
  });

  final BnaSeparatorOrientation orientation;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final bool horizontal = orientation == BnaSeparatorOrientation.horizontal;

    Widget separator = SizedBox(
      width: width ?? (horizontal ? double.infinity : 1),
      height: height ?? (horizontal ? 1 : double.infinity),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? colors.border,
          borderRadius: borderRadius,
        ),
      ),
    );

    if (margin != null) {
      separator = Padding(padding: margin!, child: separator);
    }

    return separator;
  }
}
