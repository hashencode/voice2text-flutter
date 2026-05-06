class TranscriptionRequest {
  TranscriptionRequest({
    required this.recordingPath,
    required this.durationMs,
    required this.modelId,
    this.sampleRateHz = 16000,
    this.enablePunctuation = true,
    this.enableDenoise = true,
    this.engineMode = TranscriptionEngineMode.auto,
  });

  final String recordingPath;
  final int durationMs;
  final String modelId;
  final int sampleRateHz;
  final bool enablePunctuation;
  final bool enableDenoise;
  final TranscriptionEngineMode engineMode;
}

enum TranscriptionEngineMode {
  auto,
  stub,
  real,
}

abstract class TranscriptionPort {
  Future<String> transcribe(TranscriptionRequest request);
}
