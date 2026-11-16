import 'package:flutter/material.dart';

class HeroAnimationApp extends StatelessWidget {
  const HeroAnimationApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HeroHomePage(),
  );
}

class HeroHomePage extends StatelessWidget {
  const HeroHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Hero Animation')),
    body: Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailPage()),
        ),
        child: const Hero(
          tag: 'paint-icon',
          child: Icon(Icons.format_paint, color: Colors.green, size: 80),
        ),
      ),
    ),
  );
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail Screen')),
    body: const Center(
      child: Hero(
        tag: 'paint-icon',
        child: Icon(Icons.format_paint, color: Colors.green, size: 220),
      ),
    ),
  );
}