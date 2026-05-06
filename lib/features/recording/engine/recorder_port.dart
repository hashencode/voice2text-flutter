abstract class RecorderPort {
  Future<void> start();
  Future<void> pause();
  Future<void> resume();
  Future<RecorderResult> stop();
}

class RecorderResult {
  RecorderResult({
    required this.path,
    required this.durationMs,
  });

  final String path;
  final int durationMs;
}

class RecorderException implements Exception {
  RecorderException(this.message);

  final String message;

  @override
  String toString() => 'RecorderException: $message';
}
