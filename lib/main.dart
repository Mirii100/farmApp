import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/scheduling/presentation/providers/reminder_provider.dart';

import 'features/ai/presentation/providers/voice_provider.dart';
import 'features/ai/presentation/providers/ai_advisor_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReminderProvider()..checkAndSeedDemoData()),
        ChangeNotifierProvider(create: (_) => VoiceProvider()..init()),
        ChangeNotifierProvider(create: (_) => AiAdvisorProvider()),
      ],
      child: const ShambaBookApp(),
    ),
  );
}
...

class ShambaBookApp extends StatelessWidget {
  const ShambaBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShambaBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
