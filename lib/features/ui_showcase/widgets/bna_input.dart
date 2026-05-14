import 'package:flutter/material.dart';

import '../bna_theme.dart';

enum BnaInputVariant { filled, outline }

enum BnaInputType { input, textarea }

class BnaInput extends StatefulWidget {
  const BnaInput({
    super.key,
    this.label,
    this.error,
    this.icon,
    this.rightComponent,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.variant = BnaInputVariant.filled,
    this.disabled = false,
    this.type = BnaInputType.input,
    this.rows = 4,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
  });

  final String? label;
  final String? error;
  final IconData? icon;
  final Widget? rightComponent;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final BnaInputVariant variant;
  final bool disabled;
  final BnaInputType type;
  final int rows;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<BnaInput> createState() => _BnaInputState();
}

class _BnaInputState extends State<BnaInput> {
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool get _isFocused => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant BnaInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      _internalFocusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final bool isTextarea = widget.type == BnaInputType.textarea;
    final Color borderColor = widget.error?.isNotEmpty == true
        ? colors.red
        : widget.variant == BnaInputVariant.outline && _isFocused
        ? colors.primary
        : widget.variant == BnaInputVariant.outline
        ? colors.border
        : colors.card;
    final Color backgroundColor = widget.variant == BnaInputVariant.outline
        ? Colors.transparent
        : widget.disabled
        ? colors.textMuted.withValues(alpha: 0.12)
        : colors.card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: widget.disabled ? null : _focusNode.requestFocus,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isTextarea ? 12 : 0,
            ),
            constraints: BoxConstraints(
              minHeight: isTextarea
                  ? widget.rows * 20 + 32
                  : BnaShowcaseMetrics.height,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(
                isTextarea
                    ? BnaShowcaseMetrics.borderRadius
                    : BnaShowcaseMetrics.corners,
              ),
              border: Border.all(color: borderColor),
            ),
            child: isTextarea
                ? _TextareaLayout(
                    label: widget.label,
                    icon: widget.icon,
                    rightComponent: widget.rightComponent,
                    error: widget.error,
                    colors: colors,
                    field: _buildField(colors, multiline: true),
                  )
                : _InlineLayout(
                    label: widget.label,
                    icon: widget.icon,
                    rightComponent: widget.rightComponent,
                    error: widget.error,
                    colors: colors,
                    field: _buildField(colors),
                  ),
          ),
        ),
        if (widget.error?.isNotEmpty == true) ...<Widget>[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              widget.error!,
              style: TextStyle(fontSize: 14, color: colors.red, height: 1.2),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildField(BnaShowcaseColors colors, {bool multiline = false}) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: !widget.disabled,
      maxLines: multiline ? widget.rows : 1,
      minLines: multiline ? widget.rows : 1,
      style: TextStyle(
        fontSize: BnaShowcaseMetrics.fontSize,
        color: widget.disabled
            ? colors.textMuted
            : widget.error?.isNotEmpty == true
            ? colors.red
            : colors.text,
        height: multiline ? 1.2 : 1.0,
      ),
      cursorColor: colors.primary,
      textAlignVertical: multiline
          ? TextAlignVertical.top
          : TextAlignVertical.center,
      decoration: InputDecoration.collapsed(
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontSize: BnaShowcaseMetrics.fontSize,
          color: widget.error?.isNotEmpty == true
              ? colors.red.withValues(alpha: 0.6)
              : colors.textMuted,
        ),
      ),
    );
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}

class BnaGroupedInput extends StatelessWidget {
  const BnaGroupedInput({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null) ...<Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title!,
              style: BnaShowcaseTextStyles.title(colors).copyWith(fontSize: 22),
            ),
          ),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(
              BnaShowcaseMetrics.borderRadius,
            ),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: List<Widget>.generate(children.length, (int index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: index == children.length - 1
                        ? BorderSide.none
                        : BorderSide(color: colors.border),
                  ),
                ),
                child: children[index],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class BnaGroupedInputItem extends StatefulWidget {
  const BnaGroupedInputItem({
    super.key,
    this.label,
    this.error,
    this.icon,
    this.rightComponent,
    this.controller,
    this.onChanged,
    this.disabled = false,
    this.type = BnaInputType.input,
    this.rows = 3,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
  });

  final String? label;
  final String? error;
  final IconData? icon;
  final Widget? rightComponent;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool disabled;
  final BnaInputType type;
  final int rows;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<BnaGroupedInputItem> createState() => _BnaGroupedInputItemState();
}

