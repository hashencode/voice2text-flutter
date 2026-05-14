import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bna_theme.dart';
import '../widgets/bna_button.dart';
import '../widgets/bna_icon.dart';
import '../widgets/bna_link.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_text.dart';

class BnaLinkComponentPage extends StatelessWidget {
  const BnaLinkComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Link',
      description:
          'A navigation component that handles both internal and external links with customizable browser behavior.',
      children: <Widget>[
        BnaExampleSection(
          title: 'Default',
          surface: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaLink.text(
                'Go to Profile',
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return _openInternalPreview(
                    context,
                    title: 'Profile',
                    route: route,
                  );
                },
              ),
              const SizedBox(height: 12),
              BnaLink.text(
                'Settings',
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return _openInternalPreview(
                    context,
                    title: 'Settings',
                    route: route,
                  );
                },
              ),
              const SizedBox(height: 12),
              BnaLink.text(
                'User Details',
                href: const BnaRouteHref(
                  pathname: '/',
                  params: <String, String>{'id': '123'},
                ),
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return _openInternalPreview(
                    context,
                    title: 'User Details',
                    route: route,
                  );
                },
              ),
            ],
          ),
        ),
        const BnaExampleSection(
          title: 'External',
          surface: false,
          child: _LinkExternalDemo(),
        ),
        const BnaExampleSection(
          title: 'Browser',
          surface: false,
          child: _LinkBrowserDemo(),
        ),
        BnaExampleSection(
          title: 'Custom',
          surface: false,
          child: _LinkCustomDemo(onInternalPreview: _openInternalPreview),
        ),
        BnaExampleSection(
          title: 'Types',
          surface: false,
          child: _LinkTypesDemo(onInternalPreview: _openInternalPreview),
        ),
        BnaExampleSection(
          title: 'Styled',
          surface: false,
          child: _LinkStyledDemo(onInternalPreview: _openInternalPreview),
        ),
        BnaExampleSection(
          title: 'Buttons',
          surface: false,
          child: _LinkButtonsDemo(onInternalPreview: _openInternalPreview),
        ),
      ],
    );
  }

  Future<void> _openInternalPreview(
    BuildContext context, {
    required String title,
    required BnaRouteHref route,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _LinkDestinationPreviewPage(title: title, route: route),
      ),
    );
  }
}

class _LinkExternalDemo extends StatelessWidget {
  const _LinkExternalDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaLink.text('Visit GitHub', href: 'https://github.com'),
        SizedBox(height: 12),
        BnaLink.text('Expo Documentation', href: 'https://expo.dev'),
        SizedBox(height: 12),
        BnaLink.text('React Native Docs', href: 'https://reactnative.dev'),
      ],
    );
  }
}

class _LinkBrowserDemo extends StatelessWidget {
  const _LinkBrowserDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LinkSubsectionTitle('In-App Browser (Default)'),
        SizedBox(height: 8),
        BnaLink.text(
          'Open GitHub in-app',
          href: 'https://github.com',
          browser: BnaLinkBrowser.inApp,
        ),
        SizedBox(height: 6),
        BnaLink.text('Open Expo docs in-app', href: 'https://expo.dev'),
        SizedBox(height: 16),
        _LinkSubsectionTitle('External Browser'),
        SizedBox(height: 8),
        BnaLink.text(
          'Open GitHub externally',
          href: 'https://github.com',
          browser: BnaLinkBrowser.external,
        ),
        SizedBox(height: 6),
        BnaLink.text(
          'Open Expo docs externally',
          href: 'https://expo.dev',
          browser: BnaLinkBrowser.external,
        ),
      ],
    );
  }
}

class _LinkCustomDemo extends StatelessWidget {
  const _LinkCustomDemo({required this.onInternalPreview});

