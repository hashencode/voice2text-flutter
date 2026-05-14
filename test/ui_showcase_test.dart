import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/input_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_button.dart';

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
}