class _BnaGroupedInputItemState extends State<BnaGroupedInputItem> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final bool isTextarea = widget.type == BnaInputType.textarea;

    return GestureDetector(
      onTap: widget.disabled ? null : _focusNode.requestFocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isTextarea
              ? _TextareaLayout(
                  label: widget.label,
                  icon: widget.icon,
                  rightComponent: widget.rightComponent,
                  error: widget.error,
                  colors: colors,
                  field: _buildField(colors, multiline: true),
                )
              : _InlineLayout(
                  label: widget.label,
                  icon: widget.icon,
                  rightComponent: widget.rightComponent,
                  error: widget.error,
                  colors: colors,
                  field: _buildField(colors),
                ),
          if (widget.error?.isNotEmpty == true) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              widget.error!,
              style: TextStyle(fontSize: 14, color: colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField(BnaShowcaseColors colors, {bool multiline = false}) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: !widget.disabled,
      maxLines: multiline ? widget.rows : 1,
      minLines: multiline ? widget.rows : 1,
      style: TextStyle(
        fontSize: BnaShowcaseMetrics.fontSize,
        color: widget.disabled
            ? colors.textMuted
            : widget.error?.isNotEmpty == true
            ? colors.red
            : colors.text,
        height: multiline ? 1.2 : 1.0,
      ),
      cursorColor: colors.primary,
      textAlignVertical: multiline
          ? TextAlignVertical.top
          : TextAlignVertical.center,
      decoration: InputDecoration.collapsed(
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontSize: BnaShowcaseMetrics.fontSize,
          color: widget.error?.isNotEmpty == true
              ? colors.red.withValues(alpha: 0.6)
              : colors.textMuted,
        ),
      ),
    );
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _InlineLayout extends StatelessWidget {
  const _InlineLayout({
    required this.label,
    required this.icon,
    required this.rightComponent,
    required this.error,
    required this.colors,
    required this.field,
  });

  final String? label;
  final IconData? icon;
  final Widget? rightComponent;
  final String? error;
  final BnaShowcaseColors colors;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final Color muted = error?.isNotEmpty == true
        ? colors.red
        : colors.textMuted;

    return Row(
      children: <Widget>[
        SizedBox(
          width: label != null ? 120 : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 16, color: muted),
                const SizedBox(width: 8),
              ],
              if (label != null)
                Flexible(
                  child: Text(
                    label!,
                    overflow: TextOverflow.ellipsis,
                    style: BnaShowcaseTextStyles.caption(
                      colors,
                    ).copyWith(color: muted),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: field),
        if (rightComponent != null) ...<Widget>[
          const SizedBox(width: 8),
          rightComponent!,
        ],
      ],
    );
  }
}

class _TextareaLayout extends StatelessWidget {
  const _TextareaLayout({
    required this.label,
    required this.icon,
    required this.rightComponent,
    required this.error,
    required this.colors,
    required this.field,
  });

  final String? label;
  final IconData? icon;
  final Widget? rightComponent;
  final String? error;
  final BnaShowcaseColors colors;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final Color muted = error?.isNotEmpty == true
        ? colors.red
        : colors.textMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (icon != null || label != null || rightComponent != null)
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    if (icon != null) ...<Widget>[
                      Icon(icon, size: 16, color: muted),
                      const SizedBox(width: 8),
                    ],
                    if (label != null)
                      Flexible(
                        child: Text(
                          label!,
                          overflow: TextOverflow.ellipsis,
                          style: BnaShowcaseTextStyles.caption(
                            colors,
                          ).copyWith(color: muted),
                        ),
                      ),
                  ],
                ),
              ),
              if (rightComponent case final Widget component) component,
            ],
          ),
        if (icon != null || label != null || rightComponent != null)
          const SizedBox(height: 8),
        field,
      ],
    );
  }
}
