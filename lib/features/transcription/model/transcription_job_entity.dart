class TranscriptionJobEntity {
  TranscriptionJobEntity({
    required this.id,
    required this.recordingPath,
    required this.durationMs,
    required this.status,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.resultText,
    required this.errorMessage,
  });

  final int id;
  final String recordingPath;
  final int durationMs;
  final String status;
  final int createdAtMs;
  final int updatedAtMs;
  final String? resultText;
  final String? errorMessage;

  factory TranscriptionJobEntity.fromMap(Map<String, Object?> map) {
    return TranscriptionJobEntity(
      id: map['id'] as int,
      recordingPath: map['recording_path'] as String,
      durationMs: map['duration_ms'] as int,
      status: map['status'] as String,
      createdAtMs: map['created_at_ms'] as int,
      updatedAtMs: map['updated_at_ms'] as int,
      resultText: map['result_text'] as String?,
      errorMessage: map['error_message'] as String?,
    );
  }
}
