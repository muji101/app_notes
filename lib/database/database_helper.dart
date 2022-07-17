import 'package:app_notes/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const TABLE_NOTES = 'notes';
  static const TABLE_NOTES_ID = 'id';
  static const TABLE_NOTES_NOTE = 'note';
  static const TABLE_NOTES_TITLE = 'title';
  static const TABLE_NOTES_ISPINNED = 'isPinned';
  static const TABLE_NOTES_UPDATEDAT = 'updated_at';
  static const TABLE_NOTES_CREATEDAT = 'created_at';

  //open database
  static Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'notes.db'),
      version: 3,
      onCreate: (newDb, version) {
        newDb.execute('''
        CREATE TABLE $TABLE_NOTES (
          $TABLE_NOTES_ID TEXT PIRMARY KEY,
          $TABLE_NOTES_TITLE TEXT,
          $TABLE_NOTES_NOTE TEXT,
          $TABLE_NOTES_ISPINNED INTEGER,
          $TABLE_NOTES_UPDATEDAT TEXT,
          $TABLE_NOTES_CREATEDAT TEXT
        )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion == 1 && newVersion == 2) {
          db.execute('''
            CREATE TABLE tess_upgrade(
              id TEXT PRIMARY KEY,
              title TEXT
            )
          ''');
        }

        if (oldVersion == 2 && newVersion == 3) {
          db.execute('''
            ALTER TABLE $TABLE_NOTES(
              ADD COLUMN test_column_baru INTEGER DEFAULT 0
            )
          ''');
        }
      },
    );
  }

  // select list note
  Future<List<Note>> getAllNote() async {
    final db = await DatabaseHelper.init();
    final results = await db.query('notes');

    //isi data query ke list note
    List<Note> listNote = [];
    results.forEach((data) {
      listNote.add(
        Note.fromDb(data),
      );
    });

    return listNote;
  }

  Future<void> insterAllNote(List<Note> listNote) async {
    final db = await DatabaseHelper.init();
    Batch batch = db.batch();

    listNote.forEach((note) {
      batch.insert(
        'notes',
        note.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    // perinatah insert di jalanin
    await batch.commit();
  }

  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper.init();

    await db.update(
      TABLE_NOTES,
      note.toDb(),
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> toggleIsPinned(
      String? id, bool isPinned, DateTime updatedAt) async {
    final db = await DatabaseHelper.init();

    await db.update(
      TABLE_NOTES,
      {
        TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
        TABLE_NOTES_UPDATEDAT: updatedAt.toIso8601String(),
      },
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(String? id) async {
    final db = await DatabaseHelper.init();
    await db.delete(
      TABLE_NOTES,
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertNote(Note note) async {
    final db = await DatabaseHelper.init();
    await db.insert(
      TABLE_NOTES,
      note.toDb(),
    );
  }
}
