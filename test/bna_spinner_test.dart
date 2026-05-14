import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice2text_flutter/features/ui_showcase/pages/spinner_component_page.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_button.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_spinner.dart';

void main() {
  testWidgets('spinner uses bars as the default variant', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: BnaSpinner(showLabel: true))),
    );

    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('loading button blocks taps and renders button spinner', (
    WidgetTester tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BnaButton(
            loading: true,
            onPressed: () {
              pressed = true;
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(BnaButton));
    await tester.pump();

    expect(pressed, isFalse);
    expect(find.byType(BnaButtonSpinner), findsOneWidget);
    expect(find.text('Save'), findsNothing);
  });

  testWidgets(
    'spinner page removes circle variant and shows section dividers',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BnaSpinnerComponentPage()),
      );
      await tester.pump();

      expect(find.text('Circle'), findsNothing);
      expect(find.byType(Divider), findsWidgets);
    },
  );

  testWidgets('loading overlay uses blur and centers visible label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              SizedBox.expand(),
              BnaLoadingOverlay(visible: true, label: 'Loading content...'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('Loading content...'), findsOneWidget);
  });
}
