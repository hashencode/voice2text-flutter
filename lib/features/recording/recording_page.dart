import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../records/repository/recordings_repository.dart';
import '../settings/repository/app_settings_repository.dart';
import '../transcription/repository/transcription_jobs_repository.dart';
import '../transcription/service/android_transcription_service.dart';
import '../transcription/service/fake_transcription_service.dart';
import '../transcription/service/transcription_port.dart';
import '../shared/utils/formatters.dart';
import '../shared/widgets/build_info_footer.dart';
import 'controller/recording_controller.dart';
import 'engine/android_recorder_engine.dart';
import 'engine/fake_recorder_engine.dart';
import 'engine/recorder_port.dart';
import 'model/recording_phase.dart';
import 'services/microphone_permission_service.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> with WidgetsBindingObserver {
  late final RecordingController _controller;
  bool _interruptionHandling = false;
  String? _pendingInterruptionNotice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = RecordingController(
      permissionService: MicrophonePermissionService(),
      recorder: _buildRecorder(),
      recordingsRepository: RecordingsRepository(),
      transcriptionJobsRepository: TranscriptionJobsRepository(),
      transcriptionService: _buildTranscriptionService(),
      appSettingsRepository: AppSettingsRepository(),
    );
    _controller.addListener(_onControllerChanged);
    _controller.reloadSettings();
  }

  TranscriptionPort _buildTranscriptionService() {
    if (Platform.isAndroid) {
      return AndroidTranscriptionService();
    }
    return FakeTranscriptionService();
  }

  RecorderPort _buildRecorder() {
    if (Platform.isAndroid) {
      return AndroidRecorderEngine();
    }
    return FakeRecorderEngine();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _handleInterruption();
      return;
    }
    if (state == AppLifecycleState.resumed) {
      _flushPendingInterruptionNotice();
    }
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _handleInterruption() async {
    if (_interruptionHandling) return;
    _interruptionHandling = true;

    final result = await _controller.handleLifecycleInterruption();
    if (!mounted) {
      _interruptionHandling = false;
      return;
    }

    if (result == InterruptionResult.autoSaved) {
      _pendingInterruptionNotice = '录音因系统中断已自动停止并保存';
    } else if (result == InterruptionResult.failed) {
      _pendingInterruptionNotice = '录音被系统中断，自动保存失败，请重试';
    }

    _interruptionHandling = false;
  }

  void _flushPendingInterruptionNotice() {
    final message = _pendingInterruptionNotice;
    if (message == null || !mounted) return;

    _pendingInterruptionNotice = null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    }

  Future<void> _openSettings() async {
    await Navigator.of(context).pushNamed('/settings');
    if (!mounted) return;

    await _controller.reloadSettings();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('录音页配置已同步')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBusy = _controller.phase == RecordingPhase.starting ||
        _controller.phase == RecordingPhase.stopping;

    return Scaffold(
      appBar: AppBar(
        title: const Text('录音'),
        actions: <Widget>[
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/transcription');
            },
            icon: const Icon(Icons.text_snippet_outlined),
            tooltip: '转写任务',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/records');
            },
            icon: const Icon(Icons.list),
            tooltip: '查看记录',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('当前状态: ${_phaseLabel(_controller.phase)}'),
                    const SizedBox(height: 8),
                    Text('录音时长: ${formatDurationMs(_controller.elapsedMs)}'),
                    if (_controller.activeModelId != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text('当前模型: ${_controller.activeModelId}'),
                    ],
                    const SizedBox(height: 8),
                    _AutoTranscribeBadge(enabled: _controller.autoTranscribeEnabled),
                    if (_controller.errorMessage != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        _controller.errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: isBusy
                  ? null
                  : () {
                      _controller.togglePrimaryAction();
                    },
              child: Text(_controller.actionLabel),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _controller.canStop && !isBusy
                  ? () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final bool saved = await _controller.stop();
                      if (!mounted) return;
                      if (saved) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('录音已保存')),
                        );
                      }
                    }
                  : null,
              child: const Text('停止并保存'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: BuildInfoFooter(),
      ),
    );
  }

  String _phaseLabel(RecordingPhase phase) {
    switch (phase) {
      case RecordingPhase.idle:
        return '待机';
      case RecordingPhase.starting:
        return '启动中';
      case RecordingPhase.recording:
        return '录音中';
      case RecordingPhase.paused:
        return '已暂停';
      case RecordingPhase.stopping:
        return '停止中';
      case RecordingPhase.error:
        return '异常';
    }
  }
}

class _AutoTranscribeBadge extends StatelessWidget {
  const _AutoTranscribeBadge({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color bg = enabled ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12);
    final Color fg = enabled ? Colors.green.shade700 : Colors.orange.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        enabled ? '自动转写: 已开启' : '自动转写: 已关闭',
        style: TextStyle(color: fg, fontSize: 12),
      ),
    );
  }
}
