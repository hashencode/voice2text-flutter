import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/bna_button.dart';
import '../widgets/bna_icon.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_text.dart';

class BnaIconComponentPage extends StatefulWidget {
  const BnaIconComponentPage({super.key});

  @override
  State<BnaIconComponentPage> createState() => _BnaIconComponentPageState();
}

class _BnaIconComponentPageState extends State<BnaIconComponentPage> {
  bool _liked = false;
  bool _thumbsUp = false;
  bool _bookmarked = false;

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Icon',
      description:
          'A themed icon component with support for Lucide React Native icons.',
      children: <Widget>[
        const BnaExampleSection(
          title: 'Default',
          surface: false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: BnaIcon(
              icon: LucideIcons.heart300,
              semanticLabel: 'Heart icon',
            ),
          ),
        ),
        const BnaExampleSection(
          title: 'Sizes',
          surface: false,
          child: _IconSizesDemo(),
        ),
        const BnaExampleSection(
          title: 'Colors',
          surface: false,
          child: _IconColorsDemo(),
        ),
        const BnaExampleSection(
          title: 'Stroke',
          surface: false,
          child: _IconStrokeDemo(),
        ),
        BnaExampleSection(
          title: 'Interactive',
          surface: false,
          child: _IconInteractiveDemo(
            liked: _liked,
            thumbsUp: _thumbsUp,
            bookmarked: _bookmarked,
            onLikedChanged: () => setState(() => _liked = !_liked),
            onThumbsUpChanged: () => setState(() => _thumbsUp = !_thumbsUp),
            onBookmarkedChanged: () =>
                setState(() => _bookmarked = !_bookmarked),
          ),
        ),
        const BnaExampleSection(
          title: 'Grid',
          surface: false,
          child: _IconGridDemo(),
        ),
        const BnaExampleSection(
          title: 'Themed',
          surface: false,
          child: _IconThemedDemo(),
        ),
      ],
    );
  }
}

class _IconSizesDemo extends StatelessWidget {
  const _IconSizesDemo();

  @override
  Widget build(BuildContext context) {
    const List<double> sizes = <double>[16, 20, 24, 32, 40, 48];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: sizes
          .map(
            (double size) => BnaIcon(
              icon: LucideIcons.star300,
              size: size,
              color: const Color(0xFFFFD700),
              semanticLabel: 'Star icon ${size.toInt()}px',
            ),
          )
          .toList(),
    );
  }
}

class _IconColorsDemo extends StatelessWidget {
  const _IconColorsDemo();

