import 'package:flutter/material.dart';

import 'a2_theme.dart';
import 'splash_screen.dart';

/// ASSIGNMENT 2 — Flutter app with Animation, Navigation and Scrollable Lists
///
/// Flow:  SplashScreen (3 sec) -> HomeScreen -> ListScreen / AboutScreen
///
/// Run it on its own:
///   flutter run -t lib/main_assignment2.dart
class Assignment2App extends StatelessWidget {
  const Assignment2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assignment 2 - Zain Khan',
      theme: buildA2Theme(),
      // On Chrome / laptop the app is shown inside a phone-sized frame
      builder: (context, child) => _PhoneFrame(child: child ?? const SizedBox()),
      home: const SplashScreen(),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Real phone: no frame
        if (constraints.maxWidth <= 500) return child;

        final double height =
            constraints.maxHeight - 48 < 860 ? constraints.maxHeight - 48 : 860;

        return Container(
          color: const Color(0xFF2E2420),
          alignment: Alignment.center,
          child: Container(
            width: 400,
            height: height,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(46),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: Size(380, height - 20),
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
