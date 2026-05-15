import 'package:flutter/material.dart';

import '../bna_theme.dart';
import '../widgets/bna_button.dart';
import '../widgets/bna_input_otp.dart';
import '../widgets/bna_showcase_shell.dart';

class BnaInputOtpComponentPage extends StatelessWidget {
  const BnaInputOtpComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Input OTP',
      description:
          'One-time password entry with focus-aware slots, validation, masking, separators, and disabled states.',
      lazyChildren: <WidgetBuilder>[
        (_) => const _OtpSection(title: 'Default', child: _DefaultOtpDemo()),
        (_) => const _OtpSection(title: 'Disabled', child: _DisabledOtpDemo()),
        (_) => const _OtpSection(title: 'Error', child: _ErrorOtpDemo()),
        (_) => const _OtpSection(title: 'Lengths', child: _LengthsOtpDemo()),
        (_) => const _OtpSection(title: 'Masked', child: _MaskedOtpDemo()),
        (_) => const _OtpSection(title: 'Cursor', child: _CursorOtpDemo()),
        (_) =>
            const _OtpSection(title: 'Separator', child: _SeparatorOtpDemo()),
        (_) => const _OtpSection(title: 'Styled', child: _StyledOtpDemo()),
      ],
    );
  }
}

class _OtpSection extends StatelessWidget {
  const _OtpSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BnaExampleSection(
      title: title,
      surface: false,
      child: Center(child: child),
    );
  }
}

class _DefaultOtpDemo extends StatefulWidget {
  const _DefaultOtpDemo();

  @override
  State<_DefaultOtpDemo> createState() => _DefaultOtpDemoState();
}

class _DefaultOtpDemoState extends State<_DefaultOtpDemo> {
  String _otp = '';
  String _status = 'Waiting for 6 digits';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BnaInputOtp(
          value: _otp,
          onChanged: (String value) {
            setState(() {
              _otp = value;
              _status = value.length == 6
                  ? 'Ready to submit'
                  : 'Waiting for 6 digits';
            });
          },
          onComplete: (String value) {
            setState(() {
              _status = 'OTP Complete: $value';
            });
          },
        ),
        const SizedBox(height: 12),
        Text(_status),
      ],
    );
  }
}

class _DisabledOtpDemo extends StatefulWidget {
  const _DisabledOtpDemo();

  @override
  State<_DisabledOtpDemo> createState() => _DisabledOtpDemoState();
}

class _DisabledOtpDemoState extends State<_DisabledOtpDemo> {
  String _otp = '123';
  bool _disabled = true;

  @override
  Widget build(BuildContext context) {
    final BnaButtonVariant buttonVariant = _disabled
        ? BnaButtonVariant.defaultStyle
        : BnaButtonVariant.outline;

    return Column(
      children: <Widget>[
        const Text(
          'Disabled State',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Toggle the button below to enable or disable the input',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        BnaInputOtp(
          value: _otp,
          disabled: _disabled,
          onChanged: (String value) {
            setState(() {
              _otp = value;
            });
          },
        ),
        const SizedBox(height: 16),
        BnaButton(
          variant: buttonVariant,
          size: BnaButtonSize.sm,
          onPressed: () {
            setState(() {
              _disabled = !_disabled;
            });
          },
          child: Text(_disabled ? 'Enable Input' : 'Disable Input'),
        ),
        if (!_disabled) ...<Widget>[
          const SizedBox(height: 12),
          Text('Current value: $_otp', style: const TextStyle(fontSize: 12)),
        ],
      ],
    );
  }
}

class _ErrorOtpDemo extends StatefulWidget {
  const _ErrorOtpDemo();

  @override
  State<_ErrorOtpDemo> createState() => _ErrorOtpDemoState();
}

class _ErrorOtpDemoState extends State<_ErrorOtpDemo> {
  String _otp = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Enter Verification Code',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Try entering 111111 or 000000 to see error state',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        BnaInputOtp(
          value: _otp,
          error: _error,
          onChanged: (String value) {
            setState(() {
              _otp = value;
              _error = _validationErrorFor(value);
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BnaButton(
              variant: BnaButtonVariant.outline,
              size: BnaButtonSize.sm,
              onPressed: () {
                setState(() {
                  _error =
                      'Verification code has expired. Please request a new one.';
                });
              },
              child: const Text('Simulate Error'),
            ),
            const SizedBox(width: 12),
            BnaButton(
              variant: BnaButtonVariant.outline,
              size: BnaButtonSize.sm,
              onPressed: () {
                setState(() {
                  _otp = '';
                  _error = '';
                });
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }

  String _validationErrorFor(String value) {
    if (value.length == 6 && (value == '111111' || value == '000000')) {
      return 'Invalid verification code. Please try again.';
    }
    return '';
  }
}

class _LengthsOtpDemo extends StatefulWidget {
  const _LengthsOtpDemo();

  @override
  State<_LengthsOtpDemo> createState() => _LengthsOtpDemoState();
}

class _LengthsOtpDemoState extends State<_LengthsOtpDemo> {
  String _otp4 = '';
  String _otp6 = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          '4 Digits',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          length: 4,
          value: _otp4,
          onChanged: (String value) {
            setState(() {
              _otp4 = value;
            });
          },
        ),
        const SizedBox(height: 20),
        const Text(
          '6 Digits (Default)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _otp6,
          onChanged: (String value) {
            setState(() {
              _otp6 = value;
            });
          },
        ),
      ],
    );
  }
}

class _MaskedOtpDemo extends StatefulWidget {
  const _MaskedOtpDemo();

