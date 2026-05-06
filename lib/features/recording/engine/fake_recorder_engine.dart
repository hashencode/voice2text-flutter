import 'dart:async';

import 'recorder_port.dart';

class FakeRecorderEngine implements RecorderPort {
  DateTime? _startedAt;
  int _accumulatedMs = 0;
  bool _isRecording = false;

  @override
  Future<void> start() async {
    if (_isRecording) {
      throw RecorderException('录音已经在进行中');
    }
    _startedAt = DateTime.now();
    _isRecording = true;
  }

  @override
  Future<void> pause() async {
    if (!_isRecording || _startedAt == null) {
      throw RecorderException('当前不在录音，无法暂停');
    }
    _accumulatedMs += DateTime.now().difference(_startedAt!).inMilliseconds;
    _startedAt = null;
    _isRecording = false;
  }

  @override
  Future<void> resume() async {
    if (_isRecording) {
      throw RecorderException('当前已在录音中');
    }
    _startedAt = DateTime.now();
    _isRecording = true;
  }

  @override
  Future<RecorderResult> stop() async {
    if (_startedAt != null) {
      _accumulatedMs += DateTime.now().difference(_startedAt!).inMilliseconds;
    }

    final int durationMs = _accumulatedMs;
    _startedAt = null;
    _accumulatedMs = 0;
    _isRecording = false;

    await Future<void>.delayed(const Duration(milliseconds: 200));

    return RecorderResult(
      path: '/tmp/fake-record-${DateTime.now().millisecondsSinceEpoch}.wav',
      durationMs: durationMs,
    );
  }
}
