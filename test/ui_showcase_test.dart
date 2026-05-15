import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/badge_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/button_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/card_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/input_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/link_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_badge.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_button.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_card.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_icon.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_link.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_separator.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_showcase_shell.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_text.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _CapturingUrlLauncher extends UrlLauncherPlatform {
  String? lastUrl;
  PreferredLaunchMode? lastMode;

  @override
  final LinkDelegate? linkDelegate = null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    lastUrl = url;
    lastMode = options.mode;
    return true;
  }
}

void main() {
  late UrlLauncherPlatform originalUrlLauncher;

  setUp(() {
    originalUrlLauncher = UrlLauncherPlatform.instance;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = originalUrlLauncher;
  });

  testWidgets('icon-only button does not render label content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BnaButton(
            size: BnaButtonSize.icon,
            icon: LucideIcons.settings300,
            onPressed: () {},
            child: const Text('Ignored label'),
          ),
        ),
      ),
    );

    expect(find.byIcon(LucideIcons.settings300), findsOneWidget);
    expect(find.text('Ignored label'), findsNothing);
  });

  testWidgets('icon stroke width maps to the closest lucide weight family', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BnaIcon(icon: LucideIcons.zap300, strokeWidth: 1.5),
        ),
      ),
    );

    final Icon icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon?.fontFamily, 'Lucide300');
  });

  testWidgets('input showcase lazily builds lower demo sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BnaInputComponentPage()));
    await tester.pumpAndSettle();

    expect(find.text('Payment Information'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Submit Form'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Payment Information'), findsOneWidget);
  });

  testWidgets('text component adapts custom colors to theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BnaText(
            'Color sample',
            lightColor: '#3b82f6',
            darkColor: '#60a5fa',
          ),
        ),
      ),
    );

    Text lightText = tester.widget<Text>(find.text('Color sample'));
    expect(lightText.style?.color, const Color(0xFF3B82F6));

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: BnaText(
            'Color sample',
            lightColor: '#3b82f6',
            darkColor: '#60a5fa',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    lightText = tester.widget<Text>(find.text('Color sample'));
    expect(lightText.style?.color, const Color(0xFF60A5FA));
  });

  testWidgets('text variants use the requested lighter weights', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              BnaText('Heading', variant: BnaTextVariant.heading),
              BnaText('Title', variant: BnaTextVariant.title),
              BnaText('Subtitle', variant: BnaTextVariant.subtitle),
            ],
          ),
        ),
      ),
    );

    final Text heading = tester.widget<Text>(find.text('Heading'));
    final Text title = tester.widget<Text>(find.text('Title'));
    final Text subtitle = tester.widget<Text>(find.text('Subtitle'));

    expect(heading.style?.fontWeight, FontWeight.w500);
    expect(title.style?.fontWeight, FontWeight.w500);
    expect(subtitle.style?.fontWeight, FontWeight.w500);
  });

  testWidgets('button shrinks text before falling back to wrapping', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 160,
              child: BnaButton(
                onPressed: () {},
                minFontSize: 14,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(fontSize: 24),
                child: const Text('Continue now'),
              ),
            ),
          ),
        ),
      ),
    );

    final Text text = tester.widget<Text>(find.text('Continue now'));
    expect(tester.getSize(find.text('Continue now')).height, lessThan(40));
    expect(text.style?.fontSize, greaterThanOrEqualTo(14));
    expect(text.style?.fontSize, lessThan(24));
  });

  testWidgets('button showcase includes the long label demo section', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BnaButtonComponentPage()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Long Labels'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Long Labels'), findsOneWidget);
    expect(find.text('Continue to account settings'), findsOneWidget);
    expect(find.text('Continue to checkout'), findsOneWidget);
  });

  testWidgets('button wraps only after reaching its minimum font size', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 120,
              child: BnaButton(
                onPressed: () {},
                child: const Text('Continue to checkout'),
              ),
            ),
          ),
        ),
      ),
    );

    final Text text = tester.widget<Text>(find.text('Continue to checkout'));
    expect(
      tester.getSize(find.text('Continue to checkout')).height,
      greaterThan(40),
    );
    expect(text.style?.fontSize, 14);
    expect(text.style?.height, 1.05);
  });

  testWidgets('badge outline variant preserves border and text semantics', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BnaBadge(
            variant: BnaBadgeVariant.outline,
            child: Text('Outline'),
          ),
        ),
      ),
    );

    final DecoratedBox box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(BnaBadge),
        matching: find.byType(DecoratedBox),
      ),
    );
    final BoxDecoration decoration = box.decoration as BoxDecoration;
    final RichText richText = tester.widget<RichText>(find.byType(RichText));

    expect(decoration.color, Colors.transparent);
    expect(decoration.border, isNotNull);
    expect(richText.text.style?.color, const Color(0xFF18181B));
  });

  testWidgets('badge interactive demo removes tags when tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BnaBadgeComponentPage()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Badge / Interactive'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final Finder reactChip = find.text('React');
    expect(reactChip, findsOneWidget);

    await tester.tap(reactChip);
    await tester.pumpAndSettle();

    expect(find.text('React'), findsNothing);
  });

  testWidgets('separator supports vertical orientation defaults', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 60,
            child: BnaSeparator(orientation: BnaSeparatorOrientation.vertical),
          ),
        ),
      ),
    );

    final SizedBox line = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(BnaSeparator),
        matching: find.byType(SizedBox),
      ),
    );
    final DecoratedBox box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(BnaSeparator),
        matching: find.byType(DecoratedBox),
      ),
    );
    final BoxDecoration decoration = box.decoration as BoxDecoration;

    expect(line.width, 1);
    expect(line.height, double.infinity);
    expect(decoration.color, const Color(0xFFC6C6C8));
  });

  testWidgets('card defaults to the configured light card color token', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: BnaCard(child: SizedBox(width: 10, height: 10))),
      ),
    );

    final DecoratedBox card = tester.widget<DecoratedBox>(
      find.byType(DecoratedBox).first,
    );
    final BoxDecoration decoration = card.decoration as BoxDecoration;

    expect(decoration.color, const Color(0xFFFFFFFF));
  });

  testWidgets('showcase scaffold uses the configured light page background', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BnaShowcaseScaffold(
          title: 'Title',
          description: 'Description',
          children: <Widget>[SizedBox.shrink()],
        ),
      ),
    );

    final Scaffold scaffold = tester.widget<Scaffold>(
      find.byType(Scaffold).first,
    );
    expect(scaffold.backgroundColor, const Color(0xFFF5F5F5));
  });

  testWidgets(
    'card showcase lazily builds lower sections and preserves form semantics',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: BnaCardComponentPage()));
      await tester.pumpAndSettle();

      expect(find.text('New Notification'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('With Form'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'john@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'secret123');

      final TextField emailField = tester.widget<TextField>(
        find.byType(TextField).at(0),
      );
      final TextField passwordField = tester.widget<TextField>(
        find.byType(TextField).at(1),
      );

      expect(emailField.controller?.text, 'john@example.com');
      expect(passwordField.controller?.text, 'secret123');
      expect(passwordField.obscureText, isTrue);

      await tester.scrollUntilVisible(
        find.text('Notification'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.scrollUntilVisible(
        find.text('New Notification'),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('New Notification'), findsOneWidget);
      expect(find.byIcon(LucideIcons.bell300), findsOneWidget);
    },
  );

  testWidgets('link opens internal destinations inside the showcase', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BnaLinkComponentPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Resolved Route'), findsOneWidget);
    expect(find.text('/'), findsAtLeastNWidgets(1));
  });

  testWidgets('external link uses in-app browser mode by default', (
    WidgetTester tester,
  ) async {
    final _CapturingUrlLauncher launcher = _CapturingUrlLauncher();
    UrlLauncherPlatform.instance = launcher;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BnaLink.text('Visit GitHub', href: 'https://github.com'),
        ),
      ),
    );

    await tester.tap(find.text('Visit GitHub'));
    await tester.pumpAndSettle();

    expect(launcher.lastUrl, 'https://github.com');
    expect(launcher.lastMode, PreferredLaunchMode.inAppBrowserView);
  });

  testWidgets('asChild button links stay visually enabled and still navigate', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BnaLink(
            href: '/',
            asChild: true,
            child: BnaButton(
              onPressed: null,
              icon: LucideIcons.house300,
              child: const Text('Welcome'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);

    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();

    expect(find.text('Internal Route'), findsOneWidget);
  });

  testWidgets('native app links use external application mode', (
    WidgetTester tester,
  ) async {
    final _CapturingUrlLauncher launcher = _CapturingUrlLauncher();
    UrlLauncherPlatform.instance = launcher;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BnaLink.text('Call Phone', href: 'tel:+1234567890'),
        ),
      ),
    );

    await tester.tap(find.text('Call Phone'));
    await tester.pumpAndSettle();

    expect(launcher.lastUrl, 'tel:+1234567890');
    expect(launcher.lastMode, PreferredLaunchMode.externalApplication);
  });
}
