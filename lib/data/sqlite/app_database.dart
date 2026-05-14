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
      version: 8,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE recordings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_path TEXT NOT NULL,
            display_name TEXT,
            group_name TEXT,
            deleted_at_ms INTEGER,
            is_favorite INTEGER NOT NULL DEFAULT 0,
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
            auto_transcribe INTEGER NOT NULL,
            is_dark_mode INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE folders (
            name TEXT PRIMARY KEY,
            created_at_ms INTEGER NOT NULL,
            is_favorite INTEGER NOT NULL DEFAULT 0
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
              auto_transcribe INTEGER NOT NULL,
              is_dark_mode INTEGER NOT NULL DEFAULT 0
            )
          ''');
        }

        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE recordings ADD COLUMN display_name TEXT',
          );
        }

        if (oldVersion < 5) {
          await db.execute(
            'ALTER TABLE recordings ADD COLUMN is_favorite INTEGER NOT NULL DEFAULT 0',
          );
        }

        if (oldVersion < 6) {
          await db.execute(
            'ALTER TABLE recordings ADD COLUMN deleted_at_ms INTEGER',
          );
        }

        if (oldVersion < 7) {
          await db.execute(
            'ALTER TABLE app_settings ADD COLUMN is_dark_mode INTEGER NOT NULL DEFAULT 0',
          );
        }

        if (oldVersion < 8) {
          await db.execute(
            'ALTER TABLE recordings ADD COLUMN group_name TEXT',
          );
          await db.execute('''
            CREATE TABLE IF NOT EXISTS folders (
              name TEXT PRIMARY KEY,
              created_at_ms INTEGER NOT NULL,
              is_favorite INTEGER NOT NULL DEFAULT 0
            )
          ''');
        }
      },
    );
  }
}
