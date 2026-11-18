import 'package:flutter/material.dart';

import 'a2_data.dart';
import 'a2_theme.dart';
import 'about_screen.dart';
import 'app_drawer.dart';
import 'list_screen.dart';

/// 2. HOME SCREEN
/// Opens List and About with Navigator.push. Drawer menu for quick switching.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/assignment2/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: a2AppBar(
        title: 'Home',
        leading: const A2MenuButton(),
      ),
      drawer: const A2Drawer(current: A2Page.home),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const A2StaggeredIn(index: 0, child: _GreetingCard()),
          const SizedBox(height: 16),
          const A2StaggeredIn(index: 1, child: _StatsRow()),
          const SizedBox(height: 22),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Explore',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: A2Colors.textPrimary,
              ),
            ),
          ),
          A2StaggeredIn(
            index: 2,
            child: _NavCard(
              icon: Icons.view_list_rounded,
              color: const Color(0xFF3D8BD9),
              title: 'Open List Screen',
              subtitle: 'ListView with 12 cities of Pakistan',
              onTap: () => Navigator.push(
                context,
                a2FadeRoute(const ListScreen()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          A2StaggeredIn(
            index: 3,
            child: _NavCard(
              icon: Icons.grid_view_rounded,
              color: A2Colors.primary,
              title: 'Open About Screen',
              subtitle: 'SliverAppBar + GridView with 6 items',
              onTap: () => Navigator.push(
                context,
                a2FadeRoute(const AboutScreen()),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const A2StaggeredIn(index: 4, child: _ChecklistCard()),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  const _GreetingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: a2Gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33B4582A),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 32,
              backgroundColor: A2Colors.peach,
              backgroundImage: AssetImage(A2Student.avatar),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assalam-o-Alaikum,',
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  A2Student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _WhitePill(text: 'SAP ${A2Student.sapId}'),
                    const _WhitePill(text: A2Student.section),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhitePill extends StatelessWidget {
  const _WhitePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(90)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Numbers count up when Home opens (TweenAnimationBuilder)
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatTile(value: 3, label: 'Screens')),
        SizedBox(width: 10),
        Expanded(child: _StatTile(value: 12, label: 'List items')),
        SizedBox(width: 10),
        Expanded(child: _StatTile(value: 6, label: 'Grid items')),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return A2Card(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value.toDouble()),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text(
              v.round().toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: A2Colors.primary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: A2Colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return A2Card(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                A2IconBadge(icon: icon, color: color, size: 50),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: A2Colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: A2Colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: A2Colors.peach,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: A2Colors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard();

  static const List<String> _points = [
    'Splash screen: logo scale + fade, auto-opens Home after 3 sec',
    'Navigator.push / Navigator.pop between Home, List & About',
    'Drawer menu for quick screen switching',
    'ListView (12 items) + GridView (6 items)',
    'Bonus: CustomScrollView + SliverAppBar, Hero animation',
  ];

  @override
  Widget build(BuildContext context) {
    return A2Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              A2IconBadge(
                icon: Icons.task_alt,
                color: A2Colors.success,
                size: 34,
                iconSize: 19,
                radius: 10,
              ),
              SizedBox(width: 10),
              Text(
                'What this app covers',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: A2Colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final p in _points)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 17,
                      color: A2Colors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: A2Colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
