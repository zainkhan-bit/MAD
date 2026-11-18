import 'package:flutter/material.dart';

import 'a2_data.dart';
import 'a2_theme.dart';

/// Detail page opened with Navigator.push from the ListView / GridView.
/// The icon flies in with a Hero animation; Back uses Navigator.pop.
class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.item,
    required this.heroTag,
    required this.badge,
  });

  final A2Item item;
  final String heroTag;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: a2AppBar(
        title: item.title,
        leading: const A2BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        children: [
          Center(
            child: Hero(
              tag: heroTag,
              child: A2IconBadge(
                icon: item.icon,
                color: item.color,
                size: 120,
                iconSize: 58,
                radius: 36,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: A2Colors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              A2Chip(label: item.subtitle, icon: Icons.place_outlined),
              A2Chip(label: badge, icon: Icons.tag),
            ],
          ),
          const SizedBox(height: 22),
          A2Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    A2IconBadge(
                      icon: Icons.info_outline_rounded,
                      color: A2Colors.primary,
                      size: 32,
                      iconSize: 18,
                      radius: 10,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: A2Colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: A2Colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: A2Colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text(
                'Go Back',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
