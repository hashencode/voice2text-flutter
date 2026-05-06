import 'package:flutter/services.dart';

import '../../../app/contracts/audio_contract.dart';
import 'transcription_port.dart';

class AndroidTranscriptionService implements TranscriptionPort {
  AndroidTranscriptionService() : _channel = const MethodChannel(_channelName);

  static const String _channelName = AudioContract.recorderChannel;
  final MethodChannel _channel;

  @override
  Future<String> transcribe(TranscriptionRequest request) async {
    try {
      final String? text = await _channel.invokeMethod<String>('transcribe', {
        'recordingPath': request.recordingPath,
        'durationMs': request.durationMs,
        'modelId': request.modelId,
        'sampleRateHz': request.sampleRateHz,
        'enablePunctuation': request.enablePunctuation,
        'enableDenoise': request.enableDenoise,
        'engineMode': request.engineMode.name,
      });

      if (text == null || text.isEmpty) {
        throw const _TranscribeException('原生转写返回为空');
      }

      return text;
    } on PlatformException catch (e) {
      throw _TranscribeException(e.message ?? '原生转写失败');
    }
  }
}

class _TranscribeException implements Exception {
  const _TranscribeException(this.message);
  final String message;

  @override
  String toString() => message;
}
