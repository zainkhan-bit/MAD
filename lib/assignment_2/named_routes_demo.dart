import 'package:flutter/material.dart';

class NamedRoutesApp extends StatelessWidget {
  const NamedRoutesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const NamedHomePage(),
      '/about': (context) => const SimplePage(title: 'About'),
      '/contact': (context) => const SimplePage(title: 'Contact'),
    },
  );
}

class NamedHomePage extends StatelessWidget {
  const NamedHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/about'),
            child: const Text('Open About'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/contact'),
            child: const Text('Open Contact'),
          ),
        ],
      ),
    ),
  );
}

class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
        child: Text('$title Screen',
            style: const TextStyle(fontSize: 24))),
  );
}