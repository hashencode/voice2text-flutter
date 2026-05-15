import 'package:flutter/material.dart';

import '../bna_theme.dart';

enum BnaTabsOrientation { horizontal, vertical }

class BnaTabItem {
  const BnaTabItem({
    required this.value,
    required this.label,
    required this.child,
    this.disabled = false,
    this.textStyle,
    this.borderRadius,
    this.padding,
  });

  final String value;
  final Widget label;
  final Widget child;
  final bool disabled;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
}

class BnaTabs extends StatefulWidget {
  const BnaTabs({
    super.key,
    required this.tabs,
    this.defaultValue,
    this.value,
    this.onValueChange,
    this.orientation = BnaTabsOrientation.horizontal,
    this.enableSwipe = true,
    this.listBackgroundColor,
    this.activeTabBackgroundColor,
    this.activeForegroundColor,
    this.inactiveForegroundColor,
    this.listBorderRadius,
    this.listPadding = const EdgeInsets.all(6),
    this.listShadows,
    this.contentGap = 16,
  });

  final List<BnaTabItem> tabs;
  final String? defaultValue;
  final String? value;
  final ValueChanged<String>? onValueChange;
  final BnaTabsOrientation orientation;
  final bool enableSwipe;
  final Color? listBackgroundColor;
  final Color? activeTabBackgroundColor;
  final Color? activeForegroundColor;
  final Color? inactiveForegroundColor;
  final BorderRadiusGeometry? listBorderRadius;
  final EdgeInsetsGeometry listPadding;
  final List<BoxShadow>? listShadows;
  final double contentGap;

  @override
  State<BnaTabs> createState() => _BnaTabsState();
}

class _BnaTabsState extends State<BnaTabs> with SingleTickerProviderStateMixin {
  late final AnimationController _dragController;
  String? _internalValue;
  int _transitionDirection = 1;
  bool _isDragging = false;
  bool _skipNextChangeAnimation = false;

  bool get _isControlled => widget.value != null;

  bool get _canPreviewSwipe =>
      widget.enableSwipe &&
      widget.orientation == BnaTabsOrientation.horizontal &&
      widget.tabs.length > 1;

