class RecordingEntity {
  RecordingEntity({
    required this.id,
    required this.filePath,
    required this.durationMs,
    required this.createdAtMs,
  });

  final int id;
  final String filePath;
  final int durationMs;
  final int createdAtMs;

  factory RecordingEntity.fromMap(Map<String, Object?> map) {
    return RecordingEntity(
      id: map['id'] as int,
      filePath: map['file_path'] as String,
      durationMs: map['duration_ms'] as int,
      createdAtMs: map['created_at_ms'] as int,
    );
  }
}
