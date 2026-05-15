import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_tabs.dart';

void main() {
  testWidgets('tabs default value selects the matching content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BnaTabs(
            defaultValue: 'followers',
            tabs: const <BnaTabItem>[
              BnaTabItem(
                value: 'account',
                label: Text('Account'),
                child: Text('Account content'),
              ),
              BnaTabItem(
                value: 'followers',
                label: Text('Followers'),
                child: Text('Followers content'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Followers content'), findsOneWidget);
    expect(find.text('Account content'), findsNothing);
  });

  testWidgets('disabled tabs ignore direct taps', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BnaTabs(
            defaultValue: 'available',
            tabs: const <BnaTabItem>[
              BnaTabItem(
                value: 'available',
                label: Text('Available'),
                child: Text('Available content'),
              ),
              BnaTabItem(
                value: 'premium',
                label: Text('Premium'),
                disabled: true,
                child: Text('Premium content'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Premium'));
    await tester.pumpAndSettle();

    expect(find.text('Available content'), findsOneWidget);
    expect(find.text('Premium content'), findsNothing);
  });

  testWidgets('tapping an enabled tab switches the visible content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: BnaTabs(
              defaultValue: 'account',
              tabs: const <BnaTabItem>[
                BnaTabItem(
                  value: 'account',
                  label: Text('Account'),
                  child: Text('Account content'),
                ),
                BnaTabItem(
                  value: 'followers',
                  label: Text('Followers'),
                  child: Text('Followers content'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Followers'));
    await tester.pumpAndSettle();

    expect(find.text('Followers content'), findsOneWidget);
    expect(find.text('Account content'), findsNothing);
  });

  testWidgets('horizontal swipe advances to the next tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: BnaTabs(
              defaultValue: 'account',
              tabs: const <BnaTabItem>[
                BnaTabItem(
                  value: 'account',
                  label: Text('Account'),
                  child: SizedBox(height: 80, child: Text('Account content')),
                ),
                BnaTabItem(
                  value: 'followers',
                  label: Text('Followers'),
                  child: SizedBox(height: 80, child: Text('Followers content')),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.text('Account content'), const Offset(-120, 0));
    await tester.pumpAndSettle();

    expect(find.text('Followers content'), findsOneWidget);
  });
}
