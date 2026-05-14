import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/button_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/card_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/input_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_button.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_card.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_showcase_shell.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_text.dart';

void main() {
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
}
