import 'package:flutter/material.dart';

import '../app_theme.dart';

class AnimatedCrossFadeWidgetDemo extends StatefulWidget {
  const AnimatedCrossFadeWidgetDemo({super.key});

  @override
  State<AnimatedCrossFadeWidgetDemo> createState() =>
      _AnimatedCrossFadeWidgetDemoState();
}

class _AnimatedCrossFadeWidgetDemoState
    extends State<AnimatedCrossFadeWidgetDemo> {
  bool _crossFadeStateShowFirst = true;

  void _crossFade() {
    setState(() {
      _crossFadeStateShowFirst = !_crossFadeStateShowFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Animated CrossFade - Zain Khan'),
        backgroundColor: AppColors.peach,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Muhammad Zain Khan Bio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _crossFade,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 500),
                    sizeCurve: Curves.bounceOut,
                    crossFadeState: _crossFadeStateShowFirst
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.peach,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.person, color: AppColors.primary, size: 36),
                          SizedBox(height: 8),
                          Text('Muhammad Zain Khan (Short Summary)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          SizedBox(height: 4),
                          Text('BS Software Engineering (5th Semester)', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    secondChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 36),
                          SizedBox(height: 8),
                          Text('Muhammad Zain Khan (Full Profile)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: 4),
                          Text(
                            'Specializing in Flutter Mobile App Development, Database Systems, PF, and Web Development at Riphah International University.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _crossFade,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Tap to Fade View'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
