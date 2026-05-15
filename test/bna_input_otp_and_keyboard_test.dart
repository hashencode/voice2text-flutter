import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_avoid_keyboard.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_input.dart';
import 'package:voice2text_flutter/features/ui_showcase/widgets/bna_input_otp.dart';

void main() {
  testWidgets('input otp filters non-digits and fires completion', (
    WidgetTester tester,
  ) async {
    String value = '';
    String? completedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: <Widget>[
                  BnaInputOtp(
                    value: value,
                    onChanged: (String nextValue) {
                      setState(() {
                        value = nextValue;
                      });
                    },
                    onComplete: (String nextValue) {
                      completedValue = nextValue;
                    },
                  ),
                  Text('completed:${completedValue ?? 'none'}'),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '12a34b56');
    await tester.pump();

    expect(find.text('completed:123456'), findsOneWidget);
  });

  testWidgets('input otp disables the hidden text field when disabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: BnaInputOtp(value: '123', disabled: true)),
      ),
    );

    final TextField field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enabled, isFalse);
  });

  testWidgets('avoid keyboard grows to match keyboard inset and offset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 120)),
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[BnaAvoidKeyboard(offset: 40)],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.getSize(find.byType(AnimatedContainer)).height, 160);
  });

  testWidgets('input forwards submit actions to callback', (
    WidgetTester tester,
  ) async {
    String? submittedValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BnaInput(
            label: 'Compose',
            placeholder: 'Type a message...',
            onSubmitted: (String value) {
              submittedValue = value;
            },
            textInputAction: TextInputAction.send,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hello world');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();

    expect(submittedValue, 'hello world');
  });
}
