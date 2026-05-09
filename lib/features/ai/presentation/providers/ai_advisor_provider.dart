import 'package:flutter/material.dart';

class AiAdvisorProvider with ChangeNotifier {
  // Mocking AI Insights based on Research Module F
  final List<Map<String, dynamic>> _insights = [
    {
      'title': 'Weather Alert',
      'desc': 'Rain expected tomorrow (80% probability). Delay spraying your tomatoes to avoid runoff.',
      'type': 'weather',
      'urgent': true,
    },
    {
      'title': 'Disease Prediction',
      'desc': 'High humidity detected. Watch for signs of Early Blight in your potato crop.',
      'type': 'disease',
      'urgent': true,
    },
    {
      'title': 'Market Price',
      'desc': 'Maize prices in Nairobi are predicted to rise by 12% in the next 2 weeks. Consider storing for later sale.',
      'type': 'market',
      'urgent': false,
    },
    {
      'title': 'Crop Advisory',
      'desc': 'Your maize is at growth stage V6. Optimal time for top-dressing with CAN fertilizer.',
      'type': 'advisory',
      'urgent': false,
    }
  ];

  List<Map<String, dynamic>> get insights => _insights;

  // Mocking Smart Analytics Data
  Map<String, double> get yieldData => {
    'Maize': 2.8,
    'Beans': 1.2,
    'Tomatoes': 4.5,
  };

  Map<String, double> get expenseBreakdown => {
    'Seeds': 45,
    'Labor': 30,
    'Transport': 15,
    'Other': 10,
  };
}
