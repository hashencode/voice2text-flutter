import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bna_theme.dart';
import '../widgets/bna_avoid_keyboard.dart';
import '../widgets/bna_button.dart';
import '../widgets/bna_input.dart';
import '../widgets/bna_showcase_shell.dart';

class BnaAvoidKeyboardComponentPage extends StatelessWidget {
  const BnaAvoidKeyboardComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'AvoidKeyboard',
      description:
          'Keyboard-safe spacing helper for bottom-pinned inputs, forms, playgrounds, and chat-style layouts.',
      lazyChildren: <WidgetBuilder>[
        (_) => const _KeyboardDemoSection(
          title: 'Basic Keyboard Avoidance',
          child: _BasicAvoidKeyboardDemo(),
        ),
        (_) => const _KeyboardDemoSection(
          title: 'With Extra Offset',
          child: _OffsetAvoidKeyboardDemo(),
        ),
        (_) => const _KeyboardDemoSection(
          title: 'Custom Animation Duration',
          child: _DurationAvoidKeyboardDemo(),
        ),
        (_) => const _KeyboardDemoSection(
          title: 'Form',
          child: _FormAvoidKeyboardDemo(),
        ),
        (_) => const _KeyboardDemoSection(
          title: 'Playground',
          child: _PlaygroundAvoidKeyboardDemo(),
        ),
        (_) => const _KeyboardDemoSection(
          title: 'Chat',
          child: _ChatAvoidKeyboardDemo(),
        ),
      ],
    );
  }
}

class _KeyboardDemoSection extends StatelessWidget {
  const _KeyboardDemoSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BnaExampleSection(
      title: title,
      surfacePadding: EdgeInsets.zero,
      child: child,
    );
  }
}

class _DemoViewport extends StatelessWidget {
  const _DemoViewport({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BnaShowcaseMetrics.borderRadius),
        child: child,
      ),
    );
  }
}

class _BasicAvoidKeyboardDemo extends StatelessWidget {
  const _BasicAvoidKeyboardDemo();

  @override
  Widget build(BuildContext context) {
    return _DemoViewport(
      height: 360,
      child: Builder(
        builder: (BuildContext context) {
          final double keyboardHeight = MediaQuery.of(
            context,
          ).viewInsets.bottom;
          final bool isVisible = keyboardHeight > 0;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Basic Keyboard Avoidance',
                  style: BnaShowcaseTextStyles.title(
                    BnaShowcaseColors.of(context),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tap the input below to see the keyboard avoidance in action. The content will smoothly move up to keep the input visible.',
                  style: BnaShowcaseTextStyles.body(
                    BnaShowcaseColors.of(context),
                  ).copyWith(color: BnaShowcaseColors.of(context).textMuted),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Keyboard Height: ${keyboardHeight.toStringAsFixed(0)}',
                      ),
                      Text('Keyboard Visible: ${isVisible ? 'Yes' : 'No'}'),
                      const Text('Animation Duration: 250ms'),
                    ],
                  ),
                ),
                const BnaInput(
                  label: 'Message',
                  placeholder: 'Type your message here...',
                ),
                const BnaAvoidKeyboard(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OffsetAvoidKeyboardDemo extends StatelessWidget {
  const _OffsetAvoidKeyboardDemo();

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return _DemoViewport(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'With Extra Offset',
              style: BnaShowcaseTextStyles.title(colors),
            ),
            const SizedBox(height: 20),
            Text(
              'This example adds 40px of extra spacing above the keyboard for better visual separation.',
              style: BnaShowcaseTextStyles.body(
                colors,
              ).copyWith(color: colors.textMuted),
            ),
            const Spacer(),
            const BnaInput(
              label: 'Message',
              placeholder: 'Notice the extra space above keyboard...',
            ),
            const BnaAvoidKeyboard(offset: 40),
          ],
        ),
      ),
    );
  }
}

class _DurationAvoidKeyboardDemo extends StatefulWidget {
  const _DurationAvoidKeyboardDemo();

