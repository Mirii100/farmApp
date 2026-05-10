import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/models/models.dart';

class RecordProvider with ChangeNotifier {
  List<FarmRecord> _records = [];
  bool _isLoading = false;
  bool _isSyncing = false;

  List<FarmRecord> get records => _records;
  List<FarmRecord> get queuedRecords => _records.where((r) => !r.isSynced).toList();
  List<FarmRecord> get syncedRecords => _records.where((r) => r.isSynced).toList();
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();
    _records = await DatabaseHelper.instance.getAllRecords();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecord(FarmRecord record) async {
    await DatabaseHelper.instance.insertRecord(record);
    await loadRecords();
  }

  Future<void> syncRecords() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();

    // Mocking network delay
    await Future.delayed(const Duration(seconds: 2));

    final db = await DatabaseHelper.instance.database;
    await db.update(
      'records',
      {'isSynced': 1},
      where: 'isSynced = ?',
      whereArgs: [0],
    );

    await loadRecords();
    _isSyncing = false;
    notifyListeners();
  }

  Future<void> seedDemoData() async {
    final existing = await DatabaseHelper.instance.getAllRecords();
    if (existing.isEmpty) {
      final now = DateTime.now();
      await addRecord(FarmRecord(
        title: 'Morning milk yield — 16.5L',
        description: 'Icon entry · 06:15 today',
        type: 'Livestock',
        date: now,
        isSynced: false,
        entryMode: 'Icon',
      ));
      await addRecord(FarmRecord(
        title: 'Tomato harvest 120kg — Field B',
        description: 'Yesterday · Synced',
        type: 'Harvest',
        date: now.subtract(const Duration(days: 1)),
        isSynced: true,
        entryMode: 'Text',
      ));
    }
  }
}
