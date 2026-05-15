import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/bna_badge.dart';
import '../widgets/bna_icon.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_text.dart';

class BnaBadgeComponentPage extends StatefulWidget {
  const BnaBadgeComponentPage({super.key});

  @override
  State<BnaBadgeComponentPage> createState() => _BnaBadgeComponentPageState();
}

class _BnaBadgeComponentPageState extends State<BnaBadgeComponentPage> {
  final List<String> _tags = <String>['React', 'TypeScript', 'Expo', 'Mobile'];
  String _selectedCategory = 'All';

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BnaCompareScaffold(
      title: 'Badge',
      description:
          'Small labels and state indicators matched to the RN source variants, custom content, and interactive examples.',
      children: <Widget>[
        const BnaCompareSection(
          title: 'Badge / Default',
          child: _BadgeDefaultDemo(),
        ),
        const BnaCompareSection(
          title: 'Badge / Icons',
          child: _BadgeIconsDemo(),
        ),
        const BnaCompareSection(
          title: 'Badge / Notifications',
          child: _BadgeNotificationsDemo(),
        ),
        const BnaCompareSection(
          title: 'Badge / Styled',
          child: _BadgeStyledDemo(),
        ),
        BnaCompareSection(
          title: 'Badge / Interactive',
          child: _BadgeInteractiveDemo(
            tags: _tags,
            selectedCategory: _selectedCategory,
            onRemoveTag: _removeTag,
            onCategorySelected: (String category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        ),
        const BnaCompareSection(
          title: 'Badge / Sizes',
          child: _BadgeSizesDemo(),
        ),
        const BnaCompareSection(
          title: 'Badge / Status',
          child: _BadgeStatusDemo(),
        ),
      ],
    );
  }
}

class _BadgeDefaultDemo extends StatelessWidget {
  const _BadgeDefaultDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const <Widget>[
        BnaBadge(child: Text('Default')),
        BnaBadge(variant: BnaBadgeVariant.secondary, child: Text('Secondary')),
        BnaBadge(
          variant: BnaBadgeVariant.destructive,
          child: Text('Destructive'),
        ),
        BnaBadge(variant: BnaBadgeVariant.outline, child: Text('Outline')),
        BnaBadge(variant: BnaBadgeVariant.success, child: Text('Success')),
      ],
    );
  }
}