  final Future<void> Function(
    BuildContext context, {
    required String title,
    required BnaRouteHref route,
  })
  onInternalPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaLink(
          href: '/',
          asChild: true,
          onInternalNavigate: (BuildContext context, BnaRouteHref route) {
            return onInternalPreview(context, title: 'Welcome', route: route);
          },
          child: BnaButton(
            onPressed: null,
            icon: LucideIcons.house300,
            child: const Text('Welcome'),
          ),
        ),
        const SizedBox(height: 16),
        const BnaLink(href: 'https://github.com', child: _ExternalLinkCard()),
        const SizedBox(height: 16),
        const BnaLink(
          href: 'mailto:contact@example.com',
          asChild: true,
          child: BnaButton(
            variant: BnaButtonVariant.success,
            icon: LucideIcons.mail300,
            child: Text('Send Email'),
          ),
        ),
      ],
    );
  }
}

class _LinkTypesDemo extends StatelessWidget {
  const _LinkTypesDemo({required this.onInternalPreview});

  final Future<void> Function(
    BuildContext context, {
    required String title,
    required BnaRouteHref route,
  })
  onInternalPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LinkGroup(
          title: 'Internal Navigation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaLink.text(
                'Home Page',
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return onInternalPreview(
                    context,
                    title: 'Home Page',
                    route: route,
                  );
                },
              ),
              const SizedBox(height: 6),
              BnaLink.text(
                'About Us',
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return onInternalPreview(
                    context,
                    title: 'About Us',
                    route: route,
                  );
                },
              ),
              const SizedBox(height: 6),
              BnaLink.text(
                'Product Details',
                href: const BnaRouteHref(
                  pathname: '/',
                  params: <String, String>{'id': '123'},
                ),
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return onInternalPreview(
                    context,
                    title: 'Product Details',
                    route: route,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _LinkGroup(
          title: 'External URLs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaLink.text('Google', href: 'https://google.com'),
              SizedBox(height: 6),
              BnaLink.text('Example Site', href: 'http://example.com'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _LinkGroup(
          title: 'Communication Links',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaLink.text('Send Email', href: 'mailto:hello@example.com'),
              SizedBox(height: 6),
              BnaLink.text('Call Phone', href: 'tel:+1234567890'),
              SizedBox(height: 6),
              BnaLink.text(
                'Email with Subject',
                href: 'mailto:support@company.com?subject=Help Request',
              ),
              SizedBox(height: 6),
              BnaLink.text('Send SMS', href: 'sms:+1234567890'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinkStyledDemo extends StatelessWidget {
  const _LinkStyledDemo({required this.onInternalPreview});

  final Future<void> Function(
    BuildContext context, {
    required String title,
    required BnaRouteHref route,
  })
  onInternalPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LinkGroup(
          title: 'Default Styled',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaLink.text(
                'Default Link Style',
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return onInternalPreview(
                    context,
                    title: 'Default Link Style',
                    route: route,
                  );
                },
              ),
              const SizedBox(height: 6),
              const BnaLink.text('External Link', href: 'https://example.com'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _LinkGroup(
          title: 'Custom Text Styling',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BnaLink(
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return onInternalPreview(
                    context,
                    title: 'Red Bold Link',
                    route: route,
                  );
                },
                child: const BnaText(
                  'Red Bold Link',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              BnaLink(
                href: '/',
                onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                  return onInternalPreview(
                    context,
                    title: 'Green Italic Link',
                    route: route,
                  );
                },
                child: const BnaText(
                  'Green Italic Link',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const BnaLink(
                href: 'https://github.com',
                child: BnaText(
                  'Purple Uppercase',
                  style: TextStyle(
                    color: Color(0xFF7C3AED),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _LinkGroup(
          title: 'Inline Links',
          child: BnaText.rich(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'This is a paragraph with an '),
                BnaLink.inlineSpan(
                  href: '/',
                  label: 'inline link',
                  onInternalNavigate:
                      (BuildContext context, BnaRouteHref route) {
                        return onInternalPreview(
                          context,
                          title: 'Inline Link',
                          route: route,
                        );
                      },
                ),
                const TextSpan(
                  text:
                      ' that flows naturally with the text. You can also have ',
                ),
                BnaLink.inlineSpan(
                  href: 'https://example.com',
                  label: 'external inline links',
                ),
                const TextSpan(text: ' in your content.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkButtonsDemo extends StatelessWidget {
  const _LinkButtonsDemo({required this.onInternalPreview});

  final Future<void> Function(
    BuildContext context, {
    required String title,
    required BnaRouteHref route,
  })
  onInternalPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BnaLink(
              href: '/',
              asChild: true,
              onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                return onInternalPreview(
                  context,
                  title: 'View Profile',
                  route: route,
                );
              },
              child: BnaButton(
                onPressed: null,
                icon: LucideIcons.user300,
                child: const Text('View Profile'),
              ),
            ),
            const SizedBox(height: 12),
            BnaLink(
              href: '/',
              asChild: true,
              onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                return onInternalPreview(
                  context,
                  title: 'Open Settings',
                  route: route,
                );
              },
              child: BnaButton(
                onPressed: null,
                variant: BnaButtonVariant.outline,
                icon: LucideIcons.settings300,
                child: const Text('Open Settings'),
              ),
            ),
            const SizedBox(height: 12),
            const BnaLink(
              href: 'https://github.com',
              browser: BnaLinkBrowser.external,
              asChild: true,
              child: BnaButton(
                onPressed: null,
                variant: BnaButtonVariant.secondary,
                icon: LucideIcons.externalLink300,
                child: Text('Visit GitHub'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            BnaLink(
              href: '/',
              asChild: true,
              onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                return onInternalPreview(
                  context,
                  title: 'Dashboard',
                  route: route,
                );
              },
              child: BnaButton(
                onPressed: null,
                size: BnaButtonSize.sm,
                child: const Text('Dashboard'),
              ),
            ),
            BnaLink(
              href: '/',
              asChild: true,
              onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                return onInternalPreview(context, title: 'Help', route: route);
              },
              child: BnaButton(
                onPressed: null,
                variant: BnaButtonVariant.ghost,
                size: BnaButtonSize.sm,
                child: const Text('Help'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BnaLink(
              href: '/',
              asChild: true,
              onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                return onInternalPreview(
                  context,
                  title: 'Danger Zone',
                  route: route,
                );
              },
              child: BnaButton(
                onPressed: null,
                variant: BnaButtonVariant.destructive,
                size: BnaButtonSize.lg,
                child: const Text('Danger Zone'),
              ),
            ),
            const SizedBox(height: 8),
            BnaLink(
              href: '/',
              asChild: true,
              onInternalNavigate: (BuildContext context, BnaRouteHref route) {
                return onInternalPreview(
                  context,
                  title: 'Success Action',
                  route: route,
                );
              },
              child: BnaButton(
                onPressed: null,
                variant: BnaButtonVariant.success,
                size: BnaButtonSize.lg,
                child: const Text('Success Action'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const BnaLink(
          href: 'mailto:support@example.com',
          asChild: true,
          child: BnaButton(
            onPressed: null,
            variant: BnaButtonVariant.link,
            size: BnaButtonSize.sm,
            child: Text('Contact'),
          ),
        ),
      ],
    );
  }
}

class _ExternalLinkCard extends StatelessWidget {
  const _ExternalLinkCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BnaIcon(
            icon: LucideIcons.externalLink300,
            size: 16,
            color: Colors.white,
            semanticLabel: 'External link icon',
          ),
          SizedBox(width: 8),
          BnaText(
            'External Link',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _LinkSubsectionTitle extends StatelessWidget {
  const _LinkSubsectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return BnaText(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }
}

class _LinkGroup extends StatelessWidget {
  const _LinkGroup({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LinkSubsectionTitle(title),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _LinkDestinationPreviewPage extends StatelessWidget {
  const _LinkDestinationPreviewPage({required this.title, required this.route});

  final String title;
  final BnaRouteHref route;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return BnaShowcaseScaffold(
      title: title,
      description:
          'Internal navigation preview used to verify link interactions on-device in the Flutter showcase.',
      children: <Widget>[
        BnaExampleSection(
          title: 'Path',
          child: SelectableText(
            route.pathname,
            style: BnaShowcaseTextStyles.body(colors),
          ),
        ),
        BnaExampleSection(
          title: 'Resolved Route',
          child: SelectableText(
            route.displayValue,
            style: BnaShowcaseTextStyles.body(colors),
          ),
        ),
        BnaExampleSection(
          title: 'Parameters',
          child: route.params.isEmpty
              ? const Text('No params')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: route.params.entries
                      .map(
                        (MapEntry<String, String> entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('${entry.key}: ${entry.value}'),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
