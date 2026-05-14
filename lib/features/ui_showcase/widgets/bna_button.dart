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
    this.minFontSize,
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
  final double? minFontSize;

  @override
  State<BnaButton> createState() => _BnaButtonState();
}

class _BnaButtonState extends State<BnaButton> {
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
    final TextStyle labelStyle = TextStyle(
      fontSize: BnaShowcaseMetrics.fontSize,
      fontWeight: FontWeight.w500,
      color: style.foregroundColor,
      decoration: widget.variant == BnaButtonVariant.link
          ? TextDecoration.underline
          : TextDecoration.none,
    ).merge(widget.textStyle);

    return Opacity(
      opacity: widget.disabled ? 0.6 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.gradient == null ? style.backgroundColor : null,
          gradient: widget.gradient,
          borderRadius: borderRadius,
          border: style.borderColor == null
              ? null
              : Border.all(color: style.borderColor!, width: style.borderWidth),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll<Color>(
              Colors.transparent,
            ),
            onTap: canInteract ? _handleTap : null,
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
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final Widget content = _buildContent(
                      style: style,
                      labelStyle: labelStyle,
                      iconSize: iconSize,
                      isIconOnly: isIconOnly,
                      maxWidth: constraints.maxWidth,
                    );

                    return DefaultTextStyle(
                      style: labelStyle,
                      child: IconTheme(
                        data: IconThemeData(
                          color: style.foregroundColor,
                          size: iconSize,
                        ),
                        child: widget.variant == BnaButtonVariant.link
                            ? content
                            : Center(child: content),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required _ResolvedButtonStyle style,
    required TextStyle labelStyle,
    required double iconSize,
    required bool isIconOnly,
    required double maxWidth,
  }) {
    if (widget.loading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(style.foregroundColor),
        ),
      );
    }

    if (isIconOnly) {
      return Icon(widget.icon, size: iconSize);
    }

