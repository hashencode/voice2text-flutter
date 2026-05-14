import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bna_theme.dart';
import '../data/bna_components.dart';
import '../widgets/bna_input.dart';
import '../widgets/bna_showcase_shell.dart';
import 'button_component_page.dart';
import 'card_component_page.dart';
import 'component_placeholder_page.dart';
import 'input_component_page.dart';
import 'icon_component_page.dart';
import 'link_component_page.dart';
import 'spinner_component_page.dart';
import 'text_component_page.dart';

class BnaUiLibraryPage extends StatefulWidget {
  const BnaUiLibraryPage({super.key});

  @override
  State<BnaUiLibraryPage> createState() => _BnaUiLibraryPageState();
}

class _BnaUiLibraryPageState extends State<BnaUiLibraryPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final List<BnaComponentDefinition> visibleComponents = bnaComponents.where((
      BnaComponentDefinition component,
    ) {
      final String query = _query.trim().toLowerCase();
      if (query.isEmpty) {
        return true;
      }
      return component.name.toLowerCase().contains(query) ||
          component.description.toLowerCase().contains(query);
    }).toList();
    final int migratedCount = bnaComponents.where((
      BnaComponentDefinition component,
    ) {
      return component.status == BnaComponentStatus.migrated;
    }).length;

    return BnaShowcaseScaffold(
      title: 'Components',
      leadingLabel: 'BNA UI / Docs',
      description:
          'Here you can find all the components available in the library. The Flutter port starts with the highest-value primitives and expands incrementally.',
      children: <Widget>[
        BnaSurfaceCard(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              BnaStatusPill(
                label: '${bnaComponents.length} components',
                backgroundColor: colors.primary.withValues(alpha: 0.12),
                foregroundColor: colors.text,
              ),
              BnaStatusPill(
                label: '$migratedCount migrated',
                backgroundColor: colors.green.withValues(alpha: 0.16),
                foregroundColor: colors.green,
              ),
              BnaStatusPill(
                label: '${bnaComponents.length - migratedCount} pending',
                backgroundColor: colors.textMuted.withValues(alpha: 0.14),
                foregroundColor: colors.text,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BnaExampleSection(
          title: 'Search',
          description:
              'Filter the source library before opening each component detail page.',
          child: BnaInput(
            label: 'Search',
            placeholder: 'Button, Input, Sheet...',
            icon: LucideIcons.search300,
            onChanged: (String value) {
              setState(() {
                _query = value;
              });
            },
          ),
        ),
        BnaExampleSection(
          title: 'Component List',
          description:
              'Every item is clickable. Migrated components open live Flutter demos; the rest open a migration placeholder with notes.',
          child: Column(
            children: List<Widget>.generate(visibleComponents.length, (
              int index,
            ) {
              final BnaComponentDefinition component = visibleComponents[index];
              final bool migrated =
                  component.status == BnaComponentStatus.migrated;

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openComponent(component),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: index == visibleComponents.length - 1
                          ? BorderSide.none
                          : BorderSide(color: colors.border),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: migrated
                              ? colors.green.withValues(alpha: 0.14)
                              : colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          migrated
                              ? LucideIcons.badgeCheck300
                              : LucideIcons.package300,
                          size: 18,
                          color: migrated ? colors.green : colors.text,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    component.name,
                                    style: BnaShowcaseTextStyles.body(
                                      colors,
                                    ).copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                BnaStatusPill(
                                  label: migrated ? '已迁移' : '待迁移',
                                  backgroundColor: migrated
                                      ? colors.green.withValues(alpha: 0.16)
                                      : colors.textMuted.withValues(
                                          alpha: 0.14,
                                        ),
                                  foregroundColor: migrated
                                      ? colors.green
                                      : colors.text,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              component.description,
                              style: BnaShowcaseTextStyles.caption(colors),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Icon(
                          LucideIcons.chevronRight300,
                          size: 18,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const BnaExampleSection(
          title: 'Migration Plan',
          description:
              'After Button and Input, the next phases should reduce upstream dependency risk.',
          child: BnaBulletList(
            items: <String>[
              'Phase 1: Text, Card, Badge, Spinner, Separator. These are low-risk primitives that unlock most visual demos.',
              'Phase 2: Tabs, Accordion, Sheet, Popover, BottomSheet. This establishes navigation and overlay patterns.',
              'Phase 3: Checkbox, Radio, Switch, Picker, Date Picker, Input OTP. This completes the form-control family.',
              'Phase 4: Audio, Camera, Gallery, MediaPicker, charts. These need native capability work and should come last.',
            ],
          ),
        ),
      ],
    );
  }

  void _openComponent(BnaComponentDefinition component) {
    final Widget page = switch (component.slug) {
      'button' => const BnaButtonComponentPage(),
      'card' => const BnaCardComponentPage(),
      'icon' => const BnaIconComponentPage(),
      'input' => const BnaInputComponentPage(),
      'link' => const BnaLinkComponentPage(),
      'spinner' => const BnaSpinnerComponentPage(),
      'text' => const BnaTextComponentPage(),
      _ => BnaComponentPlaceholderPage(component: component),
    };

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}
