import 'package:flutter/material.dart';

import '../bna_theme.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_tabs.dart';

class BnaTabsComponentPage extends StatelessWidget {
  const BnaTabsComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return BnaShowcaseScaffold(
      title: 'Tabs',
      leadingLabel: 'BNA UI / Components',
      description:
          'A tabbed navigation component with horizontal and vertical layouts, disabled states, and swipeable content.',
      trailing: BnaStatusPill(
        label: '已迁移',
        backgroundColor: colors.green.withValues(alpha: 0.16),
        foregroundColor: colors.green,
      ),
      children: const <Widget>[
        BnaExampleSection(
          title: 'Default',
          description:
              'Matches the RN default demo, including horizontal trigger overflow and content switching.',
          surface: false,
          child: _DefaultTabsDemo(),
        ),
        BnaExampleSection(
          title: 'Disabled',
          description: 'Disabled tabs keep their visual state and block taps.',
          surface: false,
          child: _DisabledTabsDemo(),
        ),
        BnaExampleSection(
          title: 'Styled',
          description:
              'Controlled tabs with per-tab colors and a dynamic list background.',
          surface: false,
          child: _StyledTabsDemo(),
        ),
        BnaExampleSection(
          title: 'Vertical',
          description: 'Vertical rail layout with icon-only tab triggers.',
          surface: false,
          child: _VerticalTabsDemo(),
        ),
      ],
    );
  }
}

