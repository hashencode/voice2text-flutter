import 'package:flutter/material.dart';

import '../widgets/bna_button.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_spinner.dart';
import '../widgets/bna_text.dart';

class BnaSpinnerComponentPage extends StatefulWidget {
  const BnaSpinnerComponentPage({super.key});

  @override
  State<BnaSpinnerComponentPage> createState() =>
      _BnaSpinnerComponentPageState();
}

class _BnaSpinnerComponentPageState extends State<BnaSpinnerComponentPage> {
  bool _showFullscreenOverlay = false;

  Future<void> _handleShowOverlay() async {
    if (_showFullscreenOverlay) {
      return;
    }
    setState(() {
      _showFullscreenOverlay = true;
    });
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    setState(() {
      _showFullscreenOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BnaShowcaseScaffold(
          title: 'Spinner',
          description:
              'Loading indicators, inline loaders, and overlay feedback matched to the RN source component.',
          lazyChildren: <WidgetBuilder>[
            (_) => const BnaExampleSection(
              title: 'Default',
              surface: false,
              showDivider: true,
              child: Align(
                alignment: Alignment.centerLeft,
                child: BnaSpinner(),
              ),
            ),
            (_) => const BnaExampleSection(
              title: 'Variants',
              surface: false,
              showDivider: true,
              child: _SpinnerVariantsDemo(),
            ),
            (_) => const BnaExampleSection(
              title: 'Sizes',
              surface: false,
              showDivider: true,
              child: _SpinnerSizesDemo(),
            ),
            (_) => const BnaExampleSection(
              title: 'Labels',
              surface: false,
              showDivider: true,
              child: _SpinnerLabelsDemo(),
            ),
            (_) => const BnaExampleSection(
              title: 'Colors',
              surface: false,
              showDivider: true,
              child: _SpinnerColorsDemo(),
            ),
            (_) => const BnaExampleSection(
              title: 'Speeds',
              surface: false,
              showDivider: true,
              child: _SpinnerSpeedsDemo(),
            ),
            (_) => const BnaExampleSection(
              title: 'Inline',
              surface: false,
              showDivider: true,
              child: _SpinnerInlineDemo(),
            ),
            (_) => BnaExampleSection(
              title: 'Overlay',
              description:
                  'Triggers a full-screen blurred loading state with centered feedback.',
              surface: false,
              child: _SpinnerOverlayDemo(
                showOverlay: _showFullscreenOverlay,
                onShowOverlay: _handleShowOverlay,
              ),
            ),
          ],
        ),
        BnaLoadingOverlay(
          visible: _showFullscreenOverlay,
          size: BnaSpinnerSize.lg,
          label: 'Loading content...',
          backdropOpacity: 0.58,
          blurSigma: 16,
        ),
      ],
    );
  }
}

class _SpinnerVariantsDemo extends StatelessWidget {
  const _SpinnerVariantsDemo();

