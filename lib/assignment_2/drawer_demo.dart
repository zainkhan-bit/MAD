import 'package:flutter/material.dart';

class DrawerDemoApp extends StatelessWidget {
  const DrawerDemoApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DrawerHomePage(),
  );
}

class DrawerHomePage extends StatelessWidget {
  const DrawerHomePage({super.key});

  void openPage(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Drawer Navigation')),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Student'),
            accountEmail: Text('student@example.com'),
            currentAccountPicture:
            CircleAvatar(child: Icon(Icons.person, size: 35)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Birthdays'),
            onTap: () => openPage(
                context, const SimplePage(title: 'Birthdays')),
          ),
          ListTile(
            leading: const Icon(Icons.sentiment_satisfied),
            title: const Text('Gratitude'),
            onTap: () => openPage(
                context, const SimplePage(title: 'Gratitude')),
          ),
          ListTile(
            leading: const Icon(Icons.access_alarm),
            title: const Text('Reminders'),
            onTap: () => openPage(
                context, const SimplePage(title: 'Reminders')),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => openPage(
                context, const SimplePage(title: 'Settings')),
          ),
        ],
      ),
    ),
    body: const Center(
        child: Text('Open the drawer using the menu icon')),
  );
}

class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
        child: Text('$title Page',
            style: const TextStyle(fontSize: 24))),
  );
}