class _DefaultTabsDemo extends StatelessWidget {
  const _DefaultTabsDemo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 400,
        child: BnaTabs(
          defaultValue: 'account',
          tabs: const <BnaTabItem>[
            BnaTabItem(
              value: 'account',
              label: Text('Account'),
              child: _DefaultTabContent(
                title: 'Account Settings',
                body: 'Manage your account information and preferences here.',
              ),
            ),
            BnaTabItem(
              value: 'followers',
              label: Text('Followers'),
              child: _DefaultTabContent(
                title: 'Followers',
                body: 'Manage your followers information and preferences here.',
              ),
            ),
            BnaTabItem(
              value: 'following',
              label: Text('Following'),
              child: _DefaultTabContent(
                title: 'Following',
                body: 'Manage your following information and preferences here.',
              ),
            ),
            BnaTabItem(
              value: 'password',
              label: Text('Password'),
              child: _DefaultTabContent(
                title: 'Password Settings',
                body:
                    'Change your password and security settings preferences here.',
              ),
            ),
            BnaTabItem(
              value: 'settings',
              label: Text('Settings'),
              child: _DefaultTabContent(
                title: 'General Settings',
                body: 'Configure your application preferences and options.',
              ),
            ),
            BnaTabItem(
              value: 'more',
              label: Text('More'),
              child: _DefaultTabContent(
                title: 'More',
                body: 'Configure your application preferences and options.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisabledTabsDemo extends StatelessWidget {
  const _DisabledTabsDemo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 400,
        child: BnaTabs(
          defaultValue: 'available',
          tabs: const <BnaTabItem>[
            BnaTabItem(
              value: 'available',
              label: Text('Available'),
              child: _PaddedTabContent(
                child: _InfoContent(
                  title: 'Available Features',
                  body: 'These features are currently available to you.',
                ),
              ),
            ),
            BnaTabItem(
              value: 'pending',
              label: Text('Pending'),
              child: _PaddedTabContent(
                child: _InfoContent(
                  title: 'Pending Features',
                  body:
                      'These features are being processed and will be available soon.',
                ),
              ),
            ),
            BnaTabItem(
              value: 'premium',
              disabled: true,
              label: Text('Premium'),
              child: _PaddedTabContent(
                child: _InfoContent(
                  title: 'Premium Features',
                  body: 'Upgrade to access premium features.',
                ),
              ),
            ),
            BnaTabItem(
              value: 'enterprise',
              disabled: true,
              label: Text('Enterprise'),
              child: _PaddedTabContent(
                child: _InfoContent(
                  title: 'Enterprise Features',
                  body: 'Contact sales for enterprise features.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyledTabsDemo extends StatefulWidget {
  const _StyledTabsDemo();

  @override
  State<_StyledTabsDemo> createState() => _StyledTabsDemoState();
}

class _StyledTabsDemoState extends State<_StyledTabsDemo> {
  String _value = 'design';

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = switch (_value) {
      'design' => const Color(0xFF3B82F6),
      'development' => const Color(0xFF10B981),
      _ => const Color(0xFFF59E0B),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 400,
        child: BnaTabs(
          value: _value,
          onValueChange: (String value) {
            setState(() {
              _value = value;
            });
          },
          listBackgroundColor: backgroundColor,
          listBorderRadius: BorderRadius.circular(8),
          listShadows: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          tabs: const <BnaTabItem>[
            BnaTabItem(
              value: 'design',
              label: Text('Design'),
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B82F6),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: _StyledTabCard(
                backgroundColor: Color(0xFFEFF6FF),
                titleColor: Color(0xFF1E40AF),
                bodyColor: Color(0xFF1E40AF),
                title: 'Design Phase',
                body:
                    'Create wireframes, mockups, and design systems for your project.',
              ),
            ),
            BnaTabItem(
              value: 'development',
              label: Text('Development'),
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: _StyledTabCard(
                backgroundColor: Color(0xFFECFDF5),
                titleColor: Color(0xFF047857),
                bodyColor: Color(0xFF047857),
                title: 'Development Phase',
                body:
                    'Build and implement the features based on the design specifications.',
              ),
            ),
            BnaTabItem(
              value: 'testing',
              label: Text('Testing'),
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFFF59E0B),
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: _StyledTabCard(
                backgroundColor: Color(0xFFFFFBEB),
                titleColor: Color(0xFF92400E),
                bodyColor: Color(0xFF92400E),
                title: 'Testing Phase',
                body: 'Perform quality assurance and user acceptance testing.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalTabsDemo extends StatelessWidget {
  const _VerticalTabsDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: BnaTabs(
        defaultValue: 'profile',
        orientation: BnaTabsOrientation.vertical,
        tabs: const <BnaTabItem>[
          BnaTabItem(
            value: 'profile',
            label: Text('🧑‍💼'),
            child: _VerticalTabContent(
              title: 'Profile Information',
              body: 'Update your personal information and profile picture.',
            ),
          ),
          BnaTabItem(
            value: 'security',
            label: Text('🫆'),
            child: _VerticalTabContent(
              title: 'Security Settings',
              body: 'Manage two-factor authentication and login security.',
            ),
          ),
          BnaTabItem(
            value: 'notifications',
            label: Text('🔔'),
            child: _VerticalTabContent(
              title: 'Notification Preferences',
              body: 'Configure how and when you receive notifications.',
            ),
          ),
          BnaTabItem(
            value: 'billing',
            label: Text('💰'),
            child: _VerticalTabContent(
              title: 'Billing & Subscription',
              body: 'Manage your subscription and payment methods.',
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultTabContent extends StatelessWidget {
  const _DefaultTabContent({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _PaddedTabContent(
      child: _InfoContent(title: title, body: body, horizontalPadding: 16),
    );
  }
}

class _VerticalTabContent extends StatelessWidget {
  const _VerticalTabContent({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _PaddedTabContent(
      child: _InfoContent(title: title, body: body, horizontalPadding: 16),
    );
  }
}

class _PaddedTabContent extends StatelessWidget {
  const _PaddedTabContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 16), child: child);
  }
}

class _InfoContent extends StatelessWidget {
  const _InfoContent({
    required this.title,
    required this.body,
    this.horizontalPadding,
  });

  final String title;
  final String body;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final EdgeInsetsGeometry padding = horizontalPadding == null
        ? const EdgeInsets.all(16)
        : EdgeInsets.symmetric(horizontal: horizontalPadding!);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: BnaShowcaseTextStyles.title(colors)),
          const SizedBox(height: 8),
          Text(body, style: BnaShowcaseTextStyles.body(colors)),
        ],
      ),
    );
  }
}

class _StyledTabCard extends StatelessWidget {
  const _StyledTabCard({
    required this.backgroundColor,
    required this.titleColor,
    required this.bodyColor,
    required this.title,
    required this.body,
  });

  final Color backgroundColor;
  final Color titleColor;
  final Color bodyColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _PaddedTabContent(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: TextStyle(
                  color: bodyColor,
                  fontSize: BnaShowcaseMetrics.fontSize,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
