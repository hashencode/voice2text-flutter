import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import 'bna_button.dart';
import 'bna_icon.dart';
import 'bna_showcase_shell.dart';

enum BnaVideoFit { contain, cover, fill }

class BnaVideoCaptionCue {
  const BnaVideoCaptionCue({
    required this.start,
    required this.end,
    required this.text,
  });

  final Duration start;
  final Duration end;
  final String text;
}

class BnaVideoSnapshot {
  const BnaVideoSnapshot({
    required this.position,
    required this.isPlaying,
    required this.captionsEnabled,
    required this.isMuted,
  });

  final Duration position;
  final bool isPlaying;
  final bool captionsEnabled;
  final bool isMuted;
}

String formatBnaVideoTime(Duration duration) {
  final int totalSeconds = math.max(duration.inSeconds, 0);
  final int hours = totalSeconds ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  final int seconds = totalSeconds % 60;
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

String buildBnaWebVtt(List<BnaVideoCaptionCue> captions) {
  final StringBuffer buffer = StringBuffer('WEBVTT\n\n');
  for (int index = 0; index < captions.length; index += 1) {
    final BnaVideoCaptionCue cue = captions[index];
    buffer
      ..writeln(index + 1)
      ..writeln(
        '${_formatBnaCaptionTimestamp(cue.start)} --> ${_formatBnaCaptionTimestamp(cue.end)}',
      )
      ..writeln(cue.text)
      ..writeln();
  }
  return buffer.toString();
}

class BnaVideo extends StatefulWidget {
  const BnaVideo({
    super.key,
    required this.sourceUrl,
    this.title,
    this.height = 236,
    this.autoPlay = false,
    this.loop = false,
    this.muted = false,
    this.disabled = false,
    this.allowFullscreen = true,
    this.captions = const <BnaVideoCaptionCue>[],
    this.showCaptionsByDefault = false,
    this.fit = BnaVideoFit.cover,
    this.seekInterval = const Duration(seconds: 10),
    this.initialPosition = Duration.zero,
    this.borderRadius = 24,
    this.isFullscreen = false,
    this.topLeadingInset = 0,
    this.onFullscreenPressed,
  });

  final String sourceUrl;
  final String? title;
  final double height;
  final bool autoPlay;
  final bool loop;
  final bool muted;
  final bool disabled;
  final bool allowFullscreen;
  final List<BnaVideoCaptionCue> captions;
  final bool showCaptionsByDefault;
  final BnaVideoFit fit;
  final Duration seekInterval;
  final Duration initialPosition;
  final double borderRadius;
  final bool isFullscreen;
  final double topLeadingInset;
  final VoidCallback? onFullscreenPressed;

  @override
  State<BnaVideo> createState() => _BnaVideoState();
}

class _BnaVideoState extends State<BnaVideo> {
  VideoPlayerController? _controller;
  Timer? _hideControlsTimer;
  bool _showControls = true;
  bool _captionsEnabled = true;
  bool _isMuted = false;
  bool _isInitializing = true;
  double? _dragProgress;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _captionsEnabled = widget.showCaptionsByDefault;
    _isMuted = widget.muted;
    unawaited(_initializeController());
  }

  @override
  void didUpdateWidget(covariant BnaVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sourceUrl != widget.sourceUrl ||
        oldWidget.captions != widget.captions) {
      _captionsEnabled = widget.showCaptionsByDefault;
      unawaited(_initializeController());
      return;
    }
    if (oldWidget.showCaptionsByDefault != widget.showCaptionsByDefault) {
      setState(() {
        _captionsEnabled = widget.showCaptionsByDefault;
      });
    }
    if (oldWidget.loop != widget.loop) {
      unawaited(_controller?.setLooping(widget.loop) ?? Future<void>.value());
    }
    if (oldWidget.muted != widget.muted) {
      setState(() {
        _isMuted = widget.muted;
      });
      unawaited(
        _controller?.setVolume(widget.muted ? 0 : 1) ?? Future<void>.value(),
      );
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    final VideoPlayerController? controller = _controller;
    _controller = null;
    controller?.removeListener(_handleControllerChanged);
    controller?.dispose();
    super.dispose();
  }

  BnaVideoSnapshot get snapshot {
    final VideoPlayerValue value =
        _controller?.value ?? VideoPlayerValue.uninitialized();
    return BnaVideoSnapshot(
      position: value.position,
      isPlaying: value.isPlaying,
      captionsEnabled: _captionsEnabled,
      isMuted: _isMuted,
    );
  }

  Future<void> _initializeController() async {
    final VideoPlayerController? previousController = _controller;
    previousController?.removeListener(_handleControllerChanged);
    _controller = null;
    await previousController?.dispose();

    final VideoPlayerController controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.sourceUrl),
    );

    setState(() {
      _controller = controller;
      _isInitializing = true;
      _errorMessage = null;
      _showControls = true;
      _dragProgress = null;
    });

    try {
      await controller.initialize();
      await controller.setLooping(widget.loop);
      await controller.setVolume(_isMuted ? 0 : 1);
      if (widget.captions.isNotEmpty) {
        await controller.setClosedCaptionFile(
          Future<ClosedCaptionFile>.value(
            WebVTTCaptionFile(buildBnaWebVtt(widget.captions)),
          ),
        );
      }
      if (widget.initialPosition > Duration.zero) {
        await controller.seekTo(widget.initialPosition);
      }
      controller.addListener(_handleControllerChanged);
      if (widget.autoPlay) {
        await controller.play();
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _isInitializing = false;
      });
      _scheduleHideControls(forceVisible: true);
    } catch (_) {
      controller.removeListener(_handleControllerChanged);
      await controller.dispose();
      if (!mounted) {
        return;
      }
      setState(() {
        _controller = null;
        _isInitializing = false;
        _errorMessage = 'Video failed to load.';
      });
    }
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null) {
      return;
    }
    final VideoPlayerValue value = controller.value;
    final bool ended =
        value.isInitialized &&
        value.duration > Duration.zero &&
        value.position >= value.duration - const Duration(milliseconds: 300) &&
        !value.isPlaying &&
        !widget.loop;
    if (ended && !_showControls) {
      setState(() {
        _showControls = true;
      });
    } else {
      setState(() {});
    }
  }

  void _scheduleHideControls({bool forceVisible = false}) {
    _hideControlsTimer?.cancel();
    final VideoPlayerController? controller = _controller;
    final bool canAutoHide =
        controller != null &&
        controller.value.isInitialized &&
        controller.value.isPlaying &&
        !widget.disabled;
    if (!mounted) {
      return;
    }
    if (forceVisible && !_showControls) {
      setState(() {
        _showControls = true;
      });
    }
    if (canAutoHide) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _showControlsNow() {
    if (widget.disabled) {
      return;
    }
    setState(() {
      _showControls = true;
    });
    _scheduleHideControls();
  }

  void _toggleControlsVisibility() {
    if (widget.disabled) {
      return;
    }
    _hideControlsTimer?.cancel();
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _scheduleHideControls();
    }
  }

  Future<void> _togglePlayback() async {
    if (widget.disabled) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final VideoPlayerValue value = controller.value;
    final bool isEnded =
        value.duration > Duration.zero &&
        value.position >= value.duration - const Duration(milliseconds: 300) &&
        !value.isPlaying;
    if (isEnded) {
      await controller.seekTo(Duration.zero);
      await controller.play();
    } else if (value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
    _showControlsNow();
  }

  Future<void> _toggleMute() async {
    if (widget.disabled) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null) {
      return;
    }
    final bool nextMuted = !_isMuted;
    await controller.setVolume(nextMuted ? 0 : 1);
    if (!mounted) {
      return;
    }
    setState(() {
      _isMuted = nextMuted;
    });
    _showControlsNow();
  }

  Future<void> _toggleCaptions() async {
    if (widget.disabled || widget.captions.isEmpty) {
      return;
    }
    setState(() {
      _captionsEnabled = !_captionsEnabled;
    });
    _showControlsNow();
  }

  // TODO: Wire this icon to the app's actual cast / device-transfer flow.
  void _handleCastPressed() {
    if (widget.disabled) {
      return;
    }
    _showControlsNow();
  }

  // TODO: Replace this placeholder with a real playback-speed menu.
  void _handleSpeedPressed() {
    if (widget.disabled) {
      return;
    }
    _showControlsNow();
  }

  Future<void> _seekRelative(int direction) async {
    if (widget.disabled) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final Duration delta = Duration(
      seconds: widget.seekInterval.inSeconds * direction,
    );
    final Duration duration = controller.value.duration;
    final Duration nextPosition = _clampDuration(
      controller.value.position + delta,
      max: duration,
    );
    await controller.seekTo(nextPosition);
    _showControlsNow();
  }

  Future<void> _handleLongPressStart(LongPressStartDetails details) async {
    if (widget.disabled) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (!controller.value.isPlaying) {
      return;
    }
    await controller.setPlaybackSpeed(2);
    _showControlsNow();
  }

  Future<void> _handleLongPressEnd(LongPressEndDetails details) async {
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await controller.setPlaybackSpeed(1);
    _showControlsNow();
  }

  Future<void> _handleProgressChanged(double progress) async {
    if (widget.disabled) {
      return;
    }
    setState(() {
      _dragProgress = progress;
    });
  }

  Future<void> _handleProgressStart(double progress) async {
    if (widget.disabled) {
      return;
    }
    _hideControlsTimer?.cancel();
    setState(() {
      _dragProgress = progress;
      _showControls = true;
    });
  }

  Future<void> _handleProgressEnd(double progress) async {
    if (widget.disabled) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final Duration duration = controller.value.duration;
    final Duration target = duration * progress;
    await controller.seekTo(target);
    if (!mounted) {
      return;
    }
    setState(() {
      _dragProgress = null;
    });
    _scheduleHideControls(forceVisible: true);
  }

  Future<void> _openFullscreen() async {
    if (widget.disabled) {
      return;
    }
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    final bool wasPlaying = controller.value.isPlaying;
    final BnaVideoSnapshot currentSnapshot = snapshot;
    final NavigatorState navigator = Navigator.of(context);
    await controller.pause();
    final BnaVideoSnapshot? result = await navigator.push<BnaVideoSnapshot>(
      MaterialPageRoute<BnaVideoSnapshot>(
        builder: (BuildContext context) => _BnaVideoFullscreenPage(
          sourceUrl: widget.sourceUrl,
          title: widget.title,
          startAt: currentSnapshot.position,
          muted: currentSnapshot.isMuted,
          captions: widget.captions,
          captionsEnabled: currentSnapshot.captionsEnabled,
          fit: widget.fit,
          seekInterval: widget.seekInterval,
          loop: widget.loop,
          autoPlay: wasPlaying,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == null ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }
    if (result.position > Duration.zero) {
      await _controller!.seekTo(result.position);
    }
    await _controller!.setVolume(result.isMuted ? 0 : 1);
    if (!mounted) {
      return;
    }
    setState(() {
      _isMuted = result.isMuted;
      _captionsEnabled = result.captionsEnabled;
    });
    if (result.isPlaying) {
      await _controller!.play();
    } else {
      await _controller!.pause();
    }
    _scheduleHideControls(forceVisible: true);
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? controller = _controller;
    final VideoPlayerValue value =
        controller?.value ?? VideoPlayerValue.uninitialized();
    final bool isReady = value.isInitialized;
    final bool isPlaying = isReady && value.isPlaying;
    final bool isBuffering = isReady && value.isBuffering;
    final Duration duration = value.duration;
    final double playedFraction = isReady && duration > Duration.zero
        ? value.position.inMilliseconds / duration.inMilliseconds
        : 0;
    final double bufferedFraction = isReady && duration > Duration.zero
        ? _bufferedFraction(value, duration)
        : 0;
    final double progressValue = _dragProgress ?? playedFraction;
    final bool showCenterAction =
        isReady &&
        !isBuffering &&
        !_isInitializing &&
        (_showControls || !isPlaying);
    final String? captionText = _captionsEnabled && isReady
        ? value.caption.text
        : null;

    return Semantics(
      label: widget.title ?? 'Video player',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: SizedBox(
          height: widget.height,
          child: ColoredBox(
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _BnaVideoSurface(controller: controller, fit: widget.fit),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPressStart: (LongPressStartDetails details) {
                      unawaited(_handleLongPressStart(details));
                    },
                    onLongPressEnd: (LongPressEndDetails details) {
                      unawaited(_handleLongPressEnd(details));
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _toggleControlsVisibility,
                            onDoubleTap: () {
                              unawaited(_seekRelative(-1));
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _toggleControlsVisibility,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _toggleControlsVisibility,
                            onDoubleTap: () {
                              unawaited(_seekRelative(1));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: !_showControls,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: _showControls ? 1 : 0,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0x88000000),
                              Color(0x30000000),
                              Color(0x60000000),
                            ],
                            stops: <double>[0, 0.45, 1],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                          child: Column(
                            children: <Widget>[
                              _buildTopBar(),
                              Expanded(
                                child: showCenterAction
                                    ? Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: _buildCenterAction(isPlaying),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              _buildBottomControls(
                                isReady: isReady,
                                progressValue: progressValue,
                                bufferedFraction: bufferedFraction,
                                currentPosition: _dragProgress != null
                                    ? duration * _dragProgress!
                                    : value.position,
                                duration: duration,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (captionText != null && captionText.trim().isNotEmpty)
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: _showControls ? 70 : 20,
                    child: IgnorePointer(
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xCC111111),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              captionText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isBuffering || _isInitializing)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_errorMessage != null)
                  Positioned.fill(
                    child: ColoredBox(
                      color: const Color(0xE0000000),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                LucideIcons.circleAlert300,
                                color: Colors.white,
                                size: 26,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: 140,
                                child: BnaButton(
                                  onPressed: () {
                                    unawaited(_initializeController());
                                  },
                                  icon: LucideIcons.refreshCcw300,
                                  size: BnaButtonSize.sm,
                                  child: const Text('Retry'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.disabled)
                  Positioned.fill(
                    child: ColoredBox(
                      color: const Color(0x77000000),
                      child: Center(
                        child: BnaStatusPill(
                          label: 'Disabled',
                          backgroundColor: Colors.white.withValues(alpha: 0.16),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final double buttonSize = widget.isFullscreen ? 44 : 40;
    final double iconSize = widget.isFullscreen ? 24 : 21;
    final TextStyle titleStyle = TextStyle(
      color: Colors.white,
      fontSize: widget.isFullscreen ? 16 : 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );

    return Row(
      children: <Widget>[
        if (widget.topLeadingInset > 0) SizedBox(width: widget.topLeadingInset),
        if (widget.title != null)
          Expanded(
            child: Text(
              widget.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 10),
        _BnaVideoControlButton(
          icon: LucideIcons.cast300,
          label: 'Cast video',
          enabled: !widget.disabled,
          onPressed: _handleCastPressed,
          buttonSize: buttonSize,
          iconSize: iconSize,
        ),
        if (widget.isFullscreen) ...<Widget>[
          const SizedBox(width: 8),
          _BnaVideoControlButton(
            icon: _captionsEnabled
                ? LucideIcons.captions300
                : LucideIcons.captionsOff300,
            label: _captionsEnabled ? 'Hide captions' : 'Show captions',
            enabled: widget.captions.isNotEmpty && !widget.disabled,
            onPressed: _toggleCaptions,
            buttonSize: buttonSize,
            iconSize: iconSize,
          ),
          const SizedBox(width: 8),
          _BnaVideoControlButton(
            icon: LucideIcons.gauge300,
            label: 'Playback speed',
            enabled: !widget.disabled,
            onPressed: _handleSpeedPressed,
            buttonSize: buttonSize,
            iconSize: iconSize,
          ),
        ],
        const SizedBox(width: 8),
        _BnaVideoControlButton(
          icon: _isMuted
              ? LucideIcons.volumeX300
              : LucideIcons.volume2Weight300,
          label: _isMuted ? 'Unmute video' : 'Mute video',
          enabled: !widget.disabled,
          onPressed: _toggleMute,
          buttonSize: buttonSize,
          iconSize: iconSize,
        ),
      ],
    );
  }

  Widget _buildCenterAction(bool isPlaying) {
    final VideoPlayerController? controller = _controller;
    final bool ended =
        controller != null &&
        controller.value.isInitialized &&
        controller.value.duration > Duration.zero &&
        controller.value.position >=
            controller.value.duration - const Duration(milliseconds: 300) &&
        !controller.value.isPlaying &&
        !widget.loop;

    final String label = ended
        ? 'Replay video'
        : isPlaying
        ? 'Pause video'
        : 'Play video';

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: _togglePlayback,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: widget.isFullscreen ? 126 : 114,
          height: widget.isFullscreen ? 126 : 114,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: ended
                ? const BnaIcon(
                    icon: LucideIcons.rotateCcw300,
                    color: Colors.white,
                    size: 51,
                    strokeWidth: 2,
                  )
                : _BnaVideoCenterGlyph(
                    isPlaying: isPlaying,
                    size: widget.isFullscreen ? 54 : 48,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls({
    required bool isReady,
    required double progressValue,
    required double bufferedFraction,
    required Duration currentPosition,
    required Duration duration,
  }) {
    final double leadingInset = widget.isFullscreen ? 0 : widget.topLeadingInset;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: leadingInset),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: const Color(0xFFFF0033),
              inactiveTrackColor: Colors.white24,
              secondaryActiveTrackColor: Colors.white54,
              thumbColor: const Color(0xFFFF0033),
              overlayColor: const Color(0x33FF0033),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              padding: EdgeInsets.zero,
              value: progressValue.clamp(0, 1),
              secondaryTrackValue: bufferedFraction.clamp(progressValue, 1),
              onChangeStart: isReady
                  ? (double value) {
                      unawaited(_handleProgressStart(value));
                    }
                  : null,
              onChanged: isReady
                  ? (double value) {
                      unawaited(_handleProgressChanged(value));
                    }
                  : null,
              onChangeEnd: isReady
                  ? (double value) {
                      unawaited(_handleProgressEnd(value));
                    }
                  : null,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: leadingInset),
          child: Row(
            children: <Widget>[
              Text(
                '${formatBnaVideoTime(currentPosition)} / ${formatBnaVideoTime(duration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _BnaVideoControlButton(
                icon: widget.isFullscreen
                    ? LucideIcons.minimize2Weight300
                    : LucideIcons.maximize2Weight300,
                label: widget.isFullscreen
                    ? 'Exit fullscreen video'
                    : 'Open fullscreen video',
                enabled:
                    (widget.allowFullscreen || widget.isFullscreen) &&
                    !widget.disabled,
                onPressed: widget.onFullscreenPressed ?? _openFullscreen,
                buttonSize: widget.isFullscreen ? 44 : 40,
                iconSize: widget.isFullscreen ? 24 : 21,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BnaVideoSurface extends StatelessWidget {
  const _BnaVideoSurface({required this.controller, required this.fit});

  final VideoPlayerController? controller;
  final BnaVideoFit fit;

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? activeController = controller;
    if (activeController == null || !activeController.value.isInitialized) {
      return const SizedBox.expand();
    }
    final Size size = activeController.value.size;
    if (size.width <= 0 || size.height <= 0) {
      return const SizedBox.expand();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints _) {
        final BoxFit resolvedFit = switch (fit) {
          BnaVideoFit.contain => BoxFit.contain,
          BnaVideoFit.cover => BoxFit.cover,
          BnaVideoFit.fill => BoxFit.fill,
        };

        return Center(
          child: FittedBox(
            fit: resolvedFit,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: VideoPlayer(activeController),
            ),
          ),
        );
      },
    );
  }
}

class _BnaVideoControlButton extends StatelessWidget {
  const _BnaVideoControlButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
    this.buttonSize = 34,
    this.iconSize = 18,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;
  final double buttonSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: enabled
                ? Colors.black.withValues(alpha: 0.42)
                : Colors.black.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white12),
          ),
          child: BnaIcon(
            icon: icon,
            color: enabled ? Colors.white : Colors.white38,
            size: iconSize,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class _BnaVideoCenterGlyph extends StatelessWidget {
  const _BnaVideoCenterGlyph({required this.isPlaying, required this.size});

  final bool isPlaying;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _BnaVideoCenterGlyphPainter(isPlaying: isPlaying),
    );
  }
}

class _BnaVideoCenterGlyphPainter extends CustomPainter {
  const _BnaVideoCenterGlyphPainter({required this.isPlaying});

  final bool isPlaying;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    if (isPlaying) {
      final double barWidth = size.width * 0.2;
      final double barHeight = size.height * 0.64;
      final double top = (size.height - barHeight) / 2;
      final double left = size.width * 0.28;
      final RRect leftBar = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(2.4),
      );
      final RRect rightBar = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width - left - barWidth, top, barWidth, barHeight),
        const Radius.circular(2.4),
      );
      canvas.drawRRect(leftBar, paint);
      canvas.drawRRect(rightBar, paint);
      return;
    }

    final Path triangle = Path()
      ..moveTo(size.width * 0.34, size.height * 0.22)
      ..lineTo(size.width * 0.34, size.height * 0.78)
      ..lineTo(size.width * 0.78, size.height * 0.5)
      ..close();
    canvas.drawPath(triangle, paint);
  }

  @override
  bool shouldRepaint(covariant _BnaVideoCenterGlyphPainter oldDelegate) {
    return oldDelegate.isPlaying != isPlaying;
  }
}

class _BnaVideoFullscreenPage extends StatefulWidget {
  const _BnaVideoFullscreenPage({
    required this.sourceUrl,
    required this.title,
    required this.startAt,
    required this.muted,
    required this.captions,
    required this.captionsEnabled,
    required this.fit,
    required this.seekInterval,
    required this.loop,
    required this.autoPlay,
  });

  final String sourceUrl;
  final String? title;
  final Duration startAt;
  final bool muted;
  final List<BnaVideoCaptionCue> captions;
  final bool captionsEnabled;
  final BnaVideoFit fit;
  final Duration seekInterval;
  final bool loop;
  final bool autoPlay;

  @override
  State<_BnaVideoFullscreenPage> createState() =>
      _BnaVideoFullscreenPageState();
}

class _BnaVideoFullscreenPageState extends State<_BnaVideoFullscreenPage> {
  final GlobalKey<_BnaVideoState> _playerKey = GlobalKey<_BnaVideoState>();

  @override
  void initState() {
    super.initState();
    unawaited(_enterFullscreenMode());
  }

  @override
  void dispose() {
    unawaited(_exitFullscreenMode());
    super.dispose();
  }

  Future<void> _enterFullscreenMode() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _exitFullscreenMode() async {
    await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);

    Future<void> closePage() async {
      await _exitFullscreenMode();
      if (!mounted) {
        return;
      }
      navigator.pop(_playerKey.currentState?.snapshot);
    }

    return PopScope<BnaVideoSnapshot>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, BnaVideoSnapshot? result) {
        if (!didPop) {
          unawaited(closePage());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: BnaVideo(
                  key: _playerKey,
                  sourceUrl: widget.sourceUrl,
                  title: widget.title,
                  height: MediaQuery.of(context).size.height,
                  autoPlay: widget.autoPlay,
                  loop: widget.loop,
                  muted: widget.muted,
                  allowFullscreen: false,
                  captions: widget.captions,
                  showCaptionsByDefault: widget.captionsEnabled,
                  fit: widget.fit,
                  seekInterval: widget.seekInterval,
                  initialPosition: widget.startAt,
                  borderRadius: 0,
                  isFullscreen: true,
                  topLeadingInset: 58,
                  onFullscreenPressed: closePage,
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: _BnaVideoControlButton(
                  icon: LucideIcons.arrowLeft300,
                  label: 'Close fullscreen video',
                  enabled: true,
                  onPressed: closePage,
                  buttonSize: 44,
                  iconSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double _bufferedFraction(VideoPlayerValue value, Duration duration) {
  if (value.buffered.isEmpty || duration <= Duration.zero) {
    return 0;
  }
  final int endMs = value.buffered.last.end.inMilliseconds;
  return endMs / duration.inMilliseconds;
}

Duration _clampDuration(Duration value, {required Duration max}) {
  if (value < Duration.zero) {
    return Duration.zero;
  }
  if (value > max) {
    return max;
  }
  return value;
}

String _formatBnaCaptionTimestamp(Duration duration) {
  final int totalMilliseconds = math.max(duration.inMilliseconds, 0);
  final int hours = totalMilliseconds ~/ 3600000;
  final int minutes = (totalMilliseconds % 3600000) ~/ 60000;
  final int seconds = (totalMilliseconds % 60000) ~/ 1000;
  final int milliseconds = totalMilliseconds % 1000;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0')}';
}
