import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/bna_button.dart';
import '../widgets/bna_showcase_shell.dart';

class BnaButtonComponentPage extends StatelessWidget {
  const BnaButtonComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Button',
      description:
          'A versatile button component with multiple variants, sizes, and interactive animations.',
      children: <Widget>[
        BnaExampleSection(
          title: 'Default',
          surface: false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: BnaButton(
              onPressed: () => _onPress(context, 'Default button'),
              child: const Text('Click me'),
            ),
          ),
        ),
        BnaExampleSection(
          title: 'Variants',
          surface: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaButton(
                onPressed: () => _onPress(context, 'Default variant'),
                child: const Text('Default'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                variant: BnaButtonVariant.destructive,
                onPressed: () => _onPress(context, 'Destructive variant'),
                child: const Text('Destructive'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                variant: BnaButtonVariant.success,
                onPressed: () => _onPress(context, 'Success variant'),
                child: const Text('Success'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                variant: BnaButtonVariant.outline,
                onPressed: () => _onPress(context, 'Outline variant'),
                child: const Text('Outline'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                variant: BnaButtonVariant.secondary,
                onPressed: () => _onPress(context, 'Secondary variant'),
                child: const Text('Secondary'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                variant: BnaButtonVariant.ghost,
                onPressed: () => _onPress(context, 'Ghost variant'),
                child: const Text('Ghost'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                variant: BnaButtonVariant.link,
                onPressed: () => _onPress(context, 'Link variant'),
                child: const Text('Link'),
              ),
            ],
          ),
        ),
        BnaExampleSection(
          title: 'Sizes',
          surface: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaButton(
                size: BnaButtonSize.sm,
                onPressed: () => _onPress(context, 'Small size'),
                child: const Text('Small'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                onPressed: () => _onPress(context, 'Default size'),
                child: const Text('Default'),
              ),
              const SizedBox(height: 12),
              BnaButton(
                size: BnaButtonSize.lg,
                onPressed: () => _onPress(context, 'Large size'),
                child: const Text('Large'),
              ),
            ],
          ),
        ),
        BnaExampleSection(
          title: 'With Icons',
          surface: false,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              BnaButton(
                icon: LucideIcons.download300,
                onPressed: () => _onPress(context, 'Download'),
                child: const Text('Download'),
              ),
              BnaButton(
                icon: LucideIcons.mail300,
                variant: BnaButtonVariant.outline,
                onPressed: () => _onPress(context, 'Email'),
                child: const Text('Email'),
              ),
              BnaButton(
                icon: LucideIcons.plus300,
                variant: BnaButtonVariant.success,
                onPressed: () => _onPress(context, 'Add item'),
                child: const Text('Add Item'),
              ),
              BnaButton(
                icon: LucideIcons.search300,
                variant: BnaButtonVariant.secondary,
                onPressed: () => _onPress(context, 'Search'),
                child: const Text('Search'),
              ),
            ],
          ),
        ),
        BnaExampleSection(
          title: 'Icon Only',
          surface: false,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              BnaButton(
                size: BnaButtonSize.icon,
                icon: LucideIcons.settings300,
                onPressed: () => _onPress(context, 'Settings'),
                child: const SizedBox.shrink(),
              ),
              BnaButton(
                size: BnaButtonSize.icon,
                variant: BnaButtonVariant.outline,
                icon: LucideIcons.heart300,
                onPressed: () => _onPress(context, 'Favorite'),
                child: const SizedBox.shrink(),
              ),
              BnaButton(
                size: BnaButtonSize.icon,
                variant: BnaButtonVariant.secondary,
                icon: LucideIcons.share300,
                onPressed: () => _onPress(context, 'Share'),
                child: const SizedBox.shrink(),
              ),
              BnaButton(
                size: BnaButtonSize.icon,
                variant: BnaButtonVariant.ghost,
                icon: LucideIcons.ellipsis300,
                onPressed: () => _onPress(context, 'More'),
                child: const SizedBox.shrink(),
              ),
              BnaButton(
                size: BnaButtonSize.icon,
                variant: BnaButtonVariant.destructive,
                icon: LucideIcons.messageCircle300,
                onPressed: () => _onPress(context, 'Message'),
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const BnaExampleSection(
          title: 'Loading States',
          surface: false,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              BnaButton(loading: true, child: Text('Loading...')),
              BnaButton(
                loading: true,
                variant: BnaButtonVariant.outline,
                child: Text('Please wait'),
              ),
              BnaButton(
                loading: true,
                variant: BnaButtonVariant.destructive,
                child: Text('Deleting...'),
              ),
              BnaButton(
                loading: true,
                size: BnaButtonSize.icon,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const BnaExampleSection(
          title: 'Disabled States',
          surface: false,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              BnaButton(disabled: true, child: Text('Disabled')),
              BnaButton(
                disabled: true,
                variant: BnaButtonVariant.outline,
                child: Text('Disabled Outline'),
              ),
              BnaButton(
                disabled: true,
                variant: BnaButtonVariant.destructive,
                child: Text('Disabled Destructive'),
              ),
              BnaButton(
                disabled: true,
                size: BnaButtonSize.icon,
                icon: LucideIcons.lock300,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ),
        BnaExampleSection(
          title: 'Custom Styling',
          surface: false,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              BnaButton(
                backgroundColor: const Color(0xFF8B5CF6),
                borderRadius: 12,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                onPressed: () => _onPress(context, 'Custom purple'),
                child: const Text('Custom Purple'),
              ),
              BnaButton(
                variant: BnaButtonVariant.outline,
                borderColor: const Color(0xFFF59E0B),
                borderWidth: 2,
                borderRadius: 20,
                foregroundColor: const Color(0xFFF59E0B),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                onPressed: () => _onPress(context, 'Custom orange'),
                child: const Text('Custom Orange'),
              ),
              BnaButton(
                icon: LucideIcons.star300,
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                borderRadius: 12,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                onPressed: () => _onPress(context, 'Gradient style'),
                child: const Text('Gradient Style'),
              ),
            ],
          ),
        ),
        BnaExampleSection(
          title: 'Animation Control',
          surface: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'With Animation (default)',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF71717A),
                ),
              ),
              const SizedBox(height: 8),
              BnaButton(
                onPressed: () => _onPress(context, 'Animated button'),
                child: const Text('Animated Button'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Without Animation',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF71717A),
                ),
              ),
              const SizedBox(height: 8),
              BnaButton(
                animation: false,
                onPressed: () => _onPress(context, 'Static button'),
                child: const Text('Static Button'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onPress(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
  }
}
