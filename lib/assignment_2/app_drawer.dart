import 'package:flutter/material.dart';

import 'a2_data.dart';
import 'a2_theme.dart';
import 'about_screen.dart';
import 'home_screen.dart';
import 'list_screen.dart';

enum A2Page { home, list, about }

/// DRAWER MENU for easy switching between Home, List and About
class A2Drawer extends StatelessWidget {
  const A2Drawer({super.key, required this.current});

  final A2Page current;

  void _open(BuildContext context, A2Page page) {
    Navigator.pop(context); // close the drawer first
    if (page == current) return;

    if (page == A2Page.home) {
      // go back to Home (pop everything above it)
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
      return;
    }

    final Widget screen =
        page == A2Page.list ? const ListScreen() : const AboutScreen();

    if (current == A2Page.home) {
      Navigator.push(context, a2FadeRoute(screen));
    } else {
      // List <-> About: replace so the back button still returns to Home
      Navigator.pushReplacement(context, a2FadeRoute(screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: A2Colors.background,
      child: Column(
        children: [
          // ---- Header ----
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 28,
              20,
              22,
            ),
            decoration: const BoxDecoration(gradient: a2Gradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 34,
                    backgroundColor: A2Colors.peach,
                    backgroundImage: AssetImage(A2Student.avatar),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  A2Student.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  A2Student.email,
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _DrawerTile(
            icon: Icons.home_rounded,
            label: 'Home',
            subtitle: 'Dashboard',
            selected: current == A2Page.home,
            onTap: () => _open(context, A2Page.home),
          ),
          _DrawerTile(
            icon: Icons.view_list_rounded,
            label: 'Cities List',
            subtitle: 'ListView • 12 items',
            selected: current == A2Page.list,
            onTap: () => _open(context, A2Page.list),
          ),
          _DrawerTile(
            icon: Icons.person_rounded,
            label: 'About Me',
            subtitle: 'GridView • 6 items',
            selected: current == A2Page.about,
            onTap: () => _open(context, A2Page.about),
          ),
          // Shown only when Assignment 2 was opened from the Student Portal
          if (current == A2Page.home &&
              ModalRoute.of(context)?.isFirst == false)
            _DrawerTile(
              icon: Icons.logout_rounded,
              label: 'Exit Assignment',
              subtitle: 'Back to Student Portal',
              selected: false,
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.pop(context); // leave Home
              },
            ),
          const Spacer(),
          const Divider(indent: 20, endIndent: 20, color: A2Colors.border),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Row(
              children: [
                Icon(Icons.school_rounded,
                    size: 16, color: A2Colors.textSecondary),
                SizedBox(width: 8),
                Text(
                  'Assignment 2  •  MAD  •  ${A2Student.section}',
                  style: TextStyle(
                    fontSize: 12,
                    color: A2Colors.textSecondary,
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

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: selected ? A2Colors.peach : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          leading: Icon(
            icon,
            color: selected ? A2Colors.primary : A2Colors.textSecondary,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? A2Colors.primaryDark : A2Colors.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: A2Colors.textSecondary,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