  String get _activeValue {
    final String? controlledValue = widget.value;
    if (controlledValue != null && _hasValue(controlledValue)) {
      return controlledValue;
    }

    final String? internalValue = _internalValue;
    if (internalValue != null && _hasValue(internalValue)) {
      return internalValue;
    }

    final String? defaultValue = widget.defaultValue;
    if (defaultValue != null && _hasValue(defaultValue)) {
      return defaultValue;
    }

    return widget.tabs.first.value;
  }

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController.unbounded(vsync: this);
    _internalValue =
        widget.defaultValue ??
        (widget.tabs.isEmpty ? null : widget.tabs.first.value);
  }

  @override
  void didUpdateWidget(covariant BnaTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.isEmpty) {
      _internalValue = null;
      return;
    }
    if (!_hasValue(_activeValue)) {
      _internalValue = widget.tabs.first.value;
    }
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.tabs.isNotEmpty, 'BnaTabs requires at least one tab.');

    final BnaShowcaseColors colors = BnaShowcaseColors.of(context);
    final Axis direction = switch (widget.orientation) {
      BnaTabsOrientation.horizontal => Axis.vertical,
      BnaTabsOrientation.vertical => Axis.horizontal,
    };

    return Flex(
      direction: direction,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TabsList(
          tabs: widget.tabs,
          activeValue: _activeValue,
          orientation: widget.orientation,
          listBackgroundColor: widget.listBackgroundColor ?? colors.secondary,
          activeTabBackgroundColor:
              widget.activeTabBackgroundColor ?? colors.background,
          activeForegroundColor: widget.activeForegroundColor ?? colors.primary,
          inactiveForegroundColor:
              widget.inactiveForegroundColor ?? colors.textMuted,
          listBorderRadius:
              widget.listBorderRadius ??
              BorderRadius.circular(
                widget.orientation == BnaTabsOrientation.horizontal
                    ? BnaShowcaseMetrics.corners
                    : BnaShowcaseMetrics.borderRadius,
              ),
          listPadding: widget.listPadding,
          listShadows: widget.listShadows,
          onSelected: _setActiveTab,
        ),
        if (widget.orientation == BnaTabsOrientation.vertical)
          const SizedBox(width: 16)
        else
          SizedBox(height: widget.contentGap),
        if (widget.orientation == BnaTabsOrientation.vertical)
          Expanded(child: _buildContent())
        else
          _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (!_canPreviewSwipe) {
      return _buildStaticContent(animated: !_skipNextChangeAnimation);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width =
            constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) => _handleDragStart(),
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            _handleDragUpdate(details, width);
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            _handleDragEnd(details, width);
          },
          onHorizontalDragCancel: _handleDragCancel,
          child: AnimatedBuilder(
            animation: _dragController,
            builder: (BuildContext context, Widget? child) {
              final double dragOffset = _dragController.value;
              final bool showPreview =
                  _isDragging ||
                  _dragController.isAnimating ||
                  dragOffset.abs() > 0.5;

              if (!showPreview || width <= 0) {
                return _buildStaticContent(animated: !_skipNextChangeAnimation);
              }

              return _buildPreviewContent(width: width, dragOffset: dragOffset);
            },
          ),
        );
      },
    );
  }

  Widget _buildStaticContent({required bool animated}) {
    final Widget content = _buildPage(
      widget.tabs[_indexOf(_activeValue)].child,
    );

    if (!animated) {
      return KeyedSubtree(key: ValueKey<String>(_activeValue), child: content);
    }

    final Widget currentContent = _AnimatedTabContent(
      key: ValueKey<String>('content-$_activeValue'),
      direction: _transitionDirection,
      child: content,
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ...previousChildren,
              ...?currentChild == null ? null : <Widget>[currentChild],
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: currentContent,
      ),
    );
  }

  Widget _buildPreviewContent({
    required double width,
    required double dragOffset,
  }) {
    final int currentIndex = _indexOf(_activeValue);
    final int previewIndex = dragOffset < 0
        ? currentIndex + 1
        : currentIndex - 1;
    final bool hasPreview =
        previewIndex >= 0 && previewIndex < widget.tabs.length;

    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(dragOffset, 0),
              child: _buildPage(widget.tabs[currentIndex].child),
            ),
            if (hasPreview)
              Transform.translate(
                offset: Offset(
                  dragOffset + (dragOffset < 0 ? width : -width),
                  0,
                ),
                child: _buildPage(widget.tabs[previewIndex].child),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Widget child) {
    return RepaintBoundary(child: child);
  }

  void _handleDragStart() {
    if (!_canPreviewSwipe) {
      return;
    }
    _dragController.stop();
    _isDragging = true;
  }

  void _handleDragUpdate(DragUpdateDetails details, double width) {
    if (!_canPreviewSwipe || width <= 0) {
      return;
    }

    final double delta = details.primaryDelta ?? 0;
    final double nextOffset = _clampDragOffset(
      _dragController.value + delta,
      width,
    );
    _dragController.value = nextOffset;
  }

  void _handleDragEnd(DragEndDetails details, double width) {
    if (!_canPreviewSwipe || width <= 0) {
      return;
    }

    final double dragOffset = _dragController.value;
    final double velocity = details.primaryVelocity ?? 0;
    final int currentIndex = _indexOf(_activeValue);
    final int targetDelta = dragOffset < 0 ? 1 : -1;
    final int targetIndex = currentIndex + targetDelta;
    final bool hasTarget = targetIndex >= 0 && targetIndex < widget.tabs.length;
    final bool shouldSwitch =
        hasTarget && (dragOffset.abs() > width * 0.18 || velocity.abs() > 500);
    final double destination = shouldSwitch
        ? (targetDelta == 1 ? -width : width)
        : 0;

    _isDragging = false;
    _animateDragOffsetTo(
      destination,
      onCompleted: () {
        if (!mounted) {
          return;
        }

        _dragController.value = 0;
        if (shouldSwitch) {
          _markSkipNextChangeAnimation();
          _setActiveTab(widget.tabs[targetIndex].value);
        }
      },
    );
  }

  void _handleDragCancel() {
    _isDragging = false;
    _animateDragOffsetTo(0);
  }

  double _clampDragOffset(double proposed, double width) {
    final int currentIndex = _indexOf(_activeValue);
    final bool draggingToNext = proposed < 0;
    final bool hasTarget = draggingToNext
        ? currentIndex < widget.tabs.length - 1
        : currentIndex > 0;

    if (!hasTarget) {
      return proposed * 0.14;
    }

    return proposed.clamp(-width, width);
  }

  void _animateDragOffsetTo(double target, {VoidCallback? onCompleted}) {
    _dragController.stop();
    _dragController
        .animateTo(
          target,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        )
        .whenComplete(() {
          if (mounted) {
            onCompleted?.call();
          }
        });
  }

  void _markSkipNextChangeAnimation() {
    if (!_skipNextChangeAnimation) {
      setState(() {
        _skipNextChangeAnimation = true;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_skipNextChangeAnimation) {
        return;
      }
      setState(() {
        _skipNextChangeAnimation = false;
      });
    });
  }

  void _setActiveTab(String nextValue) {
    if (!_hasValue(nextValue) || nextValue == _activeValue) {
      return;
    }

    _transitionDirection = _indexOf(nextValue) >= _indexOf(_activeValue)
        ? 1
        : -1;

    if (!_isControlled) {
      setState(() {
        _internalValue = nextValue;
      });
    }

    widget.onValueChange?.call(nextValue);
  }

  bool _hasValue(String value) {
    return widget.tabs.any((BnaTabItem item) => item.value == value);
  }

  int _indexOf(String value) {
    final int index = widget.tabs.indexWhere(
      (BnaTabItem item) => item.value == value,
    );
    return index == -1 ? 0 : index;
  }
}

