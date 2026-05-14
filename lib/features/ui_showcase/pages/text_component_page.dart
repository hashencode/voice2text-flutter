import 'package:flutter/material.dart';

import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_text.dart';

class BnaTextComponentPage extends StatelessWidget {
  const BnaTextComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Text',
      description:
          'Typography primitives with semantic variants and theme-aware custom colors.',
      children: const <Widget>[
        BnaExampleSection(
          title: 'Default',
          surface: false,
          child: _TextDefaultDemo(),
        ),
        BnaExampleSection(
          title: 'Variants',
          surface: false,
          child: _TextVariantsDemo(),
        ),
        BnaExampleSection(
          title: 'Colors',
          surface: false,
          child: _TextColorsDemo(),
        ),
      ],
    );
  }
}

class _TextDefaultDemo extends StatelessWidget {
  const _TextDefaultDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText('Heading Text', variant: BnaTextVariant.heading),
        SizedBox(height: 16),
        BnaText('Title Text', variant: BnaTextVariant.title),
        SizedBox(height: 16),
        BnaText('Subtitle Text', variant: BnaTextVariant.subtitle),
        SizedBox(height: 16),
        BnaText(
          'This is body text that demonstrates the default styling for regular content.',
        ),
        SizedBox(height: 16),
        BnaText(
          'Caption text for additional information',
          variant: BnaTextVariant.caption,
        ),
        SizedBox(height: 16),
        BnaText('Link text with underline', variant: BnaTextVariant.link),
      ],
    );
  }
}

class _TextVariantsDemo extends StatelessWidget {
  const _TextVariantsDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TextVariantBlock(
          label: 'HEADING (28px, weight 700)',
          child: BnaText(
            'The quick brown fox jumps over the lazy dog',
            variant: BnaTextVariant.heading,
          ),
        ),
        SizedBox(height: 20),
        _TextVariantBlock(
          label: 'TITLE (24px, weight 700)',
          child: BnaText(
            'The quick brown fox jumps over the lazy dog',
            variant: BnaTextVariant.title,
          ),
        ),
        SizedBox(height: 20),
        _TextVariantBlock(
          label: 'SUBTITLE (19px, weight 600)',
          child: BnaText(
            'The quick brown fox jumps over the lazy dog',
            variant: BnaTextVariant.subtitle,
          ),
        ),
        SizedBox(height: 20),
        _TextVariantBlock(
          label: 'BODY (16px, weight 400)',
          child: BnaText(
            'The quick brown fox jumps over the lazy dog. This is the default text variant used for body content and regular paragraphs.',
          ),
        ),
        SizedBox(height: 20),
        _TextVariantBlock(
          label: 'CAPTION (16px, weight 400, muted)',
          child: BnaText(
            'The quick brown fox jumps over the lazy dog',
            variant: BnaTextVariant.caption,
          ),
        ),
        SizedBox(height: 20),
        _TextVariantBlock(
          label: 'LINK (16px, weight 500, underlined)',
          child: BnaText(
            'The quick brown fox jumps over the lazy dog',
            variant: BnaTextVariant.link,
          ),
        ),
      ],
    );
  }
}

class _TextVariantBlock extends StatelessWidget {
  const _TextVariantBlock({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText(
          label,
          variant: BnaTextVariant.caption,
          style: const TextStyle(height: 1.2),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _TextColorsDemo extends StatelessWidget {
  const _TextColorsDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText('Custom Color Examples', variant: BnaTextVariant.subtitle),
        SizedBox(height: 8),
        BnaText(
          'This text uses custom blue colors for light and dark themes',
          lightColor: '#3b82f6',
          darkColor: '#60a5fa',
        ),
        SizedBox(height: 16),
        BnaText(
          'This text uses custom green colors for light and dark themes',
          lightColor: '#10b981',
          darkColor: '#34d399',
        ),
        SizedBox(height: 16),
        BnaText(
          'This text uses custom amber colors for light and dark themes',
          lightColor: '#f59e0b',
          darkColor: '#fbbf24',
        ),
        SizedBox(height: 16),
        BnaText(
          'This text uses custom red colors for light and dark themes',
          lightColor: '#ef4444',
          darkColor: '#f87171',
        ),
        SizedBox(height: 16),
        BnaText(
          'This text uses custom purple colors for light and dark themes',
          lightColor: '#8b5cf6',
          darkColor: '#a78bfa',
        ),
        SizedBox(height: 16),
        BnaText(
          'Note: These colors automatically adapt based on the current theme (light/dark mode)',
          variant: BnaTextVariant.caption,
        ),
      ],
    );
  }
}
