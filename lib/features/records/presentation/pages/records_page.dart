import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../ai/presentation/providers/voice_provider.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            color: AppColors.warning,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Icon(TablerIcons.wifi_off, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Offline mode — 3 records queued',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(TablerIcons.clock, size: 16, color: Color(0xFF7F3200)),
                  SizedBox(width: 8),
                  Text(
                    '3 records saved offline — pending sync',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7F3200),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pending sync queue',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildSyncItem('Planted maize — Field A', 'Voice record · 07:32 today', 'Queued', AppColors.amberAlert),
            _buildSyncItem('Morning milk yield — 16.5L', 'Icon entry · 06:15 today', 'Queued', AppColors.amberAlert),
            _buildSyncItem('Expense: fertilizer KSh 2,000', 'Finance entry · 08:45 today', 'Queued', AppColors.amberAlert),
            const SizedBox(height: 20),
            const Text(
              'Synced records',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildSyncItem('Tomato harvest 120kg — Field B', 'Yesterday · Synced', 'Synced', AppColors.primaryGreen),
            _buildSyncItem('Livestock vaccination', '2 days ago · Synced', 'Synced', AppColors.primaryGreen),
          ],
        ),
      ),
      floatingActionButton: Consumer<VoiceProvider>(
        builder: (context, voiceProvider, child) {
          return FloatingActionButton.extended(
            onPressed: () {
              if (voiceProvider.isRecording) {
                voiceProvider.stopRecording().then((text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Recorded: "$text"')),
                  );
                });
              } else {
                voiceProvider.startRecording();
              }
            },
            backgroundColor: voiceProvider.isRecording ? AppColors.dangerRed : AppColors.primaryGreen,
            icon: Icon(
              voiceProvider.isRecording ? TablerIcons.player_stop : TablerIcons.microphone,
              color: Colors.white,
            ),
            label: Text(
              voiceProvider.isRecording ? 'Stop Recording' : 'Voice Record',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncItem(String title, String subtitle, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