  @override
  State<_MaskedOtpDemo> createState() => _MaskedOtpDemoState();
}

class _MaskedOtpDemoState extends State<_MaskedOtpDemo> {
  String _normalOtp = '';
  String _maskedOtp = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Normal (Visible Digits)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _normalOtp,
          onChanged: (String value) {
            setState(() {
              _normalOtp = value;
            });
          },
        ),
        if (_normalOtp.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            'Current value: $_normalOtp',
            style: const TextStyle(fontSize: 12),
          ),
        ],
        const SizedBox(height: 24),
        const Text(
          'Masked (Hidden Digits)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _maskedOtp,
          masked: true,
          onChanged: (String value) {
            setState(() {
              _maskedOtp = value;
            });
          },
        ),
        if (_maskedOtp.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            'Current value: $_maskedOtp',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ],
    );
  }
}

class _CursorOtpDemo extends StatefulWidget {
  const _CursorOtpDemo();

  @override
  State<_CursorOtpDemo> createState() => _CursorOtpDemoState();
}

class _CursorOtpDemoState extends State<_CursorOtpDemo> {
  String _otpWithCursor = '';
  String _otpWithoutCursor = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'With Cursor (Default)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _otpWithCursor,
          onChanged: (String value) {
            setState(() {
              _otpWithCursor = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Without Cursor',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _otpWithoutCursor,
          showCursor: false,
          onChanged: (String value) {
            setState(() {
              _otpWithoutCursor = value;
            });
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Tap on the inputs above to see the difference in cursor behavior',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _SeparatorOtpDemo extends StatefulWidget {
  const _SeparatorOtpDemo();

  @override
  State<_SeparatorOtpDemo> createState() => _SeparatorOtpDemoState();
}

class _SeparatorOtpDemoState extends State<_SeparatorOtpDemo> {
  String _otp1 = '';
  String _otp2 = '';
  String _otp3 = '';

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return Column(
      children: <Widget>[
        const Text(
          'With Dash Separator',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _otp1,
          separator: Text(
            '-',
            style: TextStyle(fontSize: 18, color: colors.textMuted),
          ),
          onChanged: (String value) {
            setState(() {
              _otp1 = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'With Dot Separator',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _otp2,
          separator: Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.textMuted,
            ),
          ),
          onChanged: (String value) {
            setState(() {
              _otp2 = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'With Custom Separator',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          length: 4,
          value: _otp3,
          separator: Container(width: 8, height: 2, color: colors.textMuted),
          onChanged: (String value) {
            setState(() {
              _otp3 = value;
            });
          },
        ),
      ],
    );
  }
}

class _StyledOtpDemo extends StatefulWidget {
  const _StyledOtpDemo();

  @override
  State<_StyledOtpDemo> createState() => _StyledOtpDemoState();
}

class _StyledOtpDemoState extends State<_StyledOtpDemo> {
  String _otp1 = '';
  String _otp2 = '';
  String _otp3 = '';

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    const Color success = Color(0xFF10B981);
    const Color purple = Color(0xFF8B5CF6);

    return Column(
      children: <Widget>[
        const Text(
          'Rounded Style',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          value: _otp1,
          slotStyle: BnaInputOtpSlotStyle(
            borderRadius: 25,
            borderWidth: 2,
            borderColor: colors.primary,
          ),
          onChanged: (String value) {
            setState(() {
              _otp1 = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Success Theme',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          length: 4,
          value: _otp2,
          slotStyle: const BnaInputOtpSlotStyle(
            borderRadius: 8,
            borderColor: success,
            backgroundColor: Color(0x1A10B981),
          ),
          onChanged: (String value) {
            setState(() {
              _otp2 = value;
            });
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Large & Purple',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        BnaInputOtp(
          length: 4,
          gap: 12,
          value: _otp3,
          slotStyle: const BnaInputOtpSlotStyle(
            width: 70,
            height: 70,
            borderRadius: 12,
            borderWidth: 2,
            borderColor: purple,
            backgroundColor: Color(0x0D8B5CF6),
          ),
          onChanged: (String value) {
            setState(() {
              _otp3 = value;
            });
          },
        ),
      ],
    );
  }
}
