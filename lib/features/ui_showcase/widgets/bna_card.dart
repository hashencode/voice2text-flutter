import 'package:flutter/material.dart';

import '../bna_theme.dart';
import 'bna_text.dart';

class BnaCard extends StatelessWidget {
  const BnaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.borderRadius = BnaShowcaseMetrics.borderRadius,
    this.boxShadow,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.card,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor == null || borderWidth <= 0
            ? null
            : Border.all(color: borderColor!, width: borderWidth),
        boxShadow:
            boxShadow ??
            (isDark
                ? null
                : <BoxShadow>[
                    BoxShadow(
                      color: colors.foreground.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class BnaCardHeader extends StatelessWidget {
  const BnaCardHeader({super.key, required this.child, this.marginBottom = 8});

  final Widget child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: child,
    );
  }
}

class BnaCardTitle extends StatelessWidget {
  const BnaCardTitle(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return BnaText(
      text,
      variant: BnaTextVariant.title,
      style: const TextStyle(height: 1.15).merge(style),
    );
  }
}

class BnaCardDescription extends StatelessWidget {
  const BnaCardDescription(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return BnaText(text, variant: BnaTextVariant.caption, style: style);
  }
}

class BnaCardContent extends StatelessWidget {
  const BnaCardContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class BnaCardFooter extends StatelessWidget {
  const BnaCardFooter({super.key, required this.children, this.marginTop = 16});

  final List<Widget> children;
  final double marginTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int index = 0; index < children.length; index++) ...<Widget>[
            if (index > 0) const SizedBox(width: 8),
            children[index],
          ],
        ],
      ),
    );
  }
}
