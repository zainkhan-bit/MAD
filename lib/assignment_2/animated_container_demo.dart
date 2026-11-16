import 'package:flutter/material.dart';

import '../app_theme.dart';

class AnimatedContainerWidgetDemo extends StatefulWidget {
  const AnimatedContainerWidgetDemo({super.key});

  @override
  State<AnimatedContainerWidgetDemo> createState() =>
      _AnimatedContainerWidgetDemoState();
}

class _AnimatedContainerWidgetDemoState
    extends State<AnimatedContainerWidgetDemo> {
  double _height = 120.0;
  double _width = 160.0;
  bool _isExpanded = false;

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
      _width = _isExpanded ? 300.0 : 160.0;
      _height = _isExpanded ? 180.0 : 120.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Animated Container - Zain Khan'),
        backgroundColor: AppColors.peach,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isExpanded ? AppColors.primaryDark : AppColors.primary,
                  borderRadius: BorderRadius.circular(_isExpanded ? 28 : 16),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33B4582A), blurRadius: 12, offset: Offset(0, 6)),
                  ],
                ),
                height: _height,
                width: _width,
                child: Center(
                  child: InkWell(
                    onTap: _toggleContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app, color: Colors.white, size: 28),
                        const SizedBox(height: 6),
                        const Text(
                          'Muhammad Zain Khan',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Tap to ${_isExpanded ? "Shrink" : "Expand"}\nWidth: ${_width.toInt()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
