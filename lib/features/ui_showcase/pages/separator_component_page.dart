import 'package:flutter/material.dart';

import '../widgets/bna_separator.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_text.dart';

class BnaSeparatorComponentPage extends StatelessWidget {
  const BnaSeparatorComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaCompareScaffold(
      title: 'Separator',
      description:
          'Visual dividers with horizontal and vertical layouts, matched to the RN source demos for spacing, thickness, and color.',
      children: const <Widget>[
        BnaCompareSection(
          title: 'Separator / Default',
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _SeparatorDefaultDemo(),
          ),
        ),
        BnaCompareSection(
          title: 'Separator / Vertical',
          child: _SeparatorVerticalDemo(),
        ),
        BnaCompareSection(
          title: 'Separator / Thickness',
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _SeparatorThicknessDemo(),
          ),
        ),
        BnaCompareSection(
          title: 'Separator / Colors',
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _SeparatorColorsDemo(),
          ),
        ),
        BnaCompareSection(
          title: 'Separator / Spacing',
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _SeparatorSpacingDemo(),
          ),
        ),
      ],
    );
  }
}

class _SeparatorDefaultDemo extends StatelessWidget {
  const _SeparatorDefaultDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText('Above separator'),
        BnaSeparator(margin: EdgeInsets.symmetric(vertical: 16)),
        BnaText('Below separator'),
      ],
    );
  }
}

class _SeparatorVerticalDemo extends StatelessWidget {
  const _SeparatorVerticalDemo();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BnaText('Left content', style: TextStyle(height: 1)),
            BnaSeparator(
              orientation: BnaSeparatorOrientation.vertical,
              margin: EdgeInsets.symmetric(horizontal: 16),
            ),
            BnaText('Right content', style: TextStyle(height: 1)),
          ],
        ),
      ),
    );
  }
}

class _SeparatorThicknessDemo extends StatelessWidget {
  const _SeparatorThicknessDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SeparatorLabeledLine(label: 'Thin (1px)', height: 1),
        SizedBox(height: 16),
        _SeparatorLabeledLine(label: 'Medium (2px)', height: 2),
        SizedBox(height: 16),
        _SeparatorLabeledLine(label: 'Thick (4px)', height: 4),
        SizedBox(height: 16),
        _SeparatorLabeledLine(label: 'Extra thick (8px)', height: 8),
      ],
    );
  }
}

class _SeparatorColorsDemo extends StatelessWidget {
  const _SeparatorColorsDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SeparatorColoredLine(label: 'Default'),
        SizedBox(height: 16),
        _SeparatorColoredLine(label: 'Red', color: Color(0xFFEF4444)),
        SizedBox(height: 16),
        _SeparatorColoredLine(label: 'Blue', color: Color(0xFF3B82F6)),
        SizedBox(height: 16),
        _SeparatorColoredLine(label: 'Green', color: Color(0xFF10B981)),
        SizedBox(height: 16),
        _SeparatorColoredLine(
          label: 'Semi-transparent',
          color: Color(0x33000000),
        ),
      ],
    );
  }
}

class _SeparatorSpacingDemo extends StatelessWidget {
  const _SeparatorSpacingDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText('Tight spacing'),
        BnaSeparator(margin: EdgeInsets.symmetric(vertical: 4)),
        BnaText('Content with minimal spacing'),
        BnaSeparator(margin: EdgeInsets.symmetric(vertical: 12)),
        BnaText('Normal spacing'),
        BnaSeparator(margin: EdgeInsets.symmetric(vertical: 16)),
        BnaText('Standard content spacing'),
        BnaSeparator(margin: EdgeInsets.symmetric(vertical: 12)),
        BnaText('Loose spacing'),
        BnaSeparator(margin: EdgeInsets.symmetric(vertical: 24)),
        BnaText('Generous content spacing'),
      ],
    );
  }
}

class _SeparatorLabeledLine extends StatelessWidget {
  const _SeparatorLabeledLine({required this.label, required this.height});

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText(
          label,
          variant: BnaTextVariant.caption,
          style: const TextStyle(height: 1.1),
        ),
        const SizedBox(height: 8),
        BnaSeparator(height: height),
      ],
    );
  }
}

class _SeparatorColoredLine extends StatelessWidget {
  const _SeparatorColoredLine({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText(
          label,
          variant: BnaTextVariant.caption,
          style: const TextStyle(height: 1.1),
        ),
        const SizedBox(height: 8),
        BnaSeparator(color: color),
      ],
    );
  }
}
