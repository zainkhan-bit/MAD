import 'package:flutter/material.dart';

import 'a2_data.dart';
import 'a2_theme.dart';
import 'app_drawer.dart';
import 'detail_screen.dart';

/// 3a. LIST SCREEN -> ListView with 12 items.
/// Tap an item -> Navigator.push to the detail screen (Hero animation).
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: a2AppBar(
        title: 'Cities of Pakistan',
        leading: const A2BackButton(), // Navigator.pop
        actions: const [A2MenuButton()],
      ),
      drawer: const A2Drawer(current: A2Page.list),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 16, color: A2Colors.primary),
                const SizedBox(width: 6),
                Text(
                  '${pakistanCities.length} cities',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: A2Colors.textPrimary,
                  ),
                ),
                const Text(
                  '  •  tap a city for details',
                  style: TextStyle(fontSize: 13, color: A2Colors.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: pakistanCities.length,
              itemBuilder: (context, index) {
                return A2StaggeredIn(
                  index: index,
                  child: _CityTile(item: pakistanCities[index], index: index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({required this.item, required this.index});

  final A2Item item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final heroTag = 'city-${item.title}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: A2Card(
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
                  badge: 'City #${index + 1}',
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Hero(
                    tag: heroTag,
                    child: A2IconBadge(icon: item.icon, color: item.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: A2Colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: A2Colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: A2Colors.primaryLight.withAlpha(200),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: A2Colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
