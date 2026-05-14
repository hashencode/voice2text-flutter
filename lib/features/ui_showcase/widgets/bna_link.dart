import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bna_theme.dart';
import 'bna_button.dart';
import 'bna_showcase_shell.dart';
import 'bna_text.dart';

enum BnaLinkBrowser { inApp, external }

class BnaRouteHref {
  const BnaRouteHref({
    required this.pathname,
    this.params = const <String, String>{},
  });

  final String pathname;
  final Map<String, String> params;

  String get displayValue {
    if (params.isEmpty) {
      return pathname;
    }

    final String query = params.entries
        .map((MapEntry<String, String> entry) => '${entry.key}=${entry.value}')
        .join('&');
    return '$pathname?$query';
  }
}

typedef BnaInternalNavigationCallback =
    FutureOr<void> Function(BuildContext context, BnaRouteHref route);

class BnaLink extends StatelessWidget {
  const BnaLink({
    super.key,
    required this.href,
    this.browser = BnaLinkBrowser.inApp,
    this.child,
    this.label,
    this.asChild = false,
    this.onInternalNavigate,
    this.semanticLabel,
  }) : assert(
         child != null || label != null,
         'Provide either child or label for BnaLink.',
       );

  const BnaLink.text(
    this.label, {
    super.key,
    required this.href,
    this.browser = BnaLinkBrowser.inApp,
    this.asChild = false,
    this.onInternalNavigate,
    this.semanticLabel,
  }) : child = null;

  final Object href;
  final BnaLinkBrowser browser;
  final Widget? child;
  final String? label;
  final bool asChild;
  final BnaInternalNavigationCallback? onInternalNavigate;
  final String? semanticLabel;

  static InlineSpan inlineSpan({
    required Object href,
    required String label,
    BnaLinkBrowser browser = BnaLinkBrowser.inApp,
    BnaInternalNavigationCallback? onInternalNavigate,
    String? semanticLabel,
  }) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: BnaLink.text(
        label,
        href: href,
        browser: browser,
        onInternalNavigate: onInternalNavigate,
        semanticLabel: semanticLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = _buildContent(context);

    return Semantics(
      link: true,
      label: semanticLabel ?? label,
      child: FocusableActionDetector(
        enabled: true,
        mouseCursor: SystemMouseCursors.click,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              unawaited(_handleTap(context));
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: asChild && child is BnaButton
              ? null
              : () => unawaited(_handleTap(context)),
          child: asChild ? content : content,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Widget resolvedContent =
        child ?? BnaText(label!, variant: BnaTextVariant.link);

    if (!asChild || resolvedContent is! BnaButton) {
      return resolvedContent;
    }

    return BnaButton(
      key: resolvedContent.key,
      icon: resolvedContent.icon,
      onPressed: () => unawaited(_handleTap(context)),
      variant: resolvedContent.variant,
      size: resolvedContent.size,
      disabled: resolvedContent.disabled,
      loading: resolvedContent.loading,
      animation: resolvedContent.animation,
      backgroundColor: resolvedContent.backgroundColor,
      foregroundColor: resolvedContent.foregroundColor,
      borderColor: resolvedContent.borderColor,
      borderWidth: resolvedContent.borderWidth,
      borderRadius: resolvedContent.borderRadius,
      gradient: resolvedContent.gradient,
      contentPadding: resolvedContent.contentPadding,
      textStyle: resolvedContent.textStyle,
      minFontSize: resolvedContent.minFontSize,
      child: resolvedContent.child,
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (_isExternalHref(href)) {
      await _openExternal(context);
      return;
    }

    final BnaRouteHref route = _resolveInternalHref(href);
    if (onInternalNavigate != null) {
      await onInternalNavigate!(context, route);
      return;
    }

    if (!context.mounted) {
      return;
    }

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _BnaLinkPreviewPage(route: route),
      ),
    );
  }

  Future<void> _openExternal(BuildContext context) async {
    final Uri uri = Uri.parse(_hrefString(href));
    final bool isNativeAppUri = _isNativeAppUri(uri);

    final LaunchMode preferredMode = switch ((browser, isNativeAppUri)) {
      (_, true) => LaunchMode.externalApplication,
      (BnaLinkBrowser.external, false) => LaunchMode.externalApplication,
      (BnaLinkBrowser.inApp, false) => LaunchMode.inAppBrowserView,
    };

    bool launched = await launchUrl(
      uri,
      mode: preferredMode,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    );

    if (!launched && preferredMode == LaunchMode.inAppBrowserView) {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text('Unable to open ${uri.toString()}')),
      );
    }
  }

  bool _isExternalHref(Object value) {
    if (value is! String) {
      return false;
    }

    return value.startsWith('http://') ||
        value.startsWith('https://') ||
        value.startsWith('mailto:') ||
        value.startsWith('tel:') ||
        value.startsWith('sms:') ||
        value.startsWith('whatsapp:') ||
        value.startsWith('ftp://') ||
        value.startsWith('file://');
  }

  bool _isNativeAppUri(Uri uri) {
    return switch (uri.scheme) {
      'mailto' || 'tel' || 'sms' || 'whatsapp' => true,
      _ => false,
    };
  }

  String _hrefString(Object value) {
    if (value is String) {
      return value;
    }
    throw ArgumentError('External BnaLink href must be a string.');
  }

  BnaRouteHref _resolveInternalHref(Object value) {
    if (value is BnaRouteHref) {
      return value;
    }
    if (value is String) {
      return BnaRouteHref(pathname: value);
    }
    throw ArgumentError('Unsupported internal href: $value');
  }
}

class _BnaLinkPreviewPage extends StatelessWidget {
  const _BnaLinkPreviewPage({required this.route});

  final BnaRouteHref route;

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Internal Route',
      description:
          'A Flutter preview target used to verify that internal BNA links navigate for real inside the showcase app.',
      children: <Widget>[
        BnaExampleSection(
          title: 'Pathname',
          child: SelectableText(
            route.pathname,
            style: BnaShowcaseTextStyles.body(BnaShowcaseColors.of(context)),
          ),
        ),
        BnaExampleSection(
          title: 'Resolved Route',
          child: SelectableText(
            route.displayValue,
            style: BnaShowcaseTextStyles.body(BnaShowcaseColors.of(context)),
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