  @override
  State<_DurationAvoidKeyboardDemo> createState() =>
      _DurationAvoidKeyboardDemoState();
}

class _DurationAvoidKeyboardDemoState
    extends State<_DurationAvoidKeyboardDemo> {
  int _duration = 0;

  static const List<(String, int)> _durations = <(String, int)>[
    ('Default', 0),
    ('Fast (100ms)', 100),
    ('Slow (500ms)', 500),
    ('Very Slow (1000ms)', 1000),
  ];

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return _DemoViewport(
      height: 340,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Custom Animation Duration',
              style: BnaShowcaseTextStyles.title(colors),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose different animation speeds to see how it affects the keyboard avoidance.',
              style: BnaShowcaseTextStyles.body(
                colors,
              ).copyWith(color: colors.textMuted),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _durations.map(((String, int) item) {
                return BnaButton(
                  variant: _duration == item.$2
                      ? BnaButtonVariant.defaultStyle
                      : BnaButtonVariant.secondary,
                  size: BnaButtonSize.sm,
                  onPressed: () {
                    setState(() {
                      _duration = item.$2;
                    });
                  },
                  child: Text(item.$1),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Current duration: ${250 + _duration}ms total',
              style: BnaShowcaseTextStyles.caption(colors),
            ),
            const Spacer(),
            const BnaInput(
              label: 'Test Input',
              placeholder: 'Tap to test animation speed...',
            ),
            BnaAvoidKeyboard(extraDurationMs: _duration),
          ],
        ),
      ),
    );
  }
}

class _FormAvoidKeyboardDemo extends StatefulWidget {
  const _FormAvoidKeyboardDemo();

  @override
  State<_FormAvoidKeyboardDemo> createState() => _FormAvoidKeyboardDemoState();
}

class _FormAvoidKeyboardDemoState extends State<_FormAvoidKeyboardDemo> {
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{
        'first': TextEditingController(),
        'last': TextEditingController(),
        'email': TextEditingController(),
        'confirmEmail': TextEditingController(),
        'phone': TextEditingController(),
        'password': TextEditingController(),
        'confirmPassword': TextEditingController(),
      };
  final Map<String, String> _errors = <String, String>{};

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return _DemoViewport(
      height: 540,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Registration Form',
                  style: BnaShowcaseTextStyles.title(colors),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill out the form below. Notice how the keyboard avoidance keeps inputs visible.',
                  style: BnaShowcaseTextStyles.body(
                    colors,
                  ).copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: <Widget>[
                  _FormInput(
                    label: 'First Name',
                    placeholder: 'Enter your first name',
                    icon: LucideIcons.user300,
                    controller: _controllers['first']!,
                    error: _errors['first'],
                  ),
                  const SizedBox(height: 16),
                  _FormInput(
                    label: 'Last Name',
                    placeholder: 'Enter your last name',
                    icon: LucideIcons.user300,
                    controller: _controllers['last']!,
                    error: _errors['last'],
                  ),
                  const SizedBox(height: 16),
                  _FormInput(
                    label: 'Email',
                    placeholder: 'Enter your email',
                    icon: LucideIcons.mail300,
                    controller: _controllers['email']!,
                    error: _errors['email'],
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _FormInput(
                    label: 'Confirm',
                    placeholder: 'Confirm your email',
                    icon: LucideIcons.mail300,
                    controller: _controllers['confirmEmail']!,
                    error: _errors['confirmEmail'],
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _FormInput(
                    label: 'Phone',
                    placeholder: 'Enter your phone number',
                    icon: LucideIcons.phone300,
                    controller: _controllers['phone']!,
                    error: _errors['phone'],
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _FormInput(
                    label: 'Password',
                    placeholder: 'Create a password',
                    icon: LucideIcons.lock300,
                    controller: _controllers['password']!,
                    error: _errors['password'],
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _FormInput(
                    label: 'Confirm',
                    placeholder: 'Confirm password',
                    icon: LucideIcons.lock300,
                    controller: _controllers['confirmPassword']!,
                    error: _errors['confirmPassword'],
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  BnaButton(
                    onPressed: _handleSubmit,
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: BnaShowcaseTextStyles.caption(colors),
                  ),
                ],
              ),
            ),
          ),
          const BnaAvoidKeyboard(),
        ],
      ),
    );
  }

  void _handleSubmit() {
    setState(() {
      _errors.clear();
      if (_controllers['first']!.text.trim().isEmpty) {
        _errors['first'] = 'Name is required';
      }
      final String email = _controllers['email']!.text.trim();
      if (email.isEmpty) {
        _errors['email'] = 'Email is required';
      } else if (!email.contains('@')) {
        _errors['email'] = 'Please enter a valid email';
      }
      final String password = _controllers['password']!.text.trim();
      if (password.isEmpty) {
        _errors['password'] = 'Password is required';
      } else if (password.length < 6) {
        _errors['password'] = 'Password must be at least 6 characters';
      }
      if (_controllers['confirmPassword']!.text != password) {
        _errors['confirmPassword'] = 'Passwords do not match';
      }
    });
  }
}

