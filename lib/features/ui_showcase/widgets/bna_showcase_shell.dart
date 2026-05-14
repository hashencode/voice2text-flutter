import 'package:flutter/material.dart';

import '../bna_theme.dart';

class BnaShowcaseScaffold extends StatelessWidget {
  const BnaShowcaseScaffold({
    super.key,
    required this.title,
    required this.description,
    this.children,
    this.lazyChildren,
    this.leadingLabel,
    this.trailing,
  }) : assert(
         (children == null) != (lazyChildren == null),
         'Provide either children or lazyChildren.',
       );

  final String title;
  final String description;
  final List<Widget>? children;
  final List<WidgetBuilder>? lazyChildren;
  final String? leadingLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final List<Widget> header = _buildHeader(colors);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.text,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: lazyChildren == null
            ? ListView(
                padding: const EdgeInsets.fromLTRB(
                  BnaShowcaseMetrics.pagePadding,
                  8,
                  BnaShowcaseMetrics.pagePadding,
                  32,
                ),
                children: <Widget>[
                  ...header,
                  ...(children ?? const <Widget>[]),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  BnaShowcaseMetrics.pagePadding,
                  8,
                  BnaShowcaseMetrics.pagePadding,
                  32,
                ),
                itemCount: header.length + lazyChildren!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < header.length) {
                    return header[index];
                  }
                  return lazyChildren![index - header.length](context);
                },
              ),
      ),
    );
  }

  List<Widget> _buildHeader(BnaShowcaseColors colors) {
    return <Widget>[
      if (leadingLabel != null) ...<Widget>[
        Text(leadingLabel!, style: BnaShowcaseTextStyles.overline(colors)),
        const SizedBox(height: 10),
      ],
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: BnaShowcaseTextStyles.heading(colors)),
                const SizedBox(height: 10),
                Text(description, style: BnaShowcaseTextStyles.caption(colors)),
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
      const SizedBox(height: 24),
    ];
  }
}

class BnaSurfaceCard extends StatelessWidget {
  const BnaSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.card,
        borderRadius: BorderRadius.circular(BnaShowcaseMetrics.borderRadius),
        border: Border.all(color: colors.border),
        boxShadow: isDark
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: colors.foreground.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class BnaExampleSection extends StatelessWidget {
  const BnaExampleSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.footer,
    this.surface = true,
    this.surfacePadding = const EdgeInsets.all(16),
  });

  final String title;
  final String? description;
  final Widget child;
  final Widget? footer;
  final bool surface;
  final EdgeInsetsGeometry surfacePadding;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: BnaShowcaseMetrics.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: BnaShowcaseTextStyles.subtitle(colors)),
          if (description != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(description!, style: BnaShowcaseTextStyles.caption(colors)),
          ],
          const SizedBox(height: 12),
          if (surface)
            BnaSurfaceCard(padding: surfacePadding, child: child)
          else
            child,
          if (footer != null) ...<Widget>[const SizedBox(height: 8), footer!],
        ],
      ),
    );
  }
}

class BnaStatusPill extends StatelessWidget {
  const BnaStatusPill({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(BnaShowcaseMetrics.corners),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: foregroundColor,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class BnaBulletList extends StatelessWidget {
  const BnaBulletList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colors.textMuted,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: BnaShowcaseTextStyles.body(colors),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
