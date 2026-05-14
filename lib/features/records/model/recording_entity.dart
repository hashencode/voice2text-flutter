class RecordingEntity {
  RecordingEntity({
    required this.id,
    required this.filePath,
    required this.displayName,
    required this.groupName,
    required this.deletedAtMs,
    required this.isFavorite,
    required this.durationMs,
    required this.createdAtMs,
  });

  final int id;
  final String filePath;
  final String? displayName;
  final String? groupName;
  final int? deletedAtMs;
  final bool isFavorite;
  final int durationMs;
  final int createdAtMs;

  factory RecordingEntity.fromMap(Map<String, Object?> map) {
    return RecordingEntity(
      id: map['id'] as int,
      filePath: map['file_path'] as String,
      displayName: map['display_name'] as String?,
      groupName: map['group_name'] as String?,
      deletedAtMs: map['deleted_at_ms'] as int?,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      durationMs: map['duration_ms'] as int,
      createdAtMs: map['created_at_ms'] as int,
    );
  }
}
