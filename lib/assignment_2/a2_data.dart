import 'package:flutter/material.dart';

/// Student shown on Home / Drawer / About
class A2Student {
  static const String name = 'Muhammad Zain Khan';
  static const String sapId = '66157';
  static const String email = '66157@students.riphah.edu.pk';
  static const String program = 'BS Software Engineering';
  static const String semester = '5th Semester';
  static const String section = 'BSSE5-2';
  static const String university = 'Riphah International University';
  static const String avatar = 'assets/profile.jpg';
  static const String about =
      'I am a Software Engineering student at Riphah International University '
      '(5th Semester). I build mobile apps with Flutter and Dart, and I also '
      'work with databases and web development. I enjoy making apps that are '
      'clean, fast and easy to use.';
}

/// One item for the ListView / GridView and the detail screen
class A2Item {
  const A2Item({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
}

/// List Screen -> ListView with 12 items
const List<A2Item> pakistanCities = [
  A2Item(
    title: 'Islamabad',
    subtitle: 'Capital Territory',
    description:
        'The capital of Pakistan, at the foot of the Margalla Hills. Home of Faisal Mosque and Riphah International University.',
    icon: Icons.account_balance,
    color: Color(0xFFD9733F),
  ),
  A2Item(
    title: 'Karachi',
    subtitle: 'Sindh',
    description:
        'The largest city of Pakistan and its main seaport on the Arabian Sea. Known as the City of Lights.',
    icon: Icons.sailing,
    color: Color(0xFF3D8BD9),
  ),
  A2Item(
    title: 'Lahore',
    subtitle: 'Punjab',
    description:
        'The cultural heart of Pakistan, famous for Badshahi Mosque, Lahore Fort and its food streets.',
    icon: Icons.mosque,
    color: Color(0xFF2E9E6A),
  ),
  A2Item(
    title: 'Rawalpindi',
    subtitle: 'Punjab',
    description:
        'Twin city of Islamabad with busy bazaars like Raja Bazaar and Saddar.',
    icon: Icons.train,
    color: Color(0xFF8E5BD6),
  ),
  A2Item(
    title: 'Peshawar',
    subtitle: 'Khyber Pakhtunkhwa',
    description:
        'One of the oldest cities in South Asia, known for Qissa Khwani Bazaar and the Khyber Pass.',
    icon: Icons.history_edu,
    color: Color(0xFFC0533A),
  ),
  A2Item(
    title: 'Quetta',
    subtitle: 'Balochistan',
    description:
        'Called the Fruit Garden of Pakistan, surrounded by mountains and orchards.',
    icon: Icons.eco,
    color: Color(0xFF4CA35A),
  ),
  A2Item(
    title: 'Multan',
    subtitle: 'Punjab',
    description:
        'The City of Saints, famous for its shrines, blue pottery and mangoes.',
    icon: Icons.auto_awesome,
    color: Color(0xFFE0A030),
  ),
  A2Item(
    title: 'Faisalabad',
    subtitle: 'Punjab',
    description:
        'A major industrial city and textile hub, often called the Manchester of Pakistan.',
    icon: Icons.factory,
    color: Color(0xFF5B6CD6),
  ),
  A2Item(
    title: 'Hyderabad',
    subtitle: 'Sindh',
    description:
        'An old city on the Indus River, well known for its colourful glass bangles.',
    icon: Icons.diamond,
    color: Color(0xFFD64F86),
  ),
  A2Item(
    title: 'Sialkot',
    subtitle: 'Punjab',
    description:
        'An export city famous worldwide for sports goods and surgical instruments.',
    icon: Icons.sports_cricket,
    color: Color(0xFF2B9AA8),
  ),
  A2Item(
    title: 'Gilgit',
    subtitle: 'Gilgit-Baltistan',
    description:
        'Gateway to the Karakoram mountains and the Karakoram Highway.',
    icon: Icons.terrain,
    color: Color(0xFF6B8E5A),
  ),
  A2Item(
    title: 'Murree',
    subtitle: 'Punjab',
    description:
        'A popular hill station near Islamabad, loved for its snowfall in winter.',
    icon: Icons.ac_unit,
    color: Color(0xFF4A90C2),
  ),
];

/// About Screen -> GridView with 6 items
const List<A2Item> techStack = [
  A2Item(
    title: 'Flutter',
    subtitle: 'Mobile apps',
    description:
        'Building cross-platform apps with widgets, layouts, navigation, animations and lists, like this one.',
    icon: Icons.flutter_dash,
    color: Color(0xFF3D8BD9),
  ),
  A2Item(
    title: 'Dart',
    subtitle: 'Language',
    description:
        'The language behind Flutter: classes, lists, async/await and null safety.',
    icon: Icons.code,
    color: Color(0xFF2B9AA8),
  ),
  A2Item(
    title: 'MySQL',
    subtitle: 'Databases',
    description:
        'Designing relational databases, ER diagrams, normalization and SQL queries.',
    icon: Icons.storage,
    color: Color(0xFFD9733F),
  ),
  A2Item(
    title: 'Web Dev',
    subtitle: 'HTML · CSS · JS',
    description:
        'Making responsive websites with HTML, CSS and JavaScript.',
    icon: Icons.language,
    color: Color(0xFF8E5BD6),
  ),
  A2Item(
    title: 'C++',
    subtitle: 'Programming',
    description:
        'Programming fundamentals, OOP and data structures in C++.',
    icon: Icons.terminal,
    color: Color(0xFF5B6CD6),
  ),
  A2Item(
    title: 'Git & GitHub',
    subtitle: 'Version control',
    description:
        'Pushing every weekly task to GitHub with clear commits.',
    icon: Icons.account_tree,
    color: Color(0xFF2E9E6A),
  ),
];
