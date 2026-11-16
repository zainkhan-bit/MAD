import 'package:flutter/material.dart';

class TabsDemoApp extends StatelessWidget {
  const TabsDemoApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TabsPage(),
  );
}

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('My Tabs'),
        bottom: const TabBar(tabs: [
          Tab(icon: Icon(Icons.cake), text: 'Birthdays'),
          Tab(icon: Icon(Icons.sentiment_satisfied), text: 'Gratitude'),
          Tab(icon: Icon(Icons.access_alarm), text: 'Reminders'),
        ]),
      ),
      body: const TabBarView(children: [
        Center(child: Text('Birthdays Page')),
        Center(child: Text('Gratitude Page')),
        Center(child: Text('Reminders Page')),
      ]),
    ),
  );
}