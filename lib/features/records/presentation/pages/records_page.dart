import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/models/models.dart';
import '../../../ai/presentation/providers/voice_provider.dart';
import '../providers/record_provider.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RecordProvider>().loadRecords());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records'),
        actions: [
          Consumer<RecordProvider>(
            builder: (context, provider, child) {
              if (provider.isSyncing) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGreen),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(TablerIcons.refresh),
                onPressed: provider.queuedRecords.isEmpty ? null : () => provider.syncRecords(),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Consumer<RecordProvider>(
            builder: (context, provider, child) {
              final queuedCount = provider.queuedRecords.length;
              if (queuedCount == 0) return const SizedBox.shrink();
              return Container(
                color: AppColors.warning,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(TablerIcons.wifi_off, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Offline mode — $queuedCount records queued',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: Consumer<RecordProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.records.isEmpty) {
            return const Center(child: Text('No records found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (provider.queuedRecords.isNotEmpty) ...[
                const Text(
                  'Pending sync queue',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                ...provider.queuedRecords.map((r) => _buildSyncItem(r, AppColors.amberAlert)),
                const SizedBox(height: 20),
              ],
              if (provider.syncedRecords.isNotEmpty) ...[
                const Text(
                  'Synced records',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                ...provider.syncedRecords.map((r) => _buildSyncItem(r, AppColors.primaryGreen)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: Consumer2<VoiceProvider, RecordProvider>(
        builder: (context, voiceProvider, recordProvider, child) {
          return FloatingActionButton.extended(
            onPressed: () {
              if (voiceProvider.isRecording) {
                voiceProvider.stopRecording().then((text) {
                  recordProvider.addRecord(FarmRecord(
                    title: text,
                    description: 'Voice record · ${DateTime.now().hour}:${DateTime.now().minute}',
                    type: 'General',
                    date: DateTime.now(),
                    isSynced: false,
                    entryMode: 'Voice',
                  ));
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

  Widget _buildSyncItem(FarmRecord record, Color statusColor) {
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
            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
                Text(
                  record.description,
                  style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
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
              record.isSynced ? 'Synced' : 'Queued',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
