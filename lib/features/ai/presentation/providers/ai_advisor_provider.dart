import 'package:flutter/material.dart';
import '../../../../core/utils/weather_service.dart';

class AiAdvisorProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  Map<String, dynamic>? _realTimeWeather;
  String _weatherAdvice = 'Syncing weather data...';
  bool _isLoadingWeather = false;
  String? _error;

  Map<String, dynamic>? get realTimeWeather => _realTimeWeather;
  String get weatherAdvice => _weatherAdvice;
  bool get isLoadingWeather => _isLoadingWeather;
  String? get error => _error;

  // Mocking AI Insights based on Research Module F (Offline Fallback)
  final List<Map<String, dynamic>> _offlineInsights = [
    {
      'title': 'Offline Mode',
      'desc': 'You are currently offline. Showing last cached recommendations.',
      'type': 'status',
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
      'desc': 'Maize prices in Nairobi are predicted to rise by 12% in the next 2 weeks.',
      'type': 'market',
      'urgent': false,
    }
  ];

  List<Map<String, dynamic>> get insights {
    if (_realTimeWeather == null && _error != null) {
      return _offlineInsights;
    }
    
    final List<Map<String, dynamic>> currentInsights = [];
    
    if (_realTimeWeather != null) {
      currentInsights.add({
        'title': 'Live Weather: ${_realTimeWeather!['name']}',
        'desc': _weatherAdvice,
        'type': 'weather',
        'urgent': _weatherAdvice.contains('Rain'),
      });
    }

    currentInsights.addAll(_offlineInsights.where((i) => i['type'] != 'status'));
    return currentInsights;
  }

  Future<void> updateWeather(String city) async {
    _isLoadingWeather = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _weatherService.fetchWeather(city);
      _realTimeWeather = data;
      _weatherAdvice = _weatherService.getAdvice(data);
    } catch (e) {
      _error = e.toString();
      _weatherAdvice = 'Offline: Last known advice - Proceed with care.';
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  // Mocking Smart Analytics Data
  Map<String, double> get yieldData => {'Maize': 2.8, 'Beans': 1.2, 'Tomatoes': 4.5};
  Map<String, double> get expenseBreakdown => {'Seeds': 45, 'Labor': 30, 'Transport': 15, 'Other': 10};
}
