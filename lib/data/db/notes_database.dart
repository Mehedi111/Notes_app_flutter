import 'dart:async';

import 'package:notes_app/data/model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

  NoteDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB("notes.db");

    return _database;
  }

  Future<Database?> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final intType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute(
    '''
    CREATE TABLE $tableNotes (
    ${NoteColumn.id} $idType,
    ${NoteColumn.isImportant} $boolType,
    ${NoteColumn.number} $intType,
    ${NoteColumn.title} $textType,
    ${NoteColumn.description} $textType,
    ${NoteColumn.time} $textType
    )
    '''
    );
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db?.insert(tableNotes, note.toJson());

    return note.copy(id: id);
  }

  Future<Note?> readNote(int id) async {
    final db = await instance.database;

    final maps = await db?.query(tableNotes,
        columns: NoteColumn.columns,
        where: '${NoteColumn.id} = ?',
        whereArgs: [id]);

    if (maps != null && maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>?> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${NoteColumn.time} ASC';

    //final result
    // = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy

    final result = await db?.query(tableNotes, orderBy: orderBy);

    if (result != null) {
      return result.map((e) => Note.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  Future<int?> updateNote(Note note) async {
    final db = await instance.database;

    return db?.update(tableNotes, note.toJson(),
    where: '${NoteColumn.id} = ?',
    whereArgs: [note.id]);
  }

  Future<int?> delete(int id) async{
    final db = await instance.database;

    return await db?.delete(
      tableNotes,
      where: '${NoteColumn.id} = ?',
      whereArgs: [id]
    );
  }


  Future close() async {
    final db = await instance.database;
    db?.close();
  }
}
