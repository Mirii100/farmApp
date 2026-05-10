import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/colors.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../scheduling/presentation/pages/schedule_page.dart';
import '../../../records/presentation/providers/record_provider.dart';
import '../../../scheduling/presentation/providers/reminder_provider.dart';
import '../../../records/presentation/pages/records_page.dart';
import '../../../finance/presentation/pages/finance_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../../../ai/presentation/pages/ai_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShambaBook'),
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.user_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, James',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Waweru Farm Overview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            _buildSummaryGrid(context),
            const SizedBox(height: 20),
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildSectionTitle('Upcoming Tasks'),
            const SizedBox(height: 12),
            _buildActivityFeed(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AiPage()));
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(TablerIcons.microphone, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context) {
    final recordCount = context.watch<RecordProvider>().records.length;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(context, 'Total Records', recordCount.toString(), TablerIcons.notes, AppColors.infoBlue, AppColors.infoLight, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RecordsPage()));
        }),
        _buildSummaryCard(context, 'Loan Score', '74/100', TablerIcons.credit_card, AppColors.primaryGreen, AppColors.greenSurface),
        _buildSummaryCard(context, 'Maize Yield', '2.8 Tons', TablerIcons.plant_2, AppColors.amberAlert, AppColors.amberLight),
        _buildSummaryCard(context, 'M-Pesa Bal', 'KSh 8,750', TablerIcons.cash, AppColors.secondaryGreen, AppColors.greenLight, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FinancePage()));
        }),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color, Color bgColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 18),
                  const Icon(TablerIcons.chevron_right, color: AppColors.textQuaternary, size: 14),
                ],
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(TablerIcons.plus, 'Record', AppColors.primaryGreen, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const RecordsPage()));
        }),
        _buildActionButton(TablerIcons.calendar, 'Schedule', AppColors.secondaryGreen, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage()));
        }),
        _buildActionButton(TablerIcons.robot, 'AI Help', AppColors.infoBlue, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AiPage()));
        }),
        _buildActionButton(TablerIcons.file_report, 'Reports', AppColors.amberAlert, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsPage()));
        }),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed(BuildContext context) {
    final reminders = context.watch<ReminderProvider>().reminders.take(4).toList();
    if (reminders.isEmpty) {
      return const Center(child: Text('No upcoming tasks.', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)));
    }
    return Column(
      children: reminders.map((reminder) {
        Color color;
        IconData icon;
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
        return _buildActivityItem(
          context,
          reminder.title,
          '${DateFormat('MMM dd').format(reminder.scheduledDate)} · ${reminder.description}',
          icon,
          color,
        );
      }).toList(),
    );
  }

  Widget _buildActivityItem(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(TablerIcons.chevron_right, color: AppColors.textQuaternary, size: 16),
          ],
        ),
      ),
    );
  }
}
