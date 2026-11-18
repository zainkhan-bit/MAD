import 'dart:async';

import 'package:flutter/material.dart';

import 'a2_data.dart';
import 'a2_theme.dart';
import 'home_screen.dart';

/// 1. SPLASH SCREEN WITH ANIMATION
/// Logo scales up + fades in, then after 3 seconds the app moves to Home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Logo: scale 0 -> 1 with a little bounce
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
    );
    // Logo: fade in
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
    );
    // Title: fade in + slide up after the logo
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(_textFade);

    _controller.forward();

    // After 3 seconds go to Home automatically
    _timer = Timer(const Duration(seconds: 3), _goToHome);
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      a2FadeRoute(const HomeScreen(), name: HomeScreen.routeName),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: a2Gradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              // ---- Animated logo ----
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(45),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: A2Colors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // ---- Animated title ----
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      const Text(
                        'Riphah Student Portal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ANIMATION  •  NAVIGATION  •  LISTS',
                        style: TextStyle(
                          color: Colors.white.withAlpha(215),
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // ---- 3 second loading bar ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        color: Colors.white,
                        backgroundColor: Colors.white.withAlpha(60),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              FadeTransition(
                opacity: _textFade,
                child: Text(
                  '${A2Student.name}  •  ${A2Student.sapId}',
                  style: TextStyle(
                    color: Colors.white.withAlpha(230),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Assignment 2  •  MAD  •  ${A2Student.section}',
                style: TextStyle(
                  color: Colors.white.withAlpha(170),
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
