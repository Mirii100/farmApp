import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/models/models.dart';
import '../providers/reminder_provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ReminderProvider>().loadReminders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Schedule'),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.reminders.isEmpty) {
            return const Center(child: Text('No upcoming activities.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCalendarPreview(),
              const SizedBox(height: 24),
              Text(
                'Upcoming Tasks',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...provider.reminders.map((reminder) => _buildReminderItem(context, reminder, provider)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show dialog to add new reminder
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(TablerIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'May 2026',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(TablerIcons.chevron_left, size: 18)),
                    IconButton(onPressed: () {}, icon: const Icon(TablerIcons.chevron_right, size: 18)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Mock calendar days
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 7,
              children: List.generate(31, (index) {
                final day = index + 1;
                bool hasTask = [10, 12, 14, 16].contains(day);
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: day == 9 ? AppColors.primaryGreen : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 12,
                            color: day == 9 ? Colors.white : AppColors.textPrimary,
                            fontWeight: day == 9 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (hasTask)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(color: AppColors.amberAlert, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(BuildContext context, Reminder reminder, ReminderProvider provider) {
    IconData icon;
    Color color;

    switch (reminder.type) {
      case ReminderType.planting:
        icon = TablerIcons.plant_2;
        color = AppColors.primaryGreen;
        break;
      case ReminderType.spraying:
        icon = TablerIcons.cloud_rain;
        color = AppColors.infoBlue;
        break;
      case ReminderType.fertilizer:
        icon = TablerIcons.leaf;
        color = AppColors.secondaryGreen;
        break;
      case ReminderType.vaccination:
        icon = TablerIcons.vaccine;
        color = AppColors.amberAlert;
        break;
      default:
        icon = TablerIcons.calendar;
        color = AppColors.textTertiary;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reminder.description, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(TablerIcons.clock, size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(reminder.scheduledDate),
                  style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: reminder.isCompleted,
          activeColor: AppColors.primaryGreen,
          onChanged: (value) {
            provider.toggleReminderCompletion(reminder);
          },
        ),
      ),
    );
  }
}
