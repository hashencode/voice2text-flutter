import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice2text_flutter/app/app.dart';

void main() {
  testWidgets('app boots on recording page', (WidgetTester tester) async {
    await tester.pumpWidget(const Voice2TextApp());
    expect(find.text('录音'), findsOneWidget);
    expect(find.textContaining('当前状态'), findsOneWidget);
  });

  testWidgets('recording page has expected entry actions', (WidgetTester tester) async {
    await tester.pumpWidget(const Voice2TextApp());
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.byIcon(Icons.text_snippet_outlined), findsOneWidget);
    expect(find.byIcon(Icons.list), findsOneWidget);
    expect(find.text('开始录音'), findsOneWidget);
    expect(find.text('停止并保存'), findsOneWidget);
    expect(find.textContaining('自动转写:'), findsOneWidget);
  });
}
