import 'package:flutter/material.dart';
import '../widgets/input_slider.dart';
import '../widgets/numeric_input_field.dart';
import 'loading_page.dart';

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({super.key});

  @override
  State<DailyCheckInPage> createState() => _DailyCheckInPageState();
}

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  bool _isLoading = false;

  int age = 30;
  double sleepQuality = 7.0;
  int dailySteps = 8000;
  double caloriesBurned = 2200.0;
  int physicalActivityLevel = 1;
  int heartRate = 70;
  int socialInteraction = 3;
  int medicationUsage = 1;
  double sleepDuration = 7.0;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildMetricsSection(),
                  const SizedBox(height: 4),
                  _buildSleepSection(),
                  const SizedBox(height: 4),
                  _buildActivitySection(),
                  const SizedBox(height: 4),
                  _buildMedicationSection(),
                  const SizedBox(height: 8),
                  _buildSubmitButton(),
                  const SizedBox(height: 8),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade700,
            Colors.green.shade500,
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Health Check',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Track your daily well-being',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Metrics'),
            NumericInputField(
              label: 'Age (18-100)',
              value: age,
              onChanged: (value) => setState(() => age = value),
              min: 18,
              max: 100,
            ),
            const SizedBox(height: 6),
            InputSlider(
              label: 'Sleep Quality (1-10)',
              value: sleepQuality,
              min: 1,
              max: 10,
              divisions: 18,
              onChanged: (value) => setState(() => sleepQuality = value),
            ),
            const SizedBox(height: 6),
            InputSlider(
              label: 'Heart Rate (60-100 bpm)',
              value: heartRate.toDouble(),
              min: 60,
              max: 100,
              divisions: 40,
              onChanged: (value) => setState(() => heartRate = value.round()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Sleep Duration'),
            InputSlider(
              label: 'Sleep Duration (0-24 hours)',
              value: sleepDuration,
              min: 0,
              max: 24,
              divisions: 48,
              onChanged: (value) => setState(() => sleepDuration = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Activity Metrics'),
            NumericInputField(
              label: 'Daily Steps (0-11000)',
              value: dailySteps,
              onChanged: (value) => setState(() => dailySteps = value),
              min: 0,
              max: 11000,
            ),
            const SizedBox(height: 6),
            NumericInputField(
              label: 'Calories Burned (0-2900)',
              value: caloriesBurned.round(),
              onChanged: (value) => setState(() => caloriesBurned = value.toDouble()),
              min: 0,
              max: 2900,
            ),
            const SizedBox(height: 6),
            InputSlider(
              label: 'Physical Activity Level (Low, Medium, High)',
              value: physicalActivityLevel.toDouble(),
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (value) => setState(() => physicalActivityLevel = value.round()),
            ),
            const SizedBox(height: 6),
            InputSlider(
              label: 'Social Interaction (0-5)',
              value: socialInteraction.toDouble(),
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (value) => setState(() => socialInteraction = value.round()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Medication Usage'),
            DropdownButtonFormField<int>(
              value: medicationUsage,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('No')),
                DropdownMenuItem(value: 0, child: Text('Yes')),
              ],
              onChanged: (value) => setState(() => medicationUsage = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            colors: [Colors.green.shade700, Colors.green.shade500],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text(
            'Analyze',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    setState(() => _isLoading = true);

    try {
      final healthMetrics = {
        'age': age,
        'sleep_quality': sleepQuality,
        'daily_steps': dailySteps,
        'calories_burned': caloriesBurned,
        'physical_activity_level': physicalActivityLevel,
        'heart_rate': heartRate,
        'social_interaction': socialInteraction,
        'medication_usage': medicationUsage,
        'sleep_duration': sleepDuration
      };

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingPage(healthMetrics: healthMetrics),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}