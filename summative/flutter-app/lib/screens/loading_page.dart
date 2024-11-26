import 'package:flutter/material.dart';
import '../services/health_service.dart';
import 'results_page.dart';

class LoadingPage extends StatefulWidget {
  final Map<String, dynamic> healthMetrics;

  const LoadingPage({
    super.key,
    required this.healthMetrics,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  final HealthService _healthService = HealthService();
  bool _isAnalyzing = true;
  String _statusText = 'Analyzing your health data';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
    _analyzeMentalHealth();
  }

  Future<void> _analyzeMentalHealth() async {
    try {
      setState(() {
        _statusText = 'Processing your information';
        _isAnalyzing = true;
      });

      // Converting physical activity level to string format
      String getActivityLevel(int level) {
        switch (level) {
          case 0:
            return 'low';
          case 1:
            return 'medium';
          case 2:
            return 'high';
          default:
            return 'medium';
        }
      }

      final results = await _healthService.submitHealthData(
        age: widget.healthMetrics['age'] as int,
        sleepQuality: widget.healthMetrics['sleep_quality'] as double,
        dailySteps: widget.healthMetrics['daily_steps'] as int,
        caloriesBurned: widget.healthMetrics['calories_burned'] as double,
        physicalActivityLevel: getActivityLevel(widget.healthMetrics['physical_activity_level'] as int),
        socialInteraction: widget.healthMetrics['social_interaction'] as int,
        heartRate: widget.healthMetrics['heart_rate'] as int,
        medicationUsage: widget.healthMetrics['medication_usage'] == 1 ? 'no' : 'yes',
        sleepDuration: widget.healthMetrics['sleep_duration'] as double,
      );

      setState(() {
        _statusText = 'Generating your personalized insights';
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isAnalyzing = false;
        _statusText = 'Analysis complete, preparing your results';
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(predictionResults: results),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _statusText = 'Analysis failed';
        });
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Unable to process your health data:'),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _isAnalyzing ? null : () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildBodySilhouette(),
              const SizedBox(height: 40),
              _buildProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                _isAnalyzing ? 'Analyzing' : 'Analysis Complete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodySilhouette() {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 300),
            painter: BodySilhouettePainter(),
          ),
          if (_isAnalyzing)
            Positioned(
              top: 90,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Analyzing data...',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _isAnalyzing ? _progressAnimation.value : 1.0,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isAnalyzing ? Colors.green.shade400 : Colors.blue,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BodySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade200.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Head
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height * 0.15),
      radius: size.width * 0.15,
    ));

    // Body
    path.moveTo(size.width * 0.3, size.height * 0.25);
    path.lineTo(size.width * 0.7, size.height * 0.25);
    path.lineTo(size.width * 0.65, size.height * 0.6);
    path.lineTo(size.width * 0.35, size.height * 0.6);
    path.close();

    // Arms
    path.moveTo(size.width * 0.3, size.height * 0.25);
    path.lineTo(size.width * 0.15, size.height * 0.4);
    path.lineTo(size.width * 0.25, size.height * 0.4);
    path.close();

    path.moveTo(size.width * 0.7, size.height * 0.25);
    path.lineTo(size.width * 0.85, size.height * 0.4);
    path.lineTo(size.width * 0.75, size.height * 0.4);
    path.close();

    // Legs
    path.moveTo(size.width * 0.35, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height);
    path.lineTo(size.width * 0.4, size.height);
    path.close();

    path.moveTo(size.width * 0.65, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height);
    path.lineTo(size.width * 0.7, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}