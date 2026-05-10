import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../core/constants/colors.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../scheduling/presentation/pages/schedule_page.dart';

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
            _buildSummaryGrid(),
            const SizedBox(height: 20),
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildSectionTitle('Upcoming Tasks'),
            const SizedBox(height: 12),
            _buildActivityFeed(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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

  Widget _buildSummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard('Total Records', '148', TablerIcons.notes, AppColors.infoBlue, AppColors.infoLight),
        _buildSummaryCard('Loan Score', '74/100', TablerIcons.credit_card, AppColors.primaryGreen, AppColors.greenSurface),
        _buildSummaryCard('Maize Yield', '2.8 Tons', TablerIcons.plant_2, AppColors.amberAlert, AppColors.amberLight),
        _buildSummaryCard('M-Pesa Bal', 'KSh 8,750', TablerIcons.cash, AppColors.secondaryGreen, AppColors.greenLight),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, Color bgColor) {
    return Card(
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
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(TablerIcons.plus, 'Record', AppColors.primaryGreen),
        _buildActionButton(TablerIcons.calendar, 'Schedule', AppColors.secondaryGreen, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SchedulePage()));
        }),
        _buildActionButton(TablerIcons.robot, 'AI Help', AppColors.infoBlue),
        _buildActionButton(TablerIcons.file_report, 'Reports', AppColors.amberAlert),
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

  Widget _buildActivityFeed() {
    return Column(
      children: [
        _buildActivityItem(
          'Plant Maize',
          'Tomorrow · Optimal window',
          TablerIcons.plant_2,
          AppColors.primaryGreen,
        ),
        _buildActivityItem(
          'Spray Tomatoes',
          'In 3 days · Field B',
          TablerIcons.cloud_rain,
          AppColors.infoBlue,
        ),
        _buildActivityItem(
          'Fertilize Coffee',
          'In 5 days · NPK 17:17:17',
          TablerIcons.leaf,
          AppColors.secondaryGreen,
        ),
        _buildActivityItem(
          'Cow Vaccination',
          'In 7 days · FMD Booster',
          TablerIcons.vaccine,
          AppColors.amberAlert,
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
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
    );
  }
}
