import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthService {
  static const String baseUrl = 'https://feel-heal-api.onrender.com';

  Future<Map<String, dynamic>> submitHealthData({
    required int age,
    required double sleepQuality,
    required int dailySteps,
    required double caloriesBurned,
    required String physicalActivityLevel,
    required int socialInteraction,
    required int heartRate,
    required String medicationUsage,
    required double sleepDuration,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Age': age,
          'Sleep_Quality': sleepQuality,
          'Daily_Steps': dailySteps,
          'Calories_Burned': caloriesBurned,
          'Physical_Activity_Level': physicalActivityLevel,
          'Social_Interaction': socialInteraction,
          'Heart_Rate': heartRate,
          'Medication_Usage': medicationUsage,
          'Sleep_Duration': sleepDuration,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to analyze data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit data: $e');
    }
  }
}