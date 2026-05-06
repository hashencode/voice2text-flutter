import 'package:flutter/services.dart';

import '../../../app/contracts/audio_contract.dart';

import 'recorder_port.dart';

class AndroidRecorderEngine implements RecorderPort {
  AndroidRecorderEngine() : _channel = const MethodChannel(_channelName);

  static const String _channelName = AudioContract.recorderChannel;
  final MethodChannel _channel;

  @override
  Future<void> start() async {
    await _invokeVoid('start');
  }

  @override
  Future<void> pause() async {
    await _invokeVoid('pause');
  }

  @override
  Future<void> resume() async {
    await _invokeVoid('resume');
  }

  @override
  Future<RecorderResult> stop() async {
    try {
      final Map<Object?, Object?>? raw = await _channel.invokeMapMethod<Object?, Object?>('stop');
      if (raw == null) {
        throw RecorderException('原生返回为空');
      }

      final String path = (raw['path'] as String?) ?? '';
      final int durationMs = (raw['durationMs'] as int?) ?? 0;

      return RecorderResult(path: path, durationMs: durationMs);
    } on PlatformException catch (e) {
      throw RecorderException(e.message ?? '停止录音失败');
    }
  }

  Future<void> _invokeVoid(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } on PlatformException catch (e) {
      throw RecorderException(e.message ?? '调用失败: $method');
    }
  }
}
