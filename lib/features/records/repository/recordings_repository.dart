import '../../../data/sqlite/app_database.dart';
import '../model/recording_entity.dart';

class RecordingsRepository {
  RecordingsRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<void> insert({
    required String filePath,
    required int durationMs,
  }) async {
    final db = await _database.database;
    await db.insert('recordings', {
      'file_path': filePath,
      'display_name': null,
      'group_name': null,
      'deleted_at_ms': null,
      'is_favorite': 0,
      'duration_ms': durationMs,
      'created_at_ms': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<RecordingEntity>> listActive({String? groupName}) async {
    final db = await _database.database;
    final String normalizedGroupName = groupName?.trim() ?? '';
    final List<Map<String, Object?>> rows;
    if (normalizedGroupName.isEmpty || normalizedGroupName == 'all') {
      rows = await db.query(
        'recordings',
        where: 'deleted_at_ms IS NULL',
        orderBy: 'created_at_ms DESC, id DESC',
        limit: 200,
      );
    } else {
      rows = await db.query(
        'recordings',
        where: 'deleted_at_ms IS NULL AND group_name = ?',
        whereArgs: <Object>[normalizedGroupName],
        orderBy: 'created_at_ms DESC, id DESC',
        limit: 200,
      );
    }
    return rows.map(RecordingEntity.fromMap).toList();
  }

  Future<List<RecordingEntity>> listDeleted() async {
    final db = await _database.database;
    final rows = await db.query(
      'recordings',
      where: 'deleted_at_ms IS NOT NULL',
      orderBy: 'deleted_at_ms DESC, id DESC',
      limit: 200,
    );
    return rows.map(RecordingEntity.fromMap).toList();
  }

  Future<void> deleteById(int id) async {
    final db = await _database.database;
    await db.delete('recordings', where: 'id = ?', whereArgs: <Object>[id]);
  }

  Future<void> updateDisplayName({
    required int id,
    required String? displayName,
  }) async {
    final db = await _database.database;
    await db.update(
      'recordings',
      <String, Object?>{'display_name': displayName},
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<void> softDeleteById(int id) async {
    final db = await _database.database;
    await db.update(
      'recordings',
      <String, Object?>{
        'deleted_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<void> restoreById(int id) async {
    final db = await _database.database;
    await db.update(
      'recordings',
      <String, Object?>{'deleted_at_ms': null},
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<void> updateFavorite({
    required int id,
    required bool isFavorite,
  }) async {
    final db = await _database.database;
    await db.update(
      'recordings',
      <String, Object?>{'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  Future<void> updateGroupName({
    required int id,
    required String? groupName,
  }) async {
    final db = await _database.database;
    await db.update(
      'recordings',
      <String, Object?>{'group_name': groupName?.trim()},
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }
}
