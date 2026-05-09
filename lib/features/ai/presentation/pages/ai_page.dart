import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/whatsapp_helper.dart';
import '../providers/ai_advisor_provider.dart';
import '../providers/voice_provider.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Shamba Advisor'),
        actions: [
          IconButton(
            icon: const Icon(TablerIcons.brand_whatsapp),
            onPressed: () {
              WhatsAppHelper.launchWhatsApp(
                phone: '+254712345678',
                message: 'Hello ShambaBook AI, I need help with my farm.',
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
            _buildVoiceCommandCard(context),
            const SizedBox(height: 24),
            _buildSectionTitle('AI Insights & Predictions'),
            const SizedBox(height: 12),
            _buildInsightList(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Agricultural Advisory'),
            const SizedBox(height: 12),
            _buildAdvisoryChat(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    );
  }

  Widget _buildVoiceCommandCard(BuildContext context) {
    return Consumer<VoiceProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (provider.isRecording) {
                    provider.stopRecording();
                  } else {
                    provider.startRecording();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(provider.isRecording ? 0.4 : 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    provider.isRecording ? TablerIcons.player_stop : TablerIcons.microphone,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                provider.isRecording ? 'Listening...' : 'Tap to Record / Command',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Supports Swahili, Kikuyu, Luo & English',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
              ),
              if (provider.lastTranscribedText.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '"${provider.lastTranscribedText}"',
                    style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightList(BuildContext context) {
    final insights = context.watch<AiAdvisorProvider>().insights;
    return Column(
      children: insights.map((insight) => _buildInsightCard(insight)).toList(),
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
    IconData icon;
    Color color;
    Color bgColor;

    switch (insight['type']) {
      case 'weather':
        icon = TablerIcons.cloud_rain;
        color = AppColors.infoBlue;
        bgColor = AppColors.infoLight;
        break;
      case 'disease':
        icon = TablerIcons.virus;
        color = AppColors.dangerRed;
        bgColor = AppColors.dangerLight;
        break;
      case 'market':
        icon = TablerIcons.trending_up;
        color = AppColors.primaryGreen;
        bgColor = AppColors.greenSurface;
        break;
      default:
        icon = TablerIcons.robot;
        color = AppColors.secondaryGreen;
        bgColor = AppColors.greenLight;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(insight['title'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
                      if (insight['urgent'] == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.amberAlert, borderRadius: BorderRadius.circular(4)),
                          child: const Text('URGENT', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(insight['desc'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryChat(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildChatMessage('How can I increase my maize yield this season?', true),
            const SizedBox(height: 10),
            _buildChatMessage('Based on your location and soil moisture, I recommend: 1. Top dressing with CAN in 2 weeks. 2. Maintaining weeding schedule...', false),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Ask Shamba AI (Voice or Text)…',
                suffixIcon: const Icon(TablerIcons.send, size: 18, color: AppColors.primaryGreen),
                prefixIcon: const Icon(TablerIcons.microphone, size: 18),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(left: isUser ? 40 : 0, right: isUser ? 0 : 40),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryGreen : AppColors.backgroundTertiary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: isUser ? Colors.white : AppColors.textPrimary, height: 1.4),
        ),
      ),
    );
  }
}
