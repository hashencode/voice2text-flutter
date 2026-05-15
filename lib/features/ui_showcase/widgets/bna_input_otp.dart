import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bna_theme.dart';

class BnaInputOtpSlotStyle {
  const BnaInputOtpSlotStyle({
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.backgroundColor,
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;
}

class BnaInputOtp extends StatefulWidget {
  const BnaInputOtp({
    super.key,
    this.length = 6,
    required this.value,
    this.onChanged,
    this.onComplete,
    this.error,
    this.disabled = false,
    this.masked = false,
    this.separator,
    this.showCursor = true,
    this.focusNode,
    this.slotStyle,
    this.gap = 8,
  }) : assert(length > 0, 'length must be greater than zero');

  final int length;
  final String value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onComplete;
  final String? error;
  final bool disabled;
  final bool masked;
  final Widget? separator;
  final bool showCursor;
  final FocusNode? focusNode;
  final BnaInputOtpSlotStyle? slotStyle;
  final double gap;

  @override
  State<BnaInputOtp> createState() => _BnaInputOtpState();
}

class _BnaInputOtpState extends State<BnaInputOtp> {
  late final TextEditingController _textController;
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  String get _normalizedValue => _normalize(widget.value);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _normalizedValue);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant BnaInputOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      _internalFocusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
    }

    final String normalizedValue = _normalizedValue;
    if (_textController.text != normalizedValue) {
      _textController.value = TextEditingValue(
        text: normalizedValue,
        selection: TextSelection.collapsed(offset: normalizedValue.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final BnaInputOtpSlotStyle slotStyle =
        widget.slotStyle ?? const BnaInputOtpSlotStyle();
    final String normalizedValue = _normalizedValue;
    final int activeIndex = math.min(normalizedValue.length, widget.length - 1);
    final bool hasError = widget.error?.isNotEmpty == true;
    final Color disabledBackground = colors.textMuted.withValues(alpha: 0.12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned.fill(
              child: Opacity(
                opacity: widget.disabled ? 0 : 0.01,
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: !widget.disabled,
                  showCursor: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: const TextStyle(color: Colors.transparent),
                  cursorColor: Colors.transparent,
                  autofillHints: const <String>[AutofillHints.oneTimeCode],
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: _handleChanged,
                ),
              ),
            ),
            IgnorePointer(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(widget.length, (int index) {
                    final bool hasValue = index < normalizedValue.length;
                    final bool isActive =
                        _focusNode.hasFocus && index == activeIndex;
                    final String displayValue = hasValue
                        ? (widget.masked ? '•' : normalizedValue[index])
                        : '';
                    final Color borderColor = hasError
                        ? colors.red
                        : isActive
                        ? colors.primary
                        : slotStyle.borderColor ?? colors.border;
                    final Color backgroundColor =
                        slotStyle.backgroundColor ??
                        (widget.disabled ? disabledBackground : colors.card);

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: widget.disabled ? 0.6 : 1,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            width: slotStyle.width ?? 58,
                            height: slotStyle.height ?? 58,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(
                                slotStyle.borderRadius ??
                                    BnaShowcaseMetrics.corners,
                              ),
                              border: Border.all(
                                color: borderColor,
                                width: slotStyle.borderWidth ?? 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Text(
                                  displayValue,
                                  style: TextStyle(
                                    fontSize: BnaShowcaseMetrics.fontSize + 2,
                                    fontWeight: FontWeight.w600,
                                    color: hasError
                                        ? colors.red
                                        : hasValue
                                        ? colors.text
                                        : colors.textMuted,
                                  ),
                                ),
                                if (widget.showCursor && isActive && !hasValue)
                                  Container(
                                    width: 2,
                                    height: 20,
                                    color: colors.primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (index < widget.length - 1)
                          widget.separator == null
                              ? SizedBox(width: widget.gap)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: widget.separator,
                                ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        if (hasError) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            widget.error!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: colors.red),
          ),
        ],
      ],
    );
  }

  void _handleChanged(String rawValue) {
    final String normalized = _normalize(rawValue);
    if (normalized != rawValue) {
      _textController.value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }

    if (normalized != widget.value) {
      widget.onChanged?.call(normalized);
    }

    if (normalized.length == widget.length) {
      widget.onComplete?.call(normalized);
    }
  }

  String _normalize(String value) {
    final String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly.length <= widget.length
        ? digitsOnly
        : digitsOnly.substring(0, widget.length);
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
