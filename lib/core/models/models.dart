class FarmRecord {
  final int? id;
  final String title;
  final String description;
  final String type; // e.g., 'Planting', 'Harvest', 'Health'
  final DateTime date;
  final bool isSynced;
  final String entryMode; // 'Voice', 'Icon', 'Text'

  FarmRecord({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    this.isSynced = false,
    this.entryMode = 'Text',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'date': date.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
      'entryMode': entryMode,
    };
  }

  factory FarmRecord.fromMap(Map<String, dynamic> map) {
    return FarmRecord(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      date: DateTime.parse(map['date']),
      isSynced: map['isSynced'] == 1,
      entryMode: map['entryMode'],
    );
  }
}

enum ReminderType { planting, spraying, fertilizer, vaccination, other }

class Reminder {
  final int? id;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final ReminderType type;
  final bool isCompleted;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.type,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'type': type.index,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      scheduledDate: DateTime.parse(map['scheduledDate']),
      type: ReminderType.values[map['type']],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