    final Widget label = _buildLabel(
      labelStyle: labelStyle,
      maxWidth: widget.icon == null
          ? maxWidth
          : (maxWidth - iconSize - 8).clamp(0.0, double.infinity).toDouble(),
    );

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(widget.icon, size: iconSize),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: (maxWidth - iconSize - 8)
                  .clamp(0.0, double.infinity)
                  .toDouble(),
            ),
            child: label,
          ),
        ],
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: label,
    );
  }

  Widget _buildLabel({
    required TextStyle labelStyle,
    required double maxWidth,
  }) {
    if (widget.child is! Text) {
      return widget.child;
    }

    return _AutoSizingButtonText(
      source: widget.child as Text,
      style: labelStyle,
      minFontSize: widget.minFontSize ?? _defaultMinFontSize(),
      maxWidth: maxWidth,
    );
  }

  double _defaultMinFontSize() {
    return switch (widget.size) {
      BnaButtonSize.sm => 13,
      BnaButtonSize.lg => 15,
      BnaButtonSize.icon => BnaShowcaseMetrics.fontSize,
      BnaButtonSize.defaultSize => 14,
    };
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

class _AutoSizingButtonText extends StatelessWidget {
  static const double _wrappedLineHeight = 1.05;

  const _AutoSizingButtonText({
    required this.source,
    required this.style,
    required this.minFontSize,
    required this.maxWidth,
  });

  final Text source;
  final TextStyle style;
  final double minFontSize;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final double baseFontSize = style.fontSize ?? BnaShowcaseMetrics.fontSize;
    final double minimum = minFontSize.clamp(1, baseFontSize).toDouble();
    final InlineSpan span = _buildSpan(style);

    if (!maxWidth.isFinite || maxWidth <= 0) {
      return _renderText(
        source,
        span,
        style.copyWith(fontSize: baseFontSize),
        maxLines: 1,
      );
    }

    final double fittedFontSize = _resolveFontSize(
      context: context,
      span: span,
      baseStyle: style,
      minFontSize: minimum,
      maxWidth: maxWidth,
    );
    final bool fitsSingleLine = _fitsWidth(
      context: context,
      span: span,
      style: style.copyWith(fontSize: fittedFontSize),
      maxWidth: maxWidth,
    );

    if (fitsSingleLine) {
      return _renderText(
        source,
        span,
        style.copyWith(fontSize: fittedFontSize),
        maxLines: 1,
      );
    }

    return _renderText(
      source,
      span,
      style.copyWith(fontSize: minimum, height: _wrappedLineHeight),
      maxLines: null,
    );
  }

  InlineSpan _buildSpan(TextStyle effectiveStyle) {
    if (source.textSpan != null) {
      return TextSpan(
        style: effectiveStyle,
        children: <InlineSpan>[source.textSpan!],
      );
    }

    return TextSpan(text: source.data ?? '', style: effectiveStyle);
  }

  double _resolveFontSize({
    required BuildContext context,
    required InlineSpan span,
    required TextStyle baseStyle,
    required double minFontSize,
    required double maxWidth,
  }) {
    final double baseFontSize =
        baseStyle.fontSize ?? BnaShowcaseMetrics.fontSize;

    if (_fitsWidth(
      context: context,
      span: span,
      style: baseStyle.copyWith(fontSize: baseFontSize),
      maxWidth: maxWidth,
    )) {
      return baseFontSize;
    }

    for (double size = baseFontSize - 0.5; size >= minFontSize; size -= 0.5) {
      if (_fitsWidth(
        context: context,
        span: span,
        style: baseStyle.copyWith(fontSize: size),
        maxWidth: maxWidth,
      )) {
        return size;
      }
    }

    return minFontSize;
  }

  bool _fitsWidth({
    required BuildContext context,
    required InlineSpan span,
    required TextStyle style,
    required double maxWidth,
  }) {
    final TextPainter painter = TextPainter(
      text: _restyleSpan(span, style),
      textDirection: Directionality.of(context),
      textAlign: source.textAlign ?? TextAlign.center,
      maxLines: 1,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);

    return !painter.didExceedMaxLines;
  }

  InlineSpan _restyleSpan(InlineSpan span, TextStyle style) {
    if (span is TextSpan) {
      return TextSpan(
        text: span.text,
        children: span.children,
        recognizer: span.recognizer,
        semanticsLabel: span.semanticsLabel,
        locale: span.locale,
        spellOut: span.spellOut,
        mouseCursor: span.mouseCursor,
        onEnter: span.onEnter,
        onExit: span.onExit,
        style: style.merge(span.style),
      );
    }

    return TextSpan(style: style, children: <InlineSpan>[span]);
  }

  Widget _renderText(
    Text source,
    InlineSpan span,
    TextStyle style, {
    required int? maxLines,
  }) {
    if (source.textSpan != null) {
      return Text.rich(
        _restyleSpan(span, style),
        key: source.key,
        textAlign: source.textAlign ?? TextAlign.center,
        textDirection: source.textDirection,
        locale: source.locale,
        softWrap: maxLines != 1,
        overflow: source.overflow,
        textScaler: source.textScaler,
        maxLines: maxLines,
        semanticsLabel: source.semanticsLabel,
        strutStyle: source.strutStyle,
        textWidthBasis: source.textWidthBasis,
        textHeightBehavior: source.textHeightBehavior,
        selectionColor: source.selectionColor,
      );
    }

    return Text(
      source.data ?? '',
      key: source.key,
      style: style.merge(source.style),
      textAlign: source.textAlign ?? TextAlign.center,
      textDirection: source.textDirection,
      locale: source.locale,
      softWrap: maxLines != 1,
      overflow: source.overflow,
      textScaler: source.textScaler,
      maxLines: maxLines,
      semanticsLabel: source.semanticsLabel,
      strutStyle: source.strutStyle,
      textWidthBasis: source.textWidthBasis,
      textHeightBehavior: source.textHeightBehavior,
      selectionColor: source.selectionColor,
    );
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