  @override
  Widget build(BuildContext context) {
    const List<Color> colors = <Color>[
      Color(0xFFFF6B6B),
      Color(0xFF4ECDC4),
      Color(0xFF45B7D1),
      Color(0xFF96CEB4),
      Color(0xFFFECA57),
      Color(0xFFFF9FF3),
      Color(0xFF54A0FF),
      Color(0xFF5F27CD),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors
          .map(
            (Color color) => SizedBox.square(
              dimension: 28,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  BnaIcon(
                    icon: LucideIcons.circle300,
                    size: 24,
                    color: color,
                    semanticLabel: 'Colored circle icon',
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _IconStrokeDemo extends StatelessWidget {
  const _IconStrokeDemo();

  @override
  Widget build(BuildContext context) {
    const List<({String label, double weight})> weights =
        <({String label, double weight})>[
          (label: 'Light', weight: 1),
          (label: 'Regular', weight: 1.5),
          (label: 'Medium', weight: 2),
          (label: 'Bold', weight: 2.5),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weights
          .map(
            (({String label, double weight}) item) => Padding(
              padding: EdgeInsets.only(bottom: item == weights.last ? 0 : 16),
              child: Row(
                children: <Widget>[
                  BnaIcon(
                    icon: LucideIcons.zap300,
                    size: 24,
                    strokeWidth: item.weight,
                    color: const Color(0xFFF39C12),
                    semanticLabel: '${item.label} weight icon',
                  ),
                  const SizedBox(width: 12),
                  BnaText(item.label, style: const TextStyle(height: 1.1)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _IconInteractiveDemo extends StatelessWidget {
  const _IconInteractiveDemo({
    required this.liked,
    required this.thumbsUp,
    required this.bookmarked,
    required this.onLikedChanged,
    required this.onThumbsUpChanged,
    required this.onBookmarkedChanged,
  });

  final bool liked;
  final bool thumbsUp;
  final bool bookmarked;
  final VoidCallback onLikedChanged;
  final VoidCallback onThumbsUpChanged;
  final VoidCallback onBookmarkedChanged;

  @override
  Widget build(BuildContext context) {
    final List<
      ({
        IconData icon,
        bool active,
        Color activeColor,
        VoidCallback onPressed,
        String label,
      })
    >
    buttons =
        <
          ({
            IconData icon,
            bool active,
            Color activeColor,
            VoidCallback onPressed,
            String label,
          })
        >[
          (
            icon: LucideIcons.heart300,
            active: liked,
            activeColor: const Color(0xFFFF6B6B),
            onPressed: onLikedChanged,
            label: 'Like',
          ),
          (
            icon: LucideIcons.thumbsUp300,
            active: thumbsUp,
            activeColor: const Color(0xFF4ECDC4),
            onPressed: onThumbsUpChanged,
            label: 'Thumbs up',
          ),
          (
            icon: LucideIcons.bookmark300,
            active: bookmarked,
            activeColor: const Color(0xFFFECA57),
            onPressed: onBookmarkedChanged,
            label: 'Bookmark',
          ),
          (
            icon: LucideIcons.share300,
            active: false,
            activeColor: const Color(0xFF45B7D1),
            onPressed: () {},
            label: 'Share',
          ),
        ];

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: buttons
          .map(
            (
              ({
                IconData icon,
                bool active,
                Color activeColor,
                VoidCallback onPressed,
                String label,
              })
              item,
            ) => BnaButton(
              variant: BnaButtonVariant.ghost,
              size: BnaButtonSize.icon,
              onPressed: item.onPressed,
              child: SizedBox.square(
                dimension: 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    if (item.active)
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: item.activeColor.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                      ),
                    BnaIcon(
                      icon: item.icon,
                      size: 24,
                      color: item.active
                          ? item.activeColor
                          : const Color(0xFF888888),
                      semanticLabel: item.label,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _IconGridDemo extends StatelessWidget {
  const _IconGridDemo();

  @override
  Widget build(BuildContext context) {
    const List<IconData> icons = <IconData>[
      LucideIcons.house300,
      LucideIcons.search300,
      LucideIcons.bell300,
      LucideIcons.user300,
      LucideIcons.settings300,
      LucideIcons.heart300,
      LucideIcons.star300,
      LucideIcons.mail300,
      LucideIcons.calendar300,
      LucideIcons.camera300,
      LucideIcons.download300,
      LucideIcons.upload300,
      LucideIcons.squarePen300,
      LucideIcons.trash300,
      LucideIcons.plus300,
      LucideIcons.minus300,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: icons
          .map(
            (IconData icon) => Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: BnaIcon(
                icon: icon,
                size: 20,
                color: const Color(0xFF495057),
                semanticLabel: 'Grid icon',
              ),
            ),
          )
          .toList(),
    );
  }
}

class _IconThemedDemo extends StatelessWidget {
  const _IconThemedDemo();

  @override
  Widget build(BuildContext context) {
    const List<
      ({IconData icon, String label, String lightColor, String darkColor})
    >
    icons =
        <({IconData icon, String label, String lightColor, String darkColor})>[
          (
            icon: LucideIcons.sun300,
            label: 'Light Theme',
            lightColor: '#FFA500',
            darkColor: '#FFD700',
          ),
          (
            icon: LucideIcons.moon300,
            label: 'Dark Theme',
            lightColor: '#4A5568',
            darkColor: '#E2E8F0',
          ),
          (
            icon: LucideIcons.monitor300,
            label: 'System',
            lightColor: '#2D3748',
            darkColor: '#F7FAFC',
          ),
          (
            icon: LucideIcons.palette300,
            label: 'Custom',
            lightColor: '#E53E3E',
            darkColor: '#FC8181',
          ),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: icons
          .map(
            (
              ({
                IconData icon,
                String label,
                String lightColor,
                String darkColor,
              })
              item,
            ) => Padding(
              padding: EdgeInsets.only(bottom: item == icons.last ? 0 : 16),
              child: Row(
                children: <Widget>[
                  BnaIcon(
                    icon: item.icon,
                    size: 24,
                    lightColor: item.lightColor,
                    darkColor: item.darkColor,
                    semanticLabel: item.label,
                  ),
                  const SizedBox(width: 12),
                  BnaText(item.label),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
