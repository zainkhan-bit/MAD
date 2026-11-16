import 'package:flutter/material.dart';

import '../app_theme.dart';

class TabsDemoApp extends StatelessWidget {
  const TabsDemoApp({super.key});

  @override
  Widget build(BuildContext context) => const TabsPage();
}

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Zain Khan Profile - Tabs'),
            backgroundColor: AppColors.peach,
            elevation: 0,
            leading: IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            bottom: const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(icon: Icon(Icons.person), text: 'Personal'),
                Tab(icon: Icon(Icons.auto_stories), text: 'About'),
                Tab(icon: Icon(Icons.contact_phone), text: 'Contact'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Personal Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AppCard(
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/profile.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 80, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Muhammad Zain Khan',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const Text('Software Engineer', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      const Divider(),
                      const ListTile(leading: Icon(Icons.email, color: AppColors.primary), title: Text('66157@students.riphah.edu.pk')),
                      const ListTile(leading: Icon(Icons.school, color: AppColors.primary), title: Text('Riphah International University')),
                      const ListTile(leading: Icon(Icons.class_, color: AppColors.primary), title: Text('BS Software Engineering (5th Sem)')),
                    ],
                  ),
                ),
              ),

              // About Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('About Me', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      SizedBox(height: 12),
                      Text(
                        'I am a passionate Software Engineering student at Riphah International University (5th Semester). '
                        'I specialize in Mobile App Development using Flutter, Database Management Systems, Programming Fundamentals (PF), and Website Development.',
                        style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),

              // Contact Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AppCard(
                  child: Column(
                    children: const [
                      Text('Contact Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      SizedBox(height: 16),
                      ListTile(leading: Icon(Icons.email_outlined, color: AppColors.primary), title: Text('Email'), subtitle: Text('66157@students.riphah.edu.pk')),
                      ListTile(leading: Icon(Icons.phone_outlined, color: AppColors.primary), title: Text('Phone'), subtitle: Text('+92 300 0000000')),
                      ListTile(leading: Icon(Icons.location_on_outlined, color: AppColors.primary), title: Text('Location'), subtitle: Text('Islamabad, Pakistan')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