class _TabsList extends StatefulWidget {
  const _TabsList({
    required this.tabs,
    required this.activeValue,
    required this.orientation,
    required this.listBackgroundColor,
    required this.activeTabBackgroundColor,
    required this.activeForegroundColor,
    required this.inactiveForegroundColor,
    required this.listBorderRadius,
    required this.listPadding,
    required this.listShadows,
    required this.onSelected,
  });

  final List<BnaTabItem> tabs;
  final String activeValue;
  final BnaTabsOrientation orientation;
  final Color listBackgroundColor;
  final Color activeTabBackgroundColor;
  final Color activeForegroundColor;
  final Color inactiveForegroundColor;
  final BorderRadiusGeometry listBorderRadius;
  final EdgeInsetsGeometry listPadding;
  final List<BoxShadow>? listShadows;
  final ValueChanged<String> onSelected;

  @override
  State<_TabsList> createState() => _TabsListState();
}

class _TabsListState extends State<_TabsList> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _viewportKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();
  final Map<String, GlobalKey> _itemKeys = <String, GlobalKey>{};

  Rect? _activeRect;
  BorderRadius? _activeBorderRadius;
  bool _measurementScheduled = false;

  @override
  void initState() {
    super.initState();
    _syncKeys();
    _scheduleMeasurement();
  }

  @override
  void didUpdateWidget(covariant _TabsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncKeys();
    if (oldWidget.activeValue != widget.activeValue ||
        oldWidget.tabs.length != widget.tabs.length ||
        oldWidget.orientation != widget.orientation) {
      _scheduleMeasurement();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Axis scrollDirection = switch (widget.orientation) {
      BnaTabsOrientation.horizontal => Axis.horizontal,
      BnaTabsOrientation.vertical => Axis.vertical,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.listBackgroundColor,
        borderRadius: widget.listBorderRadius,
        boxShadow: widget.listShadows,
      ),
      child: Padding(
        padding: widget.listPadding,
        child: SingleChildScrollView(
          key: _viewportKey,
          controller: _scrollController,
          scrollDirection: scrollDirection,
          physics: const BouncingScrollPhysics(),
          child: Stack(
            key: _contentKey,
            children: <Widget>[
              if (_activeRect != null)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: _activeRect!.left,
                  top: _activeRect!.top,
                  width: _activeRect!.width,
                  height: _activeRect!.height,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.activeTabBackgroundColor,
                        borderRadius:
                            _activeBorderRadius ??
                            BorderRadius.circular(BnaShowcaseMetrics.corners),
                      ),
                    ),
                  ),
                ),
              Flex(
                direction: scrollDirection == Axis.horizontal
                    ? Axis.horizontal
                    : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List<Widget>.generate(widget.tabs.length, (
                  int index,
                ) {
                  final BnaTabItem tab = widget.tabs[index];
                  final bool isActive = tab.value == widget.activeValue;
                  final bool needsTrailingGap = index != widget.tabs.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(
                      right:
                          widget.orientation == BnaTabsOrientation.horizontal &&
                              needsTrailingGap
                          ? 4
                          : 0,
                      bottom:
                          widget.orientation == BnaTabsOrientation.vertical &&
                              needsTrailingGap
                          ? 4
                          : 0,
                    ),
                    child: KeyedSubtree(
                      key: _itemKeys[tab.value],
                      child: _TabsTrigger(
                        item: tab,
                        isActive: isActive,
                        activeForegroundColor: widget.activeForegroundColor,
                        inactiveForegroundColor: widget.inactiveForegroundColor,
                        onSelected: widget.onSelected,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncKeys() {
    for (final BnaTabItem item in widget.tabs) {
      _itemKeys.putIfAbsent(item.value, GlobalKey.new);
    }

    final Set<String> activeValues = widget.tabs
        .map((BnaTabItem item) => item.value)
        .toSet();
    final List<String> staleValues = _itemKeys.keys
        .where((String value) => !activeValues.contains(value))
        .toList();
    for (final String value in staleValues) {
      _itemKeys.remove(value);
    }
  }

  void _scheduleMeasurement() {
    if (_measurementScheduled) {
      return;
    }
    _measurementScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measurementScheduled = false;
      if (!mounted) {
        return;
      }
      _updateActiveHighlight();
    });
  }

  void _updateActiveHighlight() {
    final GlobalKey? itemKey = _itemKeys[widget.activeValue];
    final BuildContext? itemContext = itemKey?.currentContext;
    final BuildContext? contentContext = _contentKey.currentContext;
    final BuildContext? viewportContext = _viewportKey.currentContext;

    if (itemContext == null ||
        contentContext == null ||
        viewportContext == null) {
      return;
    }

    final RenderBox? itemBox = itemContext.findRenderObject() as RenderBox?;
    final RenderBox? contentBox =
        contentContext.findRenderObject() as RenderBox?;
    final RenderBox? viewportBox =
        viewportContext.findRenderObject() as RenderBox?;

    if (itemBox == null || contentBox == null || viewportBox == null) {
      return;
    }

    final Offset offset = itemBox.localToGlobal(
      Offset.zero,
      ancestor: contentBox,
    );
    final Rect nextRect = offset & itemBox.size;
    final BorderRadius nextRadius = _borderRadiusFor(widget.activeValue);

    if (_activeRect != nextRect || _activeBorderRadius != nextRadius) {
      setState(() {
        _activeRect = nextRect;
        _activeBorderRadius = nextRadius;
      });
    }

    _centerActiveItem(nextRect, viewportBox.size);
  }

  BorderRadius _borderRadiusFor(String value) {
    final BnaTabItem item = widget.tabs.firstWhere(
      (BnaTabItem tab) => tab.value == value,
    );
    return item.borderRadius ??
        BorderRadius.circular(BnaShowcaseMetrics.corners);
  }

  void _centerActiveItem(Rect rect, Size viewportSize) {
    if (!_scrollController.hasClients) {
      return;
    }

    final ScrollPosition position = _scrollController.position;
    final double viewportExtent =
        widget.orientation == BnaTabsOrientation.horizontal
        ? viewportSize.width
        : viewportSize.height;
    final double itemCenter =
        widget.orientation == BnaTabsOrientation.horizontal
        ? rect.center.dx
        : rect.center.dy;
    final double targetOffset = (itemCenter - (viewportExtent / 2)).clamp(
      0.0,
      position.maxScrollExtent,
    );

    if ((position.pixels - targetOffset).abs() < 2) {
      return;
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }
}

class _TabsTrigger extends StatelessWidget {
  const _TabsTrigger({
    required this.item,
    required this.isActive,
    required this.activeForegroundColor,
    required this.inactiveForegroundColor,
    required this.onSelected,
  });

  final BnaTabItem item;
  final bool isActive;
  final Color activeForegroundColor;
  final Color inactiveForegroundColor;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        item.borderRadius ?? BorderRadius.circular(BnaShowcaseMetrics.corners);
    final TextStyle labelStyle = TextStyle(
      fontSize: BnaShowcaseMetrics.fontSize,
      fontWeight: FontWeight.w500,
      color: isActive ? activeForegroundColor : inactiveForegroundColor,
      height: 1.2,
    ).merge(item.textStyle);

    final Widget label = DefaultTextStyle(
      style: labelStyle,
      textAlign: TextAlign.center,
      child: IconTheme(
        data: IconThemeData(color: labelStyle.color, size: 18),
        child: item.label,
      ),
    );

    return Semantics(
      button: true,
      enabled: !item.disabled,
      selected: isActive,
      child: Opacity(
        opacity: item.disabled ? 0.5 : 1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll<Color>(
              Colors.transparent,
            ),
            onTap: item.disabled ? null : () => onSelected(item.value),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Padding(
                padding:
                    item.padding ??
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Center(child: label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedTabContent extends StatelessWidget {
  const _AnimatedTabContent({
    super.key,
    required this.direction,
    required this.child,
  });

  final int direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: direction.toDouble(), end: 0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? childWidget) {
        final double opacity = 1 - (value.abs() * 0.25).clamp(0.0, 0.25);
        return Transform.translate(
          offset: Offset(value * 24, 0),
          child: Opacity(opacity: opacity, child: childWidget),
        );
      },
      child: child,
    );
  }
}
