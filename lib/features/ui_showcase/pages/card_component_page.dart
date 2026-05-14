import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../bna_theme.dart';
import '../widgets/bna_button.dart';
import '../widgets/bna_card.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_text.dart';

class BnaCardComponentPage extends StatelessWidget {
  const BnaCardComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Card',
      description:
          'Content containers with structured header, content, and footer composition.',
      lazyChildren: <WidgetBuilder>[
        (_) => BnaExampleSection(
          title: 'Default',
          surface: false,
          child: const _CardWidth(child: _DemoCard()),
        ),
        (_) => const BnaExampleSection(
          title: 'Simple',
          surface: false,
          child: _CardWidth(child: _SimpleCard()),
        ),
        (_) => BnaExampleSection(
          title: 'With Image',
          surface: false,
          child: const _CardWidth(child: _ImageCard()),
        ),
        (_) => const BnaExampleSection(
          title: 'With Form',
          surface: false,
          child: _CardWidth(child: _CardFormDemo()),
        ),
        (_) => const BnaExampleSection(
          title: 'Pricing',
          surface: false,
          child: _PricingCards(),
        ),
        (_) => const BnaExampleSection(
          title: 'Stats',
          surface: false,
          child: _StatsCards(),
        ),
        (_) => BnaExampleSection(
          title: 'Notification',
          surface: false,
          child: const _CardWidth(maxWidth: 400, child: _NotificationCard()),
        ),
      ],
    );
  }
}

class _CardWidth extends StatelessWidget {
  const _CardWidth({required this.child, this.maxWidth});

  final Widget child;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = maxWidth == null
            ? constraints.maxWidth
            : constraints.maxWidth.clamp(0, maxWidth!).toDouble();

        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard();

