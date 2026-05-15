import 'package:flutter/material.dart';

import '../widgets/bna_button.dart';
import '../widgets/bna_showcase_shell.dart';
import '../widgets/bna_video.dart';

const String _kDemoVideoUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4';

const List<BnaVideoCaptionCue> _kDemoCaptions = <BnaVideoCaptionCue>[
  BnaVideoCaptionCue(
    start: Duration(seconds: 0),
    end: Duration(seconds: 3),
    text: 'Signal locked. Keep your eyes on the horizon.',
  ),
  BnaVideoCaptionCue(
    start: Duration(seconds: 3),
    end: Duration(seconds: 7),
    text: 'The route is clear. Stay steady through the turn.',
  ),
  BnaVideoCaptionCue(
    start: Duration(seconds: 7),
    end: Duration(seconds: 12),
    text: 'Double tap either side to jump across the timeline.',
  ),
  BnaVideoCaptionCue(
    start: Duration(seconds: 12),
    end: Duration(seconds: 16),
    text: 'Press and hold to temporarily boost to 2x playback.',
  ),
];

class BnaVideoComponentPage extends StatefulWidget {
  const BnaVideoComponentPage({super.key});

  @override
  State<BnaVideoComponentPage> createState() => _BnaVideoComponentPageState();
}

class _BnaVideoComponentPageState extends State<BnaVideoComponentPage> {
  bool _captionsEnabled = false;
  bool _muted = false;
  bool _loop = false;
  bool _disabled = false;
  int _reloadSeed = 0;
  BnaVideoFit _fit = BnaVideoFit.cover;

  @override
  Widget build(BuildContext context) {
    return BnaShowcaseScaffold(
      title: 'Video',
      leadingLabel: 'BNA UI / Components',
      description:
          'A YouTube-inspired mobile player built on Flutter’s official video foundation, with heavier Lucide controls, cast placeholders, fullscreen-only subtitle and speed placeholders, double-tap seek, temporary 2x long-press, and landscape fullscreen handoff.',
      lazyChildren: <WidgetBuilder>[
        (_) => const BnaExampleSection(
          title: 'Featured Player',
          description:
              'Single tap reveals controls. Double tap the sides to seek 10 seconds. Long press while playing to temporarily speed up to 2x. The top-right cast icon is a visual placeholder here; subtitle and speed placeholders appear only in fullscreen.',
          surface: false,
          child: _FeaturedVideoDemo(),
        ),
        (_) => BnaExampleSection(
          title: 'Interactive States',
          description:
              'These controls intentionally expose loading, disabled, mute, captions, loop, and content-fit behaviors so they can be verified one by one on-device.',
          surface: false,
          child: _InteractiveVideoDemo(
            captionsEnabled: _captionsEnabled,
            muted: _muted,
            loop: _loop,
            disabled: _disabled,
            fit: _fit,
            reloadSeed: _reloadSeed,
            onCaptionsToggled: () {
              setState(() {
                _captionsEnabled = !_captionsEnabled;
              });
            },
            onMutedToggled: () {
              setState(() {
                _muted = !_muted;
              });
            },
            onLoopToggled: () {
              setState(() {
                _loop = !_loop;
              });
            },
            onDisabledToggled: () {
              setState(() {
                _disabled = !_disabled;
              });
            },
            onFitChanged: (BnaVideoFit nextFit) {
              setState(() {
                _fit = nextFit;
              });
            },
            onReload: () {
              setState(() {
                _reloadSeed += 1;
              });
            },
          ),
        ),
        (_) => const BnaExampleSection(
          title: 'Behavior Checklist',
          description:
              'This page is structured for real-device verification rather than just static style comparison.',
          child: BnaBulletList(
            items: <String>[
              'Loading: remount the player with “Reload Source” and confirm the spinner appears before the first frame.',
              'Disabled: turning on “Disabled” blocks all control taps and dims the surface.',
              'Toggle semantics: cast, mute, captions, speed, loop, and fullscreen buttons all keep matching Lucide icons and semantic labels.',
              'Seek: drag the scrubber or double tap the left or right edge for 10-second jumps without extra seek text overlays.',
              'Keyboard and focus: no text input or soft-keyboard path exists in this component; focusable actions are limited to playback controls.',
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedVideoDemo extends StatelessWidget {
  const _FeaturedVideoDemo();

  @override
  Widget build(BuildContext context) {
    return const BnaVideo(
      sourceUrl: _kDemoVideoUrl,
      title: 'Joyride preview',
      captions: _kDemoCaptions,
      showCaptionsByDefault: false,
      fit: BnaVideoFit.cover,
    );
  }
}

class _InteractiveVideoDemo extends StatelessWidget {
  const _InteractiveVideoDemo({
    required this.captionsEnabled,
    required this.muted,
    required this.loop,
    required this.disabled,
    required this.fit,
    required this.reloadSeed,
    required this.onCaptionsToggled,
    required this.onMutedToggled,
    required this.onLoopToggled,
    required this.onDisabledToggled,
    required this.onFitChanged,
    required this.onReload,
  });

  final bool captionsEnabled;
  final bool muted;
  final bool loop;
  final bool disabled;
  final BnaVideoFit fit;
  final int reloadSeed;
  final VoidCallback onCaptionsToggled;
  final VoidCallback onMutedToggled;
  final VoidCallback onLoopToggled;
  final VoidCallback onDisabledToggled;
  final ValueChanged<BnaVideoFit> onFitChanged;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _StateToggleButton(
              label: captionsEnabled ? 'Captions On' : 'Captions Off',
              active: captionsEnabled,
              onPressed: onCaptionsToggled,
            ),
            _StateToggleButton(
              label: muted ? 'Muted' : 'Sound On',
              active: muted,
              onPressed: onMutedToggled,
            ),
            _StateToggleButton(
              label: loop ? 'Loop On' : 'Loop Off',
              active: loop,
              onPressed: onLoopToggled,
            ),
            _StateToggleButton(
              label: disabled ? 'Disabled' : 'Enabled',
              active: disabled,
              onPressed: onDisabledToggled,
            ),
            BnaButton(
              onPressed: onReload,
              variant: BnaButtonVariant.secondary,
              size: BnaButtonSize.sm,
              child: const Text('Reload Source'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            _StateToggleButton(
              label: 'Contain',
              active: fit == BnaVideoFit.contain,
              onPressed: () => onFitChanged(BnaVideoFit.contain),
            ),
            _StateToggleButton(
              label: 'Cover',
              active: fit == BnaVideoFit.cover,
              onPressed: () => onFitChanged(BnaVideoFit.cover),
            ),
            _StateToggleButton(
              label: 'Fill',
              active: fit == BnaVideoFit.fill,
              onPressed: () => onFitChanged(BnaVideoFit.fill),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BnaVideo(
          key: ValueKey<int>(reloadSeed),
          sourceUrl: _kDemoVideoUrl,
          title: 'Interactive verification',
          captions: _kDemoCaptions,
          showCaptionsByDefault: captionsEnabled,
          muted: muted,
          loop: loop,
          disabled: disabled,
          fit: fit,
        ),
      ],
    );
  }
}

class _StateToggleButton extends StatelessWidget {
  const _StateToggleButton({
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BnaButton(
      onPressed: onPressed,
      variant: active
          ? BnaButtonVariant.defaultStyle
          : BnaButtonVariant.outline,
      size: BnaButtonSize.sm,
      child: Text(label),
    );
  }
}
