import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/models/models.dart';

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();
    _reminders = await DatabaseHelper.instance.getAllReminders();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    await DatabaseHelper.instance.insertReminder(reminder);
    await loadReminders();
  }

  Future<void> toggleReminderCompletion(Reminder reminder) async {
    final updated = Reminder(
      id: reminder.id,
      title: reminder.title,
      description: reminder.description,
      scheduledDate: reminder.scheduledDate,
      type: reminder.type,
      isCompleted: !reminder.isCompleted,
    );
    await DatabaseHelper.instance.updateReminder(updated);
    await loadReminders();
  }

  // Pre-populate some demo reminders if none exist
  Future<void> checkAndSeedDemoData() async {
    final existing = await DatabaseHelper.instance.getAllReminders();
    if (existing.isEmpty) {
      final now = DateTime.now();
      await addReminder(Reminder(
        title: 'Plant Maize',
        description: 'Optimal window starts today for Central Kenya',
        scheduledDate: now.add(const Duration(days: 1)),
        type: ReminderType.planting,
      ));
      await addReminder(Reminder(
        title: 'Spray Tomatoes',
        description: 'Fungicide application for Field B',
        scheduledDate: now.add(const Duration(days: 3)),
        type: ReminderType.spraying,
      ));
      await addReminder(Reminder(
        title: 'Fertilize Coffee',
        description: 'Apply NPK 17:17:17',
        scheduledDate: now.add(const Duration(days: 5)),
        type: ReminderType.fertilizer,
      ));
      await addReminder(Reminder(
        title: 'Cow Vaccination',
        description: 'Foot and mouth disease booster',
        scheduledDate: now.add(const Duration(days: 7)),
        type: ReminderType.vaccination,
      ));
    }
  }
}
