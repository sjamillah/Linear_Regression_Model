import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget {
  final Map<String, dynamic> predictionResults;

  const RecommendationsScreen({
    super.key,
    required this.predictionResults,
  });

  List<String> _generateRecommendations() {
    List<String> recommendations = [];

    // Extract prediction details
    final details = predictionResults['prediction_details'] as Map<String, dynamic>? ?? {};

    // Get anxiety and depression risk levels
    final anxietyRisk = details['anxiety_risk'] ?? 'low';
    final depressionRisk = details['depression_risk'] ?? 'low';

    // Add anxiety-based recommendations
    if (anxietyRisk == 'high') {
      recommendations.addAll([
        'Practice daily mindfulness or meditation exercises',
        'Schedule regular check-ins with a mental health professional',
        'Try breathing exercises when feeling overwhelmed',
        'Create a stress management plan',
        'Consider anxiety management therapy sessions',
      ]);
    } else if (anxietyRisk == 'medium') {
      recommendations.addAll([
        'Incorporate regular exercise into your routine',
        'Practice relaxation techniques',
        'Maintain a consistent sleep schedule',
        'Try guided meditation apps',
        'Keep a worry journal to track triggers',
      ]);
    } else {
      recommendations.addAll([
        'Maintain your current stress management practices',
        'Continue with regular exercise and relaxation routines',
        'Practice preventive self-care',
        'Monitor any changes in anxiety levels',
        'Keep up with your healthy coping mechanisms',
      ]);
    }

    // Add depression-based recommendations
    if (depressionRisk == 'high') {
      recommendations.addAll([
        'Reach out to a mental health professional for support',
        'Establish a daily routine with achievable goals',
        'Stay connected with friends and family',
        'Consider joining support groups',
        'Track your mood changes daily',
      ]);
    } else if (depressionRisk == 'medium') {
      recommendations.addAll([
        'Engage in regular physical activity',
        'Maintain social connections',
        'Practice self-care activities daily',
        'Set small, achievable goals',
        'Create a positive daily routine',
      ]);
    } else {
      recommendations.addAll([
        'Continue engaging in enjoyable activities',
        'Maintain your social connections',
        'Keep up with your regular exercise routine',
        'Practice gratitude journaling',
        'Stay mindful of your emotional well-being',
      ]);
    }

    // Get raw prediction values
    final anxietyLevel = predictionResults['anxiety_level'] as double? ?? 0.0;
    final depressionLevel = predictionResults['depression_level'] as double? ?? 0.0;

    // Add recommendations based on severity levels
    if (anxietyLevel > 0.7 || depressionLevel > 0.7) {
      recommendations.addAll([
        'Consider professional mental health support',
        'Focus on immediate stress reduction techniques',
        'Establish a strong support network',
        'Prioritize self-care activities',
      ]);
    }

    // Add lifestyle-based recommendations
    recommendations.addAll([
      'Maintain a regular sleep schedule',
      'Exercise for at least 30 minutes daily',
      'Practice mindfulness and meditation',
      'Stay connected with loved ones',
      'Keep a daily journal of thoughts and feelings',
    ]);

    return recommendations.toSet().toList(); // Remove duplicates
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = _generateRecommendations();
    final categories = _categorizeRecommendations(recommendations);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recommendations',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
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
            _buildHeader(),
            const SizedBox(height: 24),
            if (categories.isEmpty)
              Center(
                child: Text(
                  'No recommendations available',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              )
            else
              ...categories.entries.map((entry) => _buildCategorySection(
                entry.key,
                entry.value,
              )),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final details = predictionResults['prediction_details'] as Map<String, dynamic>? ?? {};
    final anxietyRisk = details['anxiety_risk'] ?? 'low';
    final depressionRisk = details['depression_risk'] ?? 'low';

    String headerText = 'Based on your mental health analysis, ';

    if (anxietyRisk == 'high' || depressionRisk == 'high') {
      headerText += 'we recommend focusing on immediate self-care and professional support.';
    } else if (anxietyRisk == 'medium' || depressionRisk == 'medium') {
      headerText += 'we suggest implementing these strategies to improve your well-being.';
    } else {
      headerText += 'here are some tips to maintain your mental well-being.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                'Personalized Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            headerText,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<String> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...recommendations.map((recommendation) => _buildRecommendationCard(
          recommendation,
          _getCategoryIcon(category),
          _getCategoryColor(category),
        )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecommendationCard(String recommendation, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to learn more',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calendar feature coming soon')),
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Add to Calendar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
            icon: const Icon(Icons.share),
            label: const Text('Share Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, List<String>> _categorizeRecommendations(List<String> recommendations) {
    final categories = <String, List<String>>{
      'Mental Well-being': [],
      'Physical Health': [],
      'Social Connection': [],
      'Lifestyle Changes': [],
    };

    for (final recommendation in recommendations) {
      if (recommendation.toLowerCase().contains('anxiety') ||
          recommendation.toLowerCase().contains('stress') ||
          recommendation.toLowerCase().contains('meditation') ||
          recommendation.toLowerCase().contains('mental')) {
        categories['Mental Well-being']!.add(recommendation);
      } else if (recommendation.toLowerCase().contains('exercise') ||
          recommendation.toLowerCase().contains('sleep') ||
          recommendation.toLowerCase().contains('physical')) {
        categories['Physical Health']!.add(recommendation);
      } else if (recommendation.toLowerCase().contains('social') ||
          recommendation.toLowerCase().contains('connect') ||
          recommendation.toLowerCase().contains('support') ||
          recommendation.toLowerCase().contains('family') ||
          recommendation.toLowerCase().contains('friend')) {
        categories['Social Connection']!.add(recommendation);
      } else {
        categories['Lifestyle Changes']!.add(recommendation);
      }
    }

    return categories..removeWhere((key, value) => value.isEmpty);
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mental Well-being':
        return Icons.psychology;
      case 'Physical Health':
        return Icons.directions_run;
      case 'Social Connection':
        return Icons.people;
      case 'Lifestyle Changes':
        return Icons.lightbulb;
      default:
        return Icons.star;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Mental Well-being':
        return Colors.purple;
      case 'Physical Health':
        return Colors.green;
      case 'Social Connection':
        return Colors.orange;
      case 'Lifestyle Changes':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}