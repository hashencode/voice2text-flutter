import 'transcription_port.dart';

class FakeTranscriptionService implements TranscriptionPort {
  @override
  Future<String> transcribe(TranscriptionRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return '[mock] model=${request.modelId} ${request.recordingPath.split('/').last} 转写完成, 时长 ${request.durationMs}ms';
  }
}
