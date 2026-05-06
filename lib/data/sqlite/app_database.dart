import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._();
  AppDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final String dbPath = await getDatabasesPath();
    final String path = p.join(dbPath, 'voice2text_flutter.db');

    return openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE recordings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_path TEXT NOT NULL,
            duration_ms INTEGER NOT NULL,
            created_at_ms INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE transcription_jobs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recording_path TEXT NOT NULL,
            duration_ms INTEGER NOT NULL,
            status TEXT NOT NULL,
            created_at_ms INTEGER NOT NULL,
            updated_at_ms INTEGER NOT NULL,
            result_text TEXT,
            error_message TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE app_settings (
            id INTEGER PRIMARY KEY,
            model_id TEXT NOT NULL,
            auto_transcribe INTEGER NOT NULL
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE transcription_jobs (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              recording_path TEXT NOT NULL,
              duration_ms INTEGER NOT NULL,
              status TEXT NOT NULL,
              created_at_ms INTEGER NOT NULL,
              updated_at_ms INTEGER NOT NULL,
              result_text TEXT,
              error_message TEXT
            )
          ''');
        }

        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE app_settings (
              id INTEGER PRIMARY KEY,
              model_id TEXT NOT NULL,
              auto_transcribe INTEGER NOT NULL
            )
          ''');
        }
      },
    );
  }
}
