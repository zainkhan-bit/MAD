import 'package:flutter/material.dart';

import 'a2_data.dart';
import 'a2_theme.dart';
import 'app_drawer.dart';
import 'detail_screen.dart';

/// 3b. ABOUT SCREEN -> GridView with 6 items.
/// Bonus: CustomScrollView + SliverAppBar (header collapses while scrolling).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const A2Drawer(current: A2Page.about),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: A2Colors.primary,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            leading: const A2BackButton(color: Colors.white), // Navigator.pop
            actions: const [A2MenuButton(color: Colors.white)],
            title: const Text(
              'About Me',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            flexibleSpace: const FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _AboutHeader(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _AboutCard(),
                  const SizedBox(height: 22),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          'My Tech Stack',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: A2Colors.textPrimary,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'GridView • 6 items',
                          style: TextStyle(
                            fontSize: 12,
                            color: A2Colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ---- GridView with 6 items ----
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: techStack.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.08,
                    ),
                    itemBuilder: (context, index) => A2StaggeredIn(
                      index: index,
                      child: _SkillTile(item: techStack[index], index: index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: a2Gradient),
      padding: const EdgeInsets.only(bottom: 22),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 46,
              backgroundColor: A2Colors.peach,
              backgroundImage: AssetImage(A2Student.avatar),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            A2Student.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${A2Student.program}  •  ${A2Student.semester}',
            style: TextStyle(
              color: Colors.white.withAlpha(225),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return const A2Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: A2Colors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            A2Student.about,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: A2Colors.textSecondary,
            ),
          ),
          SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              A2Chip(label: 'SAP ${A2Student.sapId}', icon: Icons.badge_outlined),
              A2Chip(label: A2Student.section, icon: Icons.groups_outlined),
              A2Chip(label: 'Riphah, Islamabad', icon: Icons.school_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillTile extends StatelessWidget {
  const _SkillTile({required this.item, required this.index});

  final A2Item item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final heroTag = 'skill-${item.title}';

    return A2Card(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            a2FadeRoute(
              DetailScreen(
                item: item,
                heroTag: heroTag,
                badge: 'Skill #${index + 1}',
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: A2IconBadge(
                    icon: item.icon,
                    color: item.color,
                    size: 50,
                    iconSize: 27,
                  ),
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: A2Colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: A2Colors.textSecondary,
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