class _BadgeIconsDemo extends StatelessWidget {
  const _BadgeIconsDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const <Widget>[
        BnaBadge(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BnaIcon(
                icon: LucideIcons.star300,
                size: 13,
                strokeWidth: 2,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              Text('Featured'),
            ],
          ),
        ),
        BnaBadge(
          variant: BnaBadgeVariant.success,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BnaIcon(
                icon: LucideIcons.check300,
                size: 13,
                strokeWidth: 2,
                color: Colors.black,
              ),
              SizedBox(width: 4),
              Text('Verified', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        BnaBadge(
          variant: BnaBadgeVariant.destructive,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BnaIcon(
                icon: LucideIcons.triangleAlert300,
                size: 13,
                strokeWidth: 2,
                color: Colors.black,
              ),
              SizedBox(width: 4),
              Text('Alert', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        BnaBadge(
          variant: BnaBadgeVariant.outline,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BnaIcon(
                icon: LucideIcons.bell300,
                size: 13,
                strokeWidth: 2,
                color: Colors.black,
              ),
              SizedBox(width: 4),
              Text('Notification'),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeNotificationsDemo extends StatelessWidget {
  const _BadgeNotificationsDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            _BadgeNotificationCounter(
              label: 'Messages',
              badge: BnaBadge(
                minWidth: 20,
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                textStyle: TextStyle(fontSize: 12, height: 1),
                child: Text('3'),
              ),
            ),
            _BadgeNotificationCounter(
              label: 'Notifications',
              badge: BnaBadge(
                variant: BnaBadgeVariant.destructive,
                width: 20,
                height: 20,
                padding: EdgeInsets.zero,
                borderRadius: 999,
                textStyle: TextStyle(fontSize: 12, height: 1),
                child: Text('12'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            _BadgeNotificationCounter(
              label: 'Online',
              badge: BnaBadge(
                variant: BnaBadgeVariant.success,
                width: 8,
                height: 8,
                padding: EdgeInsets.zero,
                borderRadius: 4,
                semanticLabel: 'Online status indicator',
                child: SizedBox.shrink(),
              ),
            ),
            _BadgeNotificationCounter(
              label: 'Away',
              badge: BnaBadge(
                width: 8,
                height: 8,
                padding: EdgeInsets.zero,
                borderRadius: 4,
                backgroundColor: Color(0xFFF59E0B),
                semanticLabel: 'Away status indicator',
                child: SizedBox.shrink(),
              ),
            ),
            _BadgeNotificationCounter(
              label: 'Offline',
              badge: BnaBadge(
                variant: BnaBadgeVariant.outline,
                width: 8,
                height: 8,
                padding: EdgeInsets.zero,
                borderRadius: 4,
                semanticLabel: 'Offline status indicator',
                child: SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgeNotificationCounter extends StatelessWidget {
  const _BadgeNotificationCounter({required this.label, required this.badge});

  final String label;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[Text(label), const SizedBox(width: 8), badge],
    );
  }
}

class _BadgeStyledDemo extends StatelessWidget {
  const _BadgeStyledDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const <Widget>[
        BnaBadge(
          backgroundColor: Color(0xFF8B5CF6),
          borderRadius: 16,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          child: Text('Purple'),
        ),
        BnaBadge(
          backgroundColor: Color(0xFF06B6D4),
          borderRadius: 4,
          textStyle: TextStyle(color: Colors.white, fontSize: 13),
          child: Text('Cyan'),
        ),
        BnaBadge(
          backgroundColor: Color(0xFFF97316),
          borderRadius: 20,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          child: Text('Orange'),
        ),
        BnaBadge(
          backgroundColor: Color(0xFFEC4899),
          borderRadius: 12,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          child: Text('Pink'),
        ),
        BnaBadge(
          variant: BnaBadgeVariant.outline,
          borderColor: Color(0xFF10B981),
          borderWidth: 2,
          borderRadius: 8,
          textStyle: TextStyle(
            color: Color(0xFF10B981),
            fontWeight: FontWeight.w500,
          ),
          child: Text('Green'),
        ),
      ],
    );
  }
}

class _BadgeInteractiveDemo extends StatelessWidget {
  const _BadgeInteractiveDemo({
    required this.tags,
    required this.selectedCategory,
    required this.onRemoveTag,
    required this.onCategorySelected,
  });

  final List<String> tags;
  final String selectedCategory;
  final ValueChanged<String> onRemoveTag;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    const List<String> categories = <String>[
      'All',
      'Work',
      'Personal',
      'Important',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const BnaText(
          'Tags (tap to remove):',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (String tag) => _BadgePressable(
                  onTap: () => onRemoveTag(tag),
                  child: BnaBadge(
                    variant: BnaBadgeVariant.secondary,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(tag),
                        const SizedBox(width: 4),
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: Center(
                            child: BnaIcon(
                              icon: LucideIcons.x300,
                              size: 11,
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        const BnaText(
          'Categories:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map(
                (String category) => _BadgePressable(
                  onTap: () => onCategorySelected(category),
                  child: Opacity(
                    opacity: selectedCategory == category ? 1 : 0.7,
                    child: BnaBadge(
                      variant: selectedCategory == category
                          ? BnaBadgeVariant.defaultStyle
                          : BnaBadgeVariant.outline,
                      child: Text(category),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        const BnaText(
          'Filter Options:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const <Widget>[
            _BadgePressable(
              onTap: _noop,
              child: BnaBadge(
                variant: BnaBadgeVariant.success,
                child: Text('Active'),
              ),
            ),
            _BadgePressable(
              onTap: _noop,
              child: BnaBadge(
                variant: BnaBadgeVariant.outline,
                child: Text('Completed'),
              ),
            ),
            _BadgePressable(
              onTap: _noop,
              child: BnaBadge(
                variant: BnaBadgeVariant.destructive,
                child: Text('Archived'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgeSizesDemo extends StatelessWidget {
  const _BadgeSizesDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BadgeSizeRow(
          label: 'Extra Small:',
          children: <Widget>[
            BnaBadge(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              textStyle: TextStyle(fontSize: 11),
              child: Text('XS'),
            ),
            BnaBadge(
              variant: BnaBadgeVariant.success,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              textStyle: TextStyle(fontSize: 11),
              child: Text('New'),
            ),
          ],
        ),
        SizedBox(height: 16),
        _BadgeSizeRow(
          label: 'Small:',
          children: <Widget>[
            BnaBadge(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textStyle: TextStyle(fontSize: 12),
              child: Text('Small'),
            ),
            BnaBadge(
              variant: BnaBadgeVariant.secondary,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textStyle: TextStyle(fontSize: 12),
              child: Text('Beta'),
            ),
          ],
        ),
        SizedBox(height: 16),
        _BadgeSizeRow(
          label: 'Default:',
          children: <Widget>[
            BnaBadge(child: Text('Default')),
            BnaBadge(variant: BnaBadgeVariant.outline, child: Text('Outline')),
          ],
        ),
        SizedBox(height: 16),
        _BadgeSizeRow(
          label: 'Large:',
          children: <Widget>[
            BnaBadge(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              child: Text('Large'),
            ),
            BnaBadge(
              variant: BnaBadgeVariant.destructive,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              child: Text('Important'),
            ),
          ],
        ),
        SizedBox(height: 16),
        _BadgeSizeRow(
          label: 'Extra Large:',
          children: <Widget>[
            BnaBadge(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              borderRadius: 12,
              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              child: Text('XL Badge'),
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgeSizeRow extends StatelessWidget {
  const _BadgeSizeRow({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        ...children,
      ],
    );
  }
}

class _BadgeStatusDemo extends StatelessWidget {
  const _BadgeStatusDemo();

  @override
  Widget build(BuildContext context) {
    final List<({String name, String status})> users =
        <({String name, String status})>[
          (name: 'John Doe', status: 'online'),
          (name: 'Jane Smith', status: 'away'),
          (name: 'Bob Johnson', status: 'offline'),
          (name: 'Alice Brown', status: 'busy'),
        ];
    final List<({String id, String status})> orders =
        <({String id, String status})>[
          (id: '#1234', status: 'pending'),
          (id: '#1235', status: 'processing'),
          (id: '#1236', status: 'shipped'),
          (id: '#1237', status: 'delivered'),
          (id: '#1238', status: 'cancelled'),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _BadgeStatusSectionTitle('User Status'),
        Column(
          children: users
              .map(
                (({String name, String status}) user) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(user.name)),
                      _statusBadge(user.status),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        const _BadgeStatusSectionTitle('Order Status'),
        Column(
          children: orders
              .map(
                (({String id, String status}) order) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text('Order ${order.id}')),
                      _statusBadge(order.status),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        const _BadgeStatusSectionTitle('Priority Levels'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const <Widget>[
            BnaBadge(
              backgroundColor: Color(0xFFEF4444),
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              child: Text('High Priority'),
            ),
            BnaBadge(
              backgroundColor: Color(0xFFF59E0B),
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              child: Text('Medium Priority'),
            ),
            BnaBadge(
              backgroundColor: Color(0xFF10B981),
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              child: Text('Low Priority'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return switch (status) {
      'online' => const BnaBadge(
        variant: BnaBadgeVariant.success,
        child: Text('Online'),
      ),
      'away' => const BnaBadge(
        backgroundColor: Color(0xFFF59E0B),
        textStyle: TextStyle(color: Colors.white),
        child: Text('Away'),
      ),
      'busy' => const BnaBadge(
        variant: BnaBadgeVariant.destructive,
        child: Text('Busy'),
      ),
      'offline' => const BnaBadge(
        variant: BnaBadgeVariant.outline,
        child: Text('Offline'),
      ),
      'pending' => const BnaBadge(
        backgroundColor: Color(0xFF6B7280),
        textStyle: TextStyle(color: Colors.white),
        child: Text('Pending'),
      ),
      'processing' => const BnaBadge(
        backgroundColor: Color(0xFF3B82F6),
        textStyle: TextStyle(color: Colors.white),
        child: Text('Processing'),
      ),
      'shipped' => const BnaBadge(
        backgroundColor: Color(0xFF8B5CF6),
        textStyle: TextStyle(color: Colors.white),
        child: Text('Shipped'),
      ),
      'delivered' => const BnaBadge(
        variant: BnaBadgeVariant.success,
        child: Text('Delivered'),
      ),
      'cancelled' => const BnaBadge(
        variant: BnaBadgeVariant.destructive,
        child: Text('Cancelled'),
      ),
      _ => const BnaBadge(
        variant: BnaBadgeVariant.outline,
        child: Text('Unknown'),
      ),
    };
  }
}

class _BadgeStatusSectionTitle extends StatelessWidget {
  const _BadgeStatusSectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _BadgePressable extends StatefulWidget {
  const _BadgePressable({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_BadgePressable> createState() => _BadgePressableState();
}

class _BadgePressableState extends State<_BadgePressable> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) {
      return;
    }
    setState(() {
      _pressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: _pressed ? 0.7 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}

void _noop() {}
