import '../../../data/sqlite/app_database.dart';
import '../model/recording_entity.dart';

class RecordingsRepository {
  RecordingsRepository({AppDatabase? database}) : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<void> insert({
    required String filePath,
    required int durationMs,
  }) async {
    final db = await _database.database;
    await db.insert('recordings', {
      'file_path': filePath,
      'duration_ms': durationMs,
      'created_at_ms': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<RecordingEntity>> listRecent() async {
    final db = await _database.database;
    final rows = await db.query(
      'recordings',
      orderBy: 'id DESC',
      limit: 200,
    );
    return rows.map(RecordingEntity.fromMap).toList();
  }

  Future<void> deleteById(int id) async {
    final db = await _database.database;
    await db.delete(
      'recordings',
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }
}