  @override
  Widget build(BuildContext context) {
    const List<({BnaSpinnerVariant variant, String label})> items =
        <({BnaSpinnerVariant variant, String label})>[
          (variant: BnaSpinnerVariant.defaultStyle, label: 'Default Style'),
          (variant: BnaSpinnerVariant.dots, label: 'Dots'),
          (variant: BnaSpinnerVariant.pulse, label: 'Pulse'),
          (variant: BnaSpinnerVariant.bars, label: 'Bars'),
        ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: items
          .map(
            (({BnaSpinnerVariant variant, String label}) item) => SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BnaSpinner(variant: item.variant),
                  const SizedBox(height: 8),
                  BnaText(
                    item.label,
                    variant: BnaTextVariant.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SpinnerSizesDemo extends StatelessWidget {
  const _SpinnerSizesDemo();

  @override
  Widget build(BuildContext context) {
    const List<({BnaSpinnerSize size, String label})> items =
        <({BnaSpinnerSize size, String label})>[
          (size: BnaSpinnerSize.sm, label: 'Small'),
          (size: BnaSpinnerSize.defaultSize, label: 'Default'),
          (size: BnaSpinnerSize.lg, label: 'Large'),
          (size: BnaSpinnerSize.icon, label: 'Icon'),
        ];

    return Wrap(
      spacing: 32,
      runSpacing: 20,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: items
          .map(
            (({BnaSpinnerSize size, String label}) item) => SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BnaSpinner(size: item.size),
                  const SizedBox(height: 8),
                  BnaText(
                    item.label,
                    variant: BnaTextVariant.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SpinnerLabelsDemo extends StatelessWidget {
  const _SpinnerLabelsDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaSpinner(showLabel: true),
        SizedBox(height: 24),
        BnaSpinner(variant: BnaSpinnerVariant.dots, label: 'Processing...'),
        SizedBox(height: 24),
        BnaSpinner(
          variant: BnaSpinnerVariant.pulse,
          label: 'Uploading files...',
        ),
        SizedBox(height: 24),
        BnaSpinner(size: BnaSpinnerSize.lg, label: 'Please wait'),
      ],
    );
  }
}

class _SpinnerColorsDemo extends StatelessWidget {
  const _SpinnerColorsDemo();

  @override
  Widget build(BuildContext context) {
    const List<({Color color, String label, BnaSpinnerVariant variant})> items =
        <({Color color, String label, BnaSpinnerVariant variant})>[
          (
            color: Color(0xFF3B82F6),
            label: 'Blue',
            variant: BnaSpinnerVariant.defaultStyle,
          ),
          (
            color: Color(0xFF10B981),
            label: 'Green',
            variant: BnaSpinnerVariant.dots,
          ),
          (
            color: Color(0xFFF59E0B),
            label: 'Orange',
            variant: BnaSpinnerVariant.pulse,
          ),
          (
            color: Color(0xFFEF4444),
            label: 'Red',
            variant: BnaSpinnerVariant.bars,
          ),
          (
            color: Color(0xFF8B5CF6),
            label: 'Purple',
            variant: BnaSpinnerVariant.defaultStyle,
          ),
        ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: items
          .map(
            (({Color color, String label, BnaSpinnerVariant variant}) item) =>
                SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      BnaSpinner(color: item.color, variant: item.variant),
                      const SizedBox(height: 8),
                      BnaText(
                        item.label,
                        variant: BnaTextVariant.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
          )
          .toList(),
    );
  }
}

class _SpinnerSpeedsDemo extends StatelessWidget {
  const _SpinnerSpeedsDemo();

  @override
  Widget build(BuildContext context) {
    const List<({BnaSpinnerSpeed speed, String label})> items =
        <({BnaSpinnerSpeed speed, String label})>[
          (speed: BnaSpinnerSpeed.slow, label: 'Slow'),
          (speed: BnaSpinnerSpeed.normal, label: 'Normal'),
          (speed: BnaSpinnerSpeed.fast, label: 'Fast'),
        ];

    return Wrap(
      spacing: 32,
      runSpacing: 20,
      children: items
          .map(
            (({BnaSpinnerSpeed speed, String label}) item) => SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  BnaSpinner(
                    variant: BnaSpinnerVariant.dots,
                    speed: item.speed,
                  ),
                  const SizedBox(height: 8),
                  BnaText(
                    item.label,
                    variant: BnaTextVariant.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SpinnerInlineDemo extends StatelessWidget {
  const _SpinnerInlineDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BnaText('Loading data'),
            SizedBox(width: 8),
            BnaInlineLoader(),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BnaText('Processing'),
            SizedBox(width: 8),
            BnaInlineLoader(variant: BnaSpinnerVariant.dots),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BnaInlineLoader(
              variant: BnaSpinnerVariant.pulse,
              color: Color(0xFF10B981),
            ),
            SizedBox(width: 8),
            BnaText('Syncing...'),
          ],
        ),
      ],
    );
  }
}

class _SpinnerOverlayDemo extends StatelessWidget {
  const _SpinnerOverlayDemo({
    required this.showOverlay,
    required this.onShowOverlay,
  });

  final bool showOverlay;
  final Future<void> Function() onShowOverlay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaButton(
          onPressed: showOverlay ? null : onShowOverlay,
          child: const Text('Show Full-Screen Loading Overlay'),
        ),
        const SizedBox(height: 12),
        const BnaText(
          'The overlay covers the whole page, uses translucent blur, and keeps the loading copy centered.',
          variant: BnaTextVariant.caption,
        ),
      ],
    );
  }
}