  @override
  Widget build(BuildContext context) {
    return BnaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const BnaCardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BnaCardTitle('Card Title'),
                SizedBox(height: 4),
                BnaCardDescription(
                  'This is a description of the card content. It provides additional context about what this card contains.',
                ),
              ],
            ),
          ),
          const BnaCardContent(
            child: BnaText(
              'This is the main content area of the card. You can put any content here including text, images, forms, or other components.',
            ),
          ),
          BnaCardFooter(
            children: <Widget>[
              BnaButton(
                variant: BnaButtonVariant.outline,
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              Expanded(
                child: BnaButton(
                  onPressed: () {},
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimpleCard extends StatelessWidget {
  const _SimpleCard();

  @override
  Widget build(BuildContext context) {
    return const BnaCard(
      child: BnaCardContent(
        child: BnaText(
          'A simple card with just content. Perfect for displaying basic information or messages.',
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard();

  @override
  Widget build(BuildContext context) {
    return BnaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.network(
              'https://picsum.photos/350/200',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) => Container(
                    width: double.infinity,
                    height: 300,
                    color: const Color(0xFFD4D4D8),
                    alignment: Alignment.center,
                    child: const BnaText('Image unavailable'),
                  ),
            ),
          ),
          const SizedBox(height: 16),
          const BnaCardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BnaCardTitle('Beautiful Landscape'),
                SizedBox(height: 4),
                BnaCardDescription(
                  'A stunning view captured in the mountains during golden hour.',
                ),
              ],
            ),
          ),
          const BnaCardContent(
            child: BnaText(
              'This image showcases the beauty of nature with its vibrant colors and serene atmosphere.',
            ),
          ),
          BnaCardFooter(
            children: <Widget>[
              BnaButton(
                variant: BnaButtonVariant.outline,
                onPressed: () {},
                child: const Text('Share'),
              ),
              BnaButton(onPressed: () {}, child: const Text('Download')),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardFormDemo extends StatefulWidget {
  const _CardFormDemo();

  @override
  State<_CardFormDemo> createState() => _CardFormDemoState();
}

class _CardFormDemoState extends State<_CardFormDemo> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BnaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const BnaCardHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BnaCardTitle('Sign In'),
                SizedBox(height: 4),
                BnaCardDescription(
                  'Enter your credentials to access your account.',
                ),
              ],
            ),
          ),
          BnaCardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CardFormField(
                  label: 'Email',
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                  autocapitalizeWords: false,
                  obscureText: false,
                  placeholder: 'Enter your email',
                ),
                const SizedBox(height: 16),
                _CardFormField(
                  label: 'Password',
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  autocapitalizeWords: false,
                  obscureText: true,
                  placeholder: 'Enter your password',
                ),
              ],
            ),
          ),
          BnaCardFooter(
            children: <Widget>[
              BnaButton(
                variant: BnaButtonVariant.outline,
                onPressed: () {},
                child: const Text('Cancel'),
              ),
              BnaButton(onPressed: () {}, child: const Text('Sign In')),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardFormField extends StatelessWidget {
  const _CardFormField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.textInputAction,
    required this.onSubmitted,
    required this.autocapitalizeWords,
    required this.obscureText,
    required this.placeholder,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final bool autocapitalizeWords;
  final bool obscureText;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BnaText(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, height: 1.2),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(BnaShowcaseMetrics.corners),
            border: Border.all(color: colors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              obscureText: obscureText,
              autocorrect: false,
              enableSuggestions: !obscureText,
              textCapitalization: autocapitalizeWords
                  ? TextCapitalization.words
                  : TextCapitalization.none,
              style: BnaShowcaseTextStyles.body(colors).copyWith(height: 1.0),
              cursorColor: colors.primary,
              decoration: InputDecoration.collapsed(
                hintText: placeholder,
                hintStyle: BnaShowcaseTextStyles.body(
                  colors,
                ).copyWith(color: colors.textMuted),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PricingCards extends StatelessWidget {
  const _PricingCards();

  @override
  Widget build(BuildContext context) {
    const List<_PricingPlan> plans = <_PricingPlan>[
      _PricingPlan(
        name: 'Basic',
        price: '\$9',
        description: 'Perfect for individuals',
        features: <String>['1 Project', '5GB Storage', 'Email Support'],
      ),
      _PricingPlan(
        name: 'Pro',
        price: '\$29',
        description: 'Best for small teams',
        features: <String>['10 Projects', '100GB Storage'],
        popular: true,
      ),
      _PricingPlan(
        name: 'Enterprise',
        price: '\$99',
        description: 'For large organizations',
        features: <String>['Unlimited Projects', '1TB Storage'],
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth >= 560
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: plans
              .map(
                (_PricingPlan plan) => SizedBox(
                  width: width,
                  child: _PricingCard(plan: plan),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _PricingPlan {
  const _PricingPlan({
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    this.popular = false,
  });

  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool popular;
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.plan});

  final _PricingPlan plan;

  @override
  Widget build(BuildContext context) {
    return BnaCard(
      borderColor: plan.popular ? const Color(0xFF3B82F6) : null,
      borderWidth: plan.popular ? 2 : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BnaCardHeader(
            child: Align(
              child: Column(
                children: <Widget>[
                  if (plan.popular) ...<Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const BnaText(
                        'POPULAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  BnaCardTitle(plan.name),
                  const SizedBox(height: 4),
                  BnaCardDescription(plan.description),
                  const SizedBox(height: 8),
                  BnaText.rich(
                    TextSpan(
                      text: plan.price,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                      children: const <InlineSpan>[
                        TextSpan(
                          text: '/month',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BnaCardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plan.features
                  .map(
                    (String feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            LucideIcons.check300,
                            size: 16,
                            color: Color(0xFF22C55E),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: BnaText(feature)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCards extends StatelessWidget {
  const _StatsCards();

  @override
  Widget build(BuildContext context) {
    const List<_StatItem> stats = <_StatItem>[
      _StatItem(title: 'Total Users', value: '12,543', change: '+12%'),
      _StatItem(title: 'Revenue', value: '\$45,231', change: '+8%'),
      _StatItem(title: 'Orders', value: '1,234', change: '+23%'),
      _StatItem(title: 'Growth', value: '15.3%', change: '+4%'),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: stats
              .map(
                (_StatItem stat) => SizedBox(
                  width: width < 150 ? constraints.maxWidth : width,
                  child: _StatCard(stat: stat),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.title,
    required this.value,
    required this.change,
  });

  final String title;
  final String value;
  final String change;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _StatItem stat;

  @override
  Widget build(BuildContext context) {
    return BnaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BnaCardHeader(
            child: BnaCardTitle(
              stat.title,
              style: const TextStyle(fontSize: 16, height: 1.2),
            ),
          ),
          BnaCardContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BnaText(
                  stat.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                BnaText(
                  '${stat.change} from last month',
                  style: const TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard();

  @override
  Widget build(BuildContext context) {
    return BnaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BnaCardHeader(
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.bell300,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BnaCardTitle('New Notification'),
                      SizedBox(height: 4),
                      BnaCardDescription('2 minutes ago'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const BnaCardContent(
            child: BnaText(
              'You have a new message from John Doe. Click to view the full conversation and respond.',
            ),
          ),
          BnaCardFooter(
            children: <Widget>[
              BnaButton(
                variant: BnaButtonVariant.outline,
                onPressed: () {},
                child: const Text('Dismiss'),
              ),
              Expanded(
                child: BnaButton(
                  onPressed: () {},
                  child: const Text('View Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