class _FormInput extends StatelessWidget {
  const _FormInput({
    required this.label,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.error,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String placeholder;
  final IconData icon;
  final TextEditingController controller;
  final String? error;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BnaInput(
      label: label,
      placeholder: placeholder,
      icon: icon,
      controller: controller,
      error: error,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}

class _PlaygroundAvoidKeyboardDemo extends StatefulWidget {
  const _PlaygroundAvoidKeyboardDemo();

  @override
  State<_PlaygroundAvoidKeyboardDemo> createState() =>
      _PlaygroundAvoidKeyboardDemoState();
}

class _PlaygroundAvoidKeyboardDemoState
    extends State<_PlaygroundAvoidKeyboardDemo> {
  final TextEditingController _messageController = TextEditingController();
  int _offset = 20;
  int _duration = 0;
  bool _showStats = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isVisible = keyboardHeight > 0;
    const List<int> offsets = <int>[0, 10, 20, 40, 60];
    const List<int> durations = <int>[0, 100, 250, 500];

    return _DemoViewport(
      height: 520,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'AvoidKeyboard Playground',
                    style: BnaShowcaseTextStyles.title(colors),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Test different configurations and see real-time keyboard stats.',
                    style: BnaShowcaseTextStyles.body(
                      colors,
                    ).copyWith(color: colors.textMuted),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(LucideIcons.settings300, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Show Keyboard Stats')),
                        Switch.adaptive(
                          value: _showStats,
                          onChanged: (bool value) {
                            setState(() {
                              _showStats = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_showStats) ...<Widget>[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                LucideIcons.keyboard300,
                                size: 16,
                                color: isVisible
                                    ? colors.green
                                    : colors.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Keyboard Status',
                                style: BnaShowcaseTextStyles.subtitle(colors),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Visible: ${isVisible ? 'Yes' : 'No'}'),
                          Text(
                            'Height: ${keyboardHeight.toStringAsFixed(0)}px',
                          ),
                          Text('Animation Duration: ${250 + _duration}ms'),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Offset Configuration',
                    style: BnaShowcaseTextStyles.subtitle(colors),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Extra space above keyboard: ${_offset}px',
                    style: BnaShowcaseTextStyles.caption(colors),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: offsets.map((int value) {
                      return BnaButton(
                        size: BnaButtonSize.sm,
                        variant: _offset == value
                            ? BnaButtonVariant.defaultStyle
                            : BnaButtonVariant.secondary,
                        onPressed: () {
                          setState(() {
                            _offset = value;
                          });
                        },
                        child: Text('${value}px'),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Animation Duration',
                    style: BnaShowcaseTextStyles.subtitle(colors),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Extra animation time: ${_duration}ms',
                    style: BnaShowcaseTextStyles.caption(colors),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: durations.map((int value) {
                      return BnaButton(
                        size: BnaButtonSize.sm,
                        variant: _duration == value
                            ? BnaButtonVariant.defaultStyle
                            : BnaButtonVariant.secondary,
                        onPressed: () {
                          setState(() {
                            _duration = value;
                          });
                        },
                        child: Text(value == 0 ? 'Default' : '${value}ms'),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Code Example',
                    style: BnaShowcaseTextStyles.subtitle(colors),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.border),
                    ),
                    child: Text(
                      '<AvoidKeyboard offset={$_offset} duration={$_duration} />',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.card,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(LucideIcons.smartphone300, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Test Input',
                      style: BnaShowcaseTextStyles.subtitle(colors),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BnaInput(
                  controller: _messageController,
                  placeholder: 'Tap here to test keyboard avoidance...',
                  variant: BnaInputVariant.outline,
                  type: BnaInputType.textarea,
                  rows: 3,
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: BnaButton(
                        variant: BnaButtonVariant.secondary,
                        size: BnaButtonSize.sm,
                        onPressed: () {
                          setState(() {
                            _messageController.clear();
                          });
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BnaButton(
                        size: BnaButtonSize.sm,
                        onPressed: () {
                          setState(() {
                            _messageController.text =
                                'This is a test message to see how the keyboard avoidance works with different configurations!';
                          });
                        },
                        child: const Text('Fill'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BnaAvoidKeyboard(
            offset: _offset.toDouble(),
            extraDurationMs: _duration,
          ),
        ],
      ),
    );
  }
}

class _ChatAvoidKeyboardDemo extends StatefulWidget {
  const _ChatAvoidKeyboardDemo();

  @override
  State<_ChatAvoidKeyboardDemo> createState() => _ChatAvoidKeyboardDemoState();
}

class _ChatAvoidKeyboardDemoState extends State<_ChatAvoidKeyboardDemo> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = <_ChatMessage>[
    _ChatMessage(
      text: 'Hey! How are you doing?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    _ChatMessage(
      text: 'Hi there! I\'m doing great, thanks for asking!',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    _ChatMessage(
      text: 'That\'s wonderful to hear! Any exciting plans for today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    _ChatMessage(
      text: 'Actually yes! I\'m working on some new Flutter components.',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];
  Timer? _replyTimer;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleMessageChanged);
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    _messageController.removeListener(_handleMessageChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return _DemoViewport(
      height: 500,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Chat Demo', style: BnaShowcaseTextStyles.title(colors)),
                const SizedBox(height: 4),
                Text(
                  'Real-time chat with keyboard avoidance',
                  style: BnaShowcaseTextStyles.caption(colors),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final _ChatMessage message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: const BoxConstraints(maxWidth: 260),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser ? colors.blue : colors.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser
                                ? Colors.white
                                : colors.foreground,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: message.isUser
                                ? Colors.white70
                                : colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.card,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: BnaInput(
                    controller: _messageController,
                    placeholder: 'Type a message...',
                    variant: BnaInputVariant.outline,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _handleSend(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 12),
                BnaButton(
                  size: BnaButtonSize.icon,
                  variant: _messageController.text.trim().isNotEmpty
                      ? BnaButtonVariant.success
                      : BnaButtonVariant.outline,
                  onPressed: _handleSend,
                  child: const Icon(LucideIcons.sendHorizontal300, size: 20),
                ),
              ],
            ),
          ),
          const BnaAvoidKeyboard(),
        ],
      ),
    );
  }

  void _handleSend() {
    final String text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        _ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _messageController.clear();
    });
    _scrollToBottom();

    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      const List<String> responses = <String>[
        'That sounds interesting!',
        'Tell me more about that.',
        'Cool! How is it going?',
        'Nice work!',
      ];
      setState(() {
        _messages.add(
          _ChatMessage(
            text: responses[_messages.length % responses.length],
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _handleMessageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime time) {
    final int hour = time.hour == 0
        ? 12
        : (time.hour > 12 ? time.hour - 12 : time.hour);
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
}
