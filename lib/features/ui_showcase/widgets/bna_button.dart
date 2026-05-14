import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bna_theme.dart';

enum BnaButtonVariant {
  defaultStyle,
  destructive,
  success,
  outline,
  secondary,
  ghost,
  link,
}

enum BnaButtonSize { defaultSize, sm, lg, icon }

class BnaButton extends StatefulWidget {
  const BnaButton({
    super.key,
    required this.child,
    this.icon,
    this.onPressed,
    this.variant = BnaButtonVariant.defaultStyle,
    this.size = BnaButtonSize.defaultSize,
    this.disabled = false,
    this.loading = false,
    this.animation = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.gradient,
    this.contentPadding,
    this.textStyle,
  });

  final Widget child;
  final IconData? icon;
  final VoidCallback? onPressed;
  final BnaButtonVariant variant;
  final BnaButtonSize size;
  final bool disabled;
  final bool loading;
  final bool animation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final Gradient? gradient;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;

  @override
  State<BnaButton> createState() => _BnaButtonState();
}

class _BnaButtonState extends State<BnaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final _ResolvedButtonStyle style = _resolveStyle(colors);
    final bool canInteract =
        widget.onPressed != null && !widget.disabled && !widget.loading;
    final bool isIconOnly =
        widget.size == BnaButtonSize.icon &&
        widget.icon != null &&
        !widget.loading;
    final double height = switch (widget.size) {
      BnaButtonSize.sm => 44,
      BnaButtonSize.lg => 54,
      BnaButtonSize.icon => BnaShowcaseMetrics.height,
      BnaButtonSize.defaultSize => BnaShowcaseMetrics.height,
    };
    final double iconSize = switch (widget.size) {
      BnaButtonSize.sm => 16,
      BnaButtonSize.lg => 24,
      BnaButtonSize.icon => 20,
      BnaButtonSize.defaultSize => 18,
    };
    final EdgeInsetsGeometry padding =
        widget.contentPadding ??
        (widget.variant == BnaButtonVariant.link
            ? EdgeInsets.zero
            : switch (widget.size) {
                BnaButtonSize.sm => const EdgeInsets.symmetric(horizontal: 24),
                BnaButtonSize.lg => const EdgeInsets.symmetric(horizontal: 36),
                BnaButtonSize.icon => EdgeInsets.zero,
                BnaButtonSize.defaultSize => const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
              });
    final BorderRadius borderRadius = BorderRadius.circular(
      widget.borderRadius ??
          (widget.variant == BnaButtonVariant.link
              ? 0
              : BnaShowcaseMetrics.corners),
    );

    return Opacity(
      opacity: widget.disabled
          ? 0.6
          : (!widget.animation && _pressed ? 0.8 : 1),
      child: AnimatedScale(
        scale: widget.animation && _pressed ? 1.04 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutBack,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.gradient == null ? style.backgroundColor : null,
            gradient: widget.gradient,
            borderRadius: borderRadius,
            border: style.borderColor == null
                ? null
                : Border.all(
                    color: style.borderColor!,
                    width: style.borderWidth,
                  ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: widget.animation && _pressed ? 0.08 : 0,
                    duration: const Duration(milliseconds: 120),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: borderRadius,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: const WidgetStatePropertyAll<Color>(
                    Colors.transparent,
                  ),
                  onTap: canInteract ? _handleTap : null,
                  onHighlightChanged: (bool value) {
                    if (_pressed != value) {
                      setState(() {
                        _pressed = value;
                      });
                    }
                  },
                  child: ConstrainedBox(
                    constraints: widget.size == BnaButtonSize.icon
                        ? BoxConstraints.tightFor(width: height, height: height)
                        : BoxConstraints(
                            minHeight: widget.variant == BnaButtonVariant.link
                                ? 0
                                : height,
                          ),
                    child: Padding(
                      padding: padding,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: BnaShowcaseMetrics.fontSize,
                          fontWeight: FontWeight.w500,
                          color: style.foregroundColor,
                          decoration: widget.variant == BnaButtonVariant.link
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ).merge(widget.textStyle),
                        child: IconTheme(
                          data: IconThemeData(
                            color: style.foregroundColor,
                            size: iconSize,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (widget.loading)
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      style.foregroundColor,
                                    ),
                                  ),
                                )
                              else if (isIconOnly)
                                Icon(widget.icon)
                              else ...<Widget>[
                                if (widget.icon != null) ...<Widget>[
                                  Icon(widget.icon),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(child: widget.child),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed?.call();
  }

  _ResolvedButtonStyle _resolveStyle(BnaShowcaseColors colors) {
    switch (widget.variant) {
      case BnaButtonVariant.destructive:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? colors.red,
          foregroundColor: widget.foregroundColor ?? Colors.white,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth ?? 1,
        );
      case BnaButtonVariant.success:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? colors.green,
          foregroundColor: widget.foregroundColor ?? Colors.white,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth ?? 1,
        );
      case BnaButtonVariant.outline:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ?? colors.primary,
          borderColor: widget.borderColor ?? colors.border,
          borderWidth: widget.borderWidth ?? 1,
        );
      case BnaButtonVariant.secondary:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? colors.secondary,
          foregroundColor: widget.foregroundColor ?? colors.secondaryForeground,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth ?? 1,
        );
      case BnaButtonVariant.ghost:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ?? colors.primary,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth ?? 1,
        );
      case BnaButtonVariant.link:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ?? colors.primary,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth ?? 1,
        );
      case BnaButtonVariant.defaultStyle:
        return _ResolvedButtonStyle(
          backgroundColor: widget.backgroundColor ?? colors.primary,
          foregroundColor: widget.foregroundColor ?? colors.primaryForeground,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth ?? 1,
        );
    }
  }
}

class _ResolvedButtonStyle {
  const _ResolvedButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.borderWidth,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double borderWidth;
}
