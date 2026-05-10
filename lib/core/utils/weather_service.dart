import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Using OpenWeatherMap as mentioned in the proposal
  // User should replace this with their actual API key
  final String _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY'; 
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      // Re-throw to be handled by the provider (e.g., offline state)
      rethrow;
    }
  }

  // Simplified alert logic based on weather data
  String getAdvice(Map<String, dynamic> weatherData) {
    final main = weatherData['weather'][0]['main'].toString().toLowerCase();
    final temp = weatherData['main']['temp'];

    if (main.contains('rain')) {
      return 'Rain detected. Delay spraying crops to prevent chemical runoff.';
    } else if (temp > 30) {
      return 'High temperatures detected. Increase irrigation frequency for sensitive crops.';
    }
    return 'Conditions are stable. Proceed with scheduled activities.';
  }
}
