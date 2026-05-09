import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shambabook.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE records (
  id $idType,
  title $textType,
  description $textType,
  type $textType,
  date $textType,
  isSynced $boolType,
  entryMode $textType
)
''');

    await db.execute('''
CREATE TABLE reminders (
  id $idType,
  title $textType,
  description $textType,
  scheduledDate $textType,
  type $intType,
  isCompleted $boolType
)
''');
  }

  // --- Record Methods ---
  Future<int> insertRecord(FarmRecord record) async {
    final db = await instance.database;
    return await db.insert('records', record.toMap());
  }

  Future<List<FarmRecord>> getAllRecords() async {
    final db = await instance.database;
    final result = await db.query('records', orderBy: 'date DESC');
    return result.map((json) => FarmRecord.fromMap(json)).toList();
  }

  // --- Reminder Methods ---
  Future<int> insertReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await instance.database;
    final result = await db.query('reminders', orderBy: 'scheduledDate ASC');
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
