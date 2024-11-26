import 'package:feelhealmental/screens/recommendations_page.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final Map<String, dynamic> predictionResults;

  const ResultsPage({super.key, required this.predictionResults});

  @override
  Widget build(BuildContext context) {
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
          'Analysis Results',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultsSection(),
            const SizedBox(height: 24),
            _buildScoreBreakdown(),
            const SizedBox(height: 24),
            _buildRiskFactorsSection(),
            const SizedBox(height: 24),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    // Extract prediction details from the updated API response format
    final details = predictionResults['prediction_details'] as Map<String, dynamic>? ?? {};
    final anxietyLevel = predictionResults['anxiety_level'] ?? 0.0;
    final depressionLevel = predictionResults['depression_level'] ?? 0.0;
    final confidenceScore = details['confidence_score'] ?? 0.0;

    // Convert numerical levels to descriptive text
    String getLevel(double value) {
      if (value > 0.7) return 'High';
      if (value > 0.3) return 'Medium';
      return 'Low';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mental Health Analysis',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Based on your provided health metrics',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildResultCard(
                'Anxiety Level',
                getLevel(anxietyLevel),
                confidenceScore * 100,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildResultCard(
                'Depression Level',
                getLevel(depressionLevel),
                confidenceScore * 100,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultCard(
      String title,
      String level,
      double confidence,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            level,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: confidence / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${confidence.toStringAsFixed(1)}% confidence',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    // Get the raw scores directly from the prediction results
    final anxietyLevel = predictionResults['anxiety_level'] ?? 0.0;
    final depressionLevel = predictionResults['depression_level'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Score Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildScoreItem(
                  'Anxiety',
                  anxietyLevel * 100,
                  Colors.orange,
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildScoreItem(
                  'Depression',
                  depressionLevel * 100,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreItem(String title, double score, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskFactorsSection() {
    // Extract risk factors based on the input metrics
    final details = predictionResults['prediction_details'] as Map<String, dynamic>? ?? {};
    final anxietyRisk = details['anxiety_risk'] ?? 'low';
    final depressionRisk = details['depression_risk'] ?? 'low';

    List<Map<String, dynamic>> riskFactors = [];

    // Add risk factors based on the risk levels
    if (anxietyRisk != 'low') {
      riskFactors.add({
        'factor': 'Anxiety Risk Level',
        'impact': anxietyRisk == 'high' ? 0.8 : 0.5,
      });
    }
    if (depressionRisk != 'low') {
      riskFactors.add({
        'factor': 'Depression Risk Level',
        'impact': depressionRisk == 'high' ? 0.8 : 0.5,
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Risk Factors',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (riskFactors.isEmpty)
          Center(
            child: Text(
              'No significant risk factors identified',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          )
        else
          ...riskFactors.map((factor) => _buildRiskFactorItem(
            factor['factor'] as String,
            factor['impact'] as double,
          )),
      ],
    );
  }

  Widget _buildRiskFactorItem(String factor, double impact) {
    final color = impact > 0.5 ? Colors.orange : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            impact > 0.5 ? Icons.warning_amber_rounded : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: impact,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${(impact * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendationsScreen(
                predictionResults: predictionResults,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'View Recommendations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}