import 'package:notes_app/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    return await openDatabase(join(await getDatabasesPath(), "notes_app.db"),
        onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        creationDate DATE
      )
      ''');
    }, version: 1);
  }

  createNote(NoteModel note) async {
    final db = await database;
    db.insert(
      "notes",
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<dynamic> getNotes() async {
    final db = await database;
    var result = await db.query("notes");
    if (result.length == 0) {
      return Null;
    } else {
      var resultMap = result.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }
}
