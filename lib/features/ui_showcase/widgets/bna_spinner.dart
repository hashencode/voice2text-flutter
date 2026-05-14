import 'dart:ui';

import 'package:flutter/material.dart';
import '../bna_theme.dart';

enum BnaSpinnerSize { sm, defaultSize, lg, icon }

enum BnaSpinnerVariant { defaultStyle, dots, pulse, bars }

enum BnaSpinnerSpeed { slow, normal, fast }

class BnaSpinner extends StatefulWidget {
  const BnaSpinner({
    super.key,
    this.size = BnaSpinnerSize.defaultSize,
    this.variant = BnaSpinnerVariant.bars,
    this.label,
    this.showLabel = false,
    this.color,
    this.thickness,
    this.speed = BnaSpinnerSpeed.normal,
  });

  final BnaSpinnerSize size;
  final BnaSpinnerVariant variant;
  final String? label;
  final bool showLabel;
  final Color? color;
  final double? thickness;
  final BnaSpinnerSpeed speed;

  @override
  State<BnaSpinner> createState() => _BnaSpinnerState();
}

class _BnaSpinnerState extends State<BnaSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _durationFor(widget.speed),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant BnaSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _controller
        ..duration = _durationFor(widget.speed)
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final _BnaSpinnerConfig config = _spinnerConfig(widget.size);
    final Color spinnerColor = widget.color ?? colors.text;
    final bool showLabel = widget.showLabel || widget.label != null;
    final Widget spinner = _buildSpinner(config, spinnerColor);

    return Semantics(
      label: showLabel ? (widget.label ?? 'Loading...') : 'Loading',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          spinner,
          if (showLabel) ...<Widget>[
            SizedBox(height: config.gap),
            Text(
              widget.label ?? 'Loading...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.text,
                fontSize: config.fontSize,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpinner(_BnaSpinnerConfig config, Color spinnerColor) {
    return switch (widget.variant) {
      BnaSpinnerVariant.defaultStyle => SizedBox(
        width: config.size,
        height: config.size,
        child: CircularProgressIndicator(
          strokeWidth: widget.thickness ?? config.thickness,
          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
        ),
      ),
      BnaSpinnerVariant.pulse => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          final double pulse = _pulseScale(_controller.value);
          return Transform.scale(
            scale: pulse,
            child: Container(
              width: config.size,
              height: config.size,
              decoration: BoxDecoration(
                color: spinnerColor,
                borderRadius: BorderRadius.circular(BnaShowcaseMetrics.corners),
              ),
            ),
          );
        },
      ),
      BnaSpinnerVariant.dots => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(3, (int index) {
              final double opacity = _staggeredOpacity(
                index: index,
                delayFraction: 1 / 6,
                riseFraction: 1 / 3,
                fallFraction: 1 / 3,
              );
              return Padding(
                padding: EdgeInsets.only(
                  right: index == 2 ? 0 : config.size / 4,
                ),
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: config.size / 3,
                    height: config.size / 3,
                    decoration: BoxDecoration(
                      color: spinnerColor,
                      borderRadius: BorderRadius.circular(
                        BnaShowcaseMetrics.corners,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
      BnaSpinnerVariant.bars => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(4, (int index) {
              final double opacity = _staggeredOpacity(
                index: index,
                delayFraction: 1 / 8,
                riseFraction: 1 / 4,
                fallFraction: 1 / 4,
              );
              return Padding(
                padding: EdgeInsets.only(
                  right: index == 3 ? 0 : config.size / 6,
                ),
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: config.size / 6,
                    height: config.size,
                    decoration: BoxDecoration(
                      color: spinnerColor,
                      borderRadius: BorderRadius.circular(
                        BnaShowcaseMetrics.corners,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    };
  }

  double _pulseScale(double progress) {
    final double normalized = progress < 0.5
        ? progress * 2
        : (1 - progress) * 2;
    return 1 + (Curves.easeInOut.transform(normalized) * 0.3);
  }

  double _staggeredOpacity({
    required int index,
    required double delayFraction,
    required double riseFraction,
    required double fallFraction,
  }) {
    final double total = riseFraction + fallFraction;
    double phase = _controller.value - (index * delayFraction);
    while (phase < 0) {
      phase += 1;
    }
    phase %= 1;

    if (phase < riseFraction) {
      return _lerp(0.3, 1, Curves.easeInOut.transform(phase / riseFraction));
    }
    if (phase < total) {
      return _lerp(
        1,
        0.3,
        Curves.easeInOut.transform((phase - riseFraction) / fallFraction),
      );
    }
    return 0.3;
  }

  double _lerp(double begin, double end, double t) {
    return begin + ((end - begin) * t);
  }

  Duration _durationFor(BnaSpinnerSpeed speed) {
    return switch (speed) {
      BnaSpinnerSpeed.slow => const Duration(milliseconds: 1500),
      BnaSpinnerSpeed.fast => const Duration(milliseconds: 500),
      BnaSpinnerSpeed.normal => const Duration(milliseconds: 1000),
    };
  }
}

class BnaLoadingOverlay extends StatelessWidget {
  const BnaLoadingOverlay({
    super.key,
    required this.visible,
    this.backdrop = true,
    this.backdropColor,
    this.backdropOpacity = 0.5,
    this.size = BnaSpinnerSize.defaultSize,
    this.variant = BnaSpinnerVariant.bars,
    this.label,
    this.showLabel = false,
    this.color,
    this.thickness,
    this.speed = BnaSpinnerSpeed.normal,
    this.blurSigma = 14,
  });

  final bool visible;
  final bool backdrop;
  final Color? backdropColor;
  final double backdropOpacity;
  final BnaSpinnerSize size;
  final BnaSpinnerVariant variant;
  final String? label;
  final bool showLabel;
  final Color? color;
  final double? thickness;
  final BnaSpinnerSpeed speed;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final Color resolvedBackdropColor =
        backdropColor ?? colors.background.withValues(alpha: backdropOpacity);

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: visible ? 1 : 0,
          child: ExcludeSemantics(
            excluding: !visible,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: backdrop
                        ? resolvedBackdropColor
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: BnaSpinner(
                        size: size,
                        variant: variant,
                        label: label,
                        showLabel: showLabel || label != null,
                        color: color,
                        thickness: thickness,
                        speed: speed,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BnaInlineLoader extends StatelessWidget {
  const BnaInlineLoader({
    super.key,
    this.size = BnaSpinnerSize.sm,
    this.variant = BnaSpinnerVariant.bars,
    this.color,
    this.speed = BnaSpinnerSpeed.normal,
  });

  final BnaSpinnerSize size;
  final BnaSpinnerVariant variant;
  final Color? color;
  final BnaSpinnerSpeed speed;

  @override
  Widget build(BuildContext context) {
    return BnaSpinner(size: size, variant: variant, color: color, speed: speed);
  }
}

class BnaButtonSpinner extends StatelessWidget {
  const BnaButtonSpinner({
    super.key,
    this.size = BnaSpinnerSize.sm,
    this.variant = BnaSpinnerVariant.bars,
    this.color,
    this.speed = BnaSpinnerSpeed.normal,
  });

  final BnaSpinnerSize size;
  final BnaSpinnerVariant variant;
  final Color? color;
  final BnaSpinnerSpeed speed;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return BnaSpinner(
      size: size,
      variant: variant,
      color: color ?? colors.primaryForeground,
      speed: speed,
    );
  }
}

class _BnaSpinnerConfig {
  const _BnaSpinnerConfig({
    required this.size,
    required this.iconSize,
    required this.fontSize,
    required this.gap,
    required this.thickness,
  });

  final double size;
  final double iconSize;
  final double fontSize;
  final double gap;
  final double thickness;
}

_BnaSpinnerConfig _spinnerConfig(BnaSpinnerSize size) {
  return switch (size) {
    BnaSpinnerSize.sm => const _BnaSpinnerConfig(
      size: 16,
      iconSize: 16,
      fontSize: 12,
      gap: 6,
      thickness: 2,
    ),
    BnaSpinnerSize.lg => const _BnaSpinnerConfig(
      size: 32,
      iconSize: 32,
      fontSize: 16,
      gap: 10,
      thickness: 3,
    ),
    BnaSpinnerSize.icon => const _BnaSpinnerConfig(
      size: 24,
      iconSize: 24,
      fontSize: BnaShowcaseMetrics.fontSize,
      gap: 8,
      thickness: 2,
    ),
    BnaSpinnerSize.defaultSize => const _BnaSpinnerConfig(
      size: 24,
      iconSize: 24,
      fontSize: BnaShowcaseMetrics.fontSize,
      gap: 8,
      thickness: 2,
    ),
  };
}
