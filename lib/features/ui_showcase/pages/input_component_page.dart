import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bna_theme.dart';
import '../widgets/bna_button.dart';
import '../widgets/bna_input.dart';
import '../widgets/bna_showcase_shell.dart';

class BnaInputComponentPage extends StatelessWidget {
  const BnaInputComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Input',
      description:
          'A styled text input component with label, validation, icons, and grouped layouts.',
      lazyChildren: <WidgetBuilder>[
        (_) => const BnaExampleSection(
          title: 'Default',
          surface: false,
          child: BnaInput(
            label: 'Username',
            placeholder: 'Enter your username',
            icon: LucideIcons.user300,
          ),
        ),
        (_) => const BnaExampleSection(
          title: 'Icons',
          surface: false,
          child: Column(
            children: <Widget>[
              BnaInput(
                label: 'Email',
                placeholder: 'john@example.com',
                icon: LucideIcons.mail300,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              BnaInput(
                label: 'Password',
                placeholder: 'Enter password',
                icon: LucideIcons.lock300,
                obscureText: true,
              ),
              SizedBox(height: 16),
              BnaInput(
                label: 'Search',
                placeholder: 'Search anything...',
                icon: LucideIcons.search300,
              ),
              SizedBox(height: 16),
              BnaInput(
                label: 'Phone',
                placeholder: '+1 (555) 123-4567',
                icon: LucideIcons.phone300,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        (_) => const BnaExampleSection(
          title: 'Variants',
          surface: false,
          child: Column(
            children: <Widget>[
              BnaInput(
                variant: BnaInputVariant.filled,
                label: 'Username',
                placeholder: 'Filled variant',
                icon: LucideIcons.user300,
              ),
              SizedBox(height: 16),
              BnaInput(
                variant: BnaInputVariant.outline,
                label: 'Email',
                placeholder: 'Outline variant',
                icon: LucideIcons.mail300,
              ),
            ],
          ),
        ),
        (_) => const _ValidationSection(),
        (_) => const _RightComponentsSection(),
        (_) => const BnaExampleSection(
          title: 'Disabled',
          surface: false,
          child: Column(
            children: <Widget>[
              BnaInput(
                label: 'Username',
                placeholder: 'This input is disabled',
                icon: LucideIcons.user300,
                disabled: true,
              ),
              SizedBox(height: 16),
              BnaInput(
                label: 'Email',
                icon: LucideIcons.mail300,
                disabled: true,
                placeholder: 'john@example.com',
              ),
            ],
          ),
        ),
        (_) => const BnaExampleSection(
          title: 'Grouped',
          surface: false,
          child: BnaGroupedInput(
            title: 'Personal Information',
            children: <Widget>[
              BnaGroupedInputItem(
                label: 'Name',
                placeholder: 'John Doe',
                icon: LucideIcons.user300,
              ),
              BnaGroupedInputItem(
                label: 'Email',
                placeholder: 'john@example.com',
                icon: LucideIcons.mail300,
                keyboardType: TextInputType.emailAddress,
              ),
              BnaGroupedInputItem(
                label: 'Phone',
                placeholder: '+1 (555) 123-4567',
                icon: LucideIcons.phone300,
                keyboardType: TextInputType.phone,
              ),
              BnaGroupedInputItem(
                label: 'Address',
                placeholder: '123 Main St',
                icon: LucideIcons.mapPin300,
              ),
            ],
          ),
        ),
        (_) => const _FormSection(),
      ],
    );
  }
}

class _ValidationSection extends StatefulWidget {
  const _ValidationSection();

  @override
  State<_ValidationSection> createState() => _ValidationSectionState();
}

class _ValidationSectionState extends State<_ValidationSection> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String emailError =
        _emailController.text.isNotEmpty && !_emailController.text.contains('@')
        ? 'Please enter a valid email address'
        : '';
    final String passwordError =
        _passwordController.text.isNotEmpty &&
            _passwordController.text.length < 6
        ? 'Password must be at least 6 characters'
        : '';

    return BnaExampleSection(
      title: 'Validation',
      surface: false,
      child: Column(
        children: <Widget>[
          BnaInput(
            label: 'Email',
            placeholder: 'Enter your email',
            icon: LucideIcons.mail300,
            controller: _emailController,
            onChanged: (_) => setState(() {}),
            error: emailError.isEmpty ? null : emailError,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          BnaInput(
            label: 'Password',
            placeholder: 'Enter password',
            icon: LucideIcons.lock300,
            controller: _passwordController,
            onChanged: (_) => setState(() {}),
            error: passwordError.isEmpty ? null : passwordError,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}

class _RightComponentsSection extends StatefulWidget {
  const _RightComponentsSection();

  @override
  State<_RightComponentsSection> createState() =>
      _RightComponentsSectionState();
}

class _RightComponentsSectionState extends State<_RightComponentsSection> {
  static const String _apiKeyValue = 'sk-1234567890abcdef';
  bool _showPassword = false;
  bool _copied = false;
  Timer? _copiedTimer;

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return BnaExampleSection(
      title: 'Right Components',
      surface: false,
      child: Column(
        children: <Widget>[
          BnaInput(
            label: 'Search',
            placeholder: 'Search with button...',
            icon: LucideIcons.search300,
            rightComponent: BnaButton(
              size: BnaButtonSize.icon,
              variant: BnaButtonVariant.secondary,
              onPressed: () => _showSnack(context, 'Go pressed'),
              child: const Text(
                'Go',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BnaInput(
            label: 'Password',
            placeholder: 'Toggle visibility',
            obscureText: !_showPassword,
            rightComponent: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? LucideIcons.eye300 : LucideIcons.eyeOff300,
                size: 22,
                color: colors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),
          BnaInput(
            label: 'API Key',
            placeholder: _apiKeyValue,
            rightComponent: GestureDetector(
              onTap: () => _copyApiKey(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(LucideIcons.copy300, size: 18, color: colors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    _copied ? 'Copied!' : 'Copy',
                    style: BnaShowcaseTextStyles.caption(colors),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyApiKey(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _apiKeyValue));
    _copiedTimer?.cancel();
    setState(() {
      _copied = true;
    });
    _showSnack(context, 'API key copied');
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  void _showSnack(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(label)));
  }
}

class _FormSection extends StatefulWidget {
  const _FormSection();

  @override
  State<_FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<_FormSection> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  Map<String, String> _errors = <String, String>{};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return BnaExampleSection(
      title: 'Form',
      surface: false,
      child: Column(
        children: <Widget>[
          BnaGroupedInput(
            title: 'Account Information',
            children: <Widget>[
              BnaGroupedInputItem(
                label: 'First Name',
                placeholder: 'John',
                icon: LucideIcons.user300,
                controller: _firstNameController,
                error: _errors['firstName'],
                onChanged: (_) => setState(() {}),
              ),
              BnaGroupedInputItem(
                label: 'Last Name',
                placeholder: 'Doe',
                icon: LucideIcons.user300,
                controller: _lastNameController,
                onChanged: (_) => setState(() {}),
              ),
              BnaGroupedInputItem(
                label: 'Email',
                placeholder: 'john@example.com',
                icon: LucideIcons.mail300,
                controller: _emailController,
                error: _errors['email'],
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              BnaGroupedInputItem(
                label: 'Phone',
                placeholder: '+1 (555) 123-4567',
                icon: LucideIcons.phone300,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 24),
          BnaInput(
            label: 'Password',
            placeholder: 'Create password',
            icon: LucideIcons.lock300,
            controller: _passwordController,
            error: _errors['password'],
            obscureText: !_showPassword,
            variant: BnaInputVariant.outline,
            rightComponent: GestureDetector(
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              child: Icon(
                _showPassword ? LucideIcons.eye300 : LucideIcons.eyeOff300,
                size: 22,
                color: colors.textMuted,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          BnaInput(
            label: 'Confirm Password',
            placeholder: 'Confirm password',
            icon: LucideIcons.lock300,
            controller: _confirmPasswordController,
            error: _errors['confirmPassword'],
            obscureText: !_showConfirmPassword,
            variant: BnaInputVariant.outline,
            rightComponent: GestureDetector(
              onTap: () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
              child: Icon(
                _showConfirmPassword
                    ? LucideIcons.eye300
                    : LucideIcons.eyeOff300,
                size: 22,
                color: colors.textMuted,
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          BnaGroupedInput(
            title: 'Payment Information',
            children: <Widget>[
              BnaGroupedInputItem(
                label: 'Card Number',
                placeholder: '1234 5678 9012 3456',
                icon: LucideIcons.creditCard300,
                controller: _cardController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              BnaGroupedInputItem(
                label: 'Expiry Date',
                placeholder: 'MM/YY',
                icon: LucideIcons.calendar300,
                controller: _expiryController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              BnaGroupedInputItem(
                label: 'CVV',
                placeholder: '123',
                controller: _cvvController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: BnaButton(
              onPressed: () => _submitForm(context),
              child: const Text('Submit Form'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(BuildContext context) {
    final Map<String, String> nextErrors = <String, String>{};

    if (_firstNameController.text.trim().isEmpty) {
      nextErrors['firstName'] = 'First name is required';
    }
    if (_emailController.text.trim().isEmpty) {
      nextErrors['email'] = 'Email is required';
    } else if (!_emailController.text.contains('@')) {
      nextErrors['email'] = 'Invalid email format';
    }
    if (_passwordController.text.isEmpty) {
      nextErrors['password'] = 'Password is required';
    } else if (_passwordController.text.length < 6) {
      nextErrors['password'] = 'Password must be at least 6 characters';
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      nextErrors['confirmPassword'] = 'Passwords do not match';
    }

    setState(() {
      _errors = nextErrors;
    });

    if (nextErrors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }
}
