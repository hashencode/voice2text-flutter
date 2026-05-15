import 'package:flutter/material.dart';

class BnaAvoidKeyboard extends StatelessWidget {
  const BnaAvoidKeyboard({
    super.key,
    this.offset = 0,
    this.extraDurationMs = 0,
  });

  final double offset;
  final int extraDurationMs;

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = keyboardHeight > 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 250 + extraDurationMs),
      curve: isKeyboardVisible ? Curves.easeOut : Curves.easeIn,
      height: isKeyboardVisible ? keyboardHeight + offset : 0,
    );
  }
}
