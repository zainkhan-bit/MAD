import 'package:flutter/material.dart';

import '../app_theme.dart';

class DrawerDemoApp extends StatelessWidget {
  const DrawerDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        home: const DrawerHomePage(),
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
        appBar: AppBar(
          title: const Text('Zain Khan Portal - Drawer'),
          backgroundColor: AppColors.peach,
          elevation: 0,
        ),
        drawer: Drawer(
          backgroundColor: AppColors.background,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text(
                  'Muhammad Zain Khan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: const Text('66157@students.riphah.edu.pk'),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: AppColors.primary, size: 35),
                      ),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: AppColors.primary),
                title: const Text('Home'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.school, color: AppColors.primary),
                title: const Text('Academic Info'),
                onTap: () => openPage(
                  context,
                  const SimplePage(
                    title: 'Academic Info',
                    content: 'Program: BS Software Engineering (5th Semester)\nUniversity: Riphah International University',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.auto_stories, color: AppColors.primary),
                title: const Text('About Me'),
                onTap: () => openPage(
                  context,
                  const SimplePage(
                    title: 'About Me',
                    content: 'Software Engineering student specializing in Flutter Mobile App Development, DBMS, and Web Development.',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail, color: AppColors.primary),
                title: const Text('Contact Details'),
                onTap: () => openPage(
                  context,
                  const SimplePage(
                    title: 'Contact Details',
                    content: 'Email: 66157@students.riphah.edu.pk\nLocation: Islamabad, Pakistan',
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.textSecondary),
                title: const Text('Settings'),
                onTap: () => openPage(
                  context,
                  const SimplePage(title: 'Settings', content: 'Application Settings'),
                ),
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/profile.jpg',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 80, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Muhammad Zain Khan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  const Text('66157@students.riphah.edu.pk', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  const Text('Open the drawer using the menu icon above to navigate.'),
                ],
              ),
            ),
          ),
        ),
      );
}

class SimplePage extends StatelessWidget {
  final String title;
  final String content;

  const SimplePage({super.key, required this.title, this.content = ''});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: AppColors.peach,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  if (content.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}
