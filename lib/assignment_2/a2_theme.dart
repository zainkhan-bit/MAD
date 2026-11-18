import 'package:flutter/material.dart';

/// Colours used across Assignment 2 (same warm peach / orange look as the
/// Student Portal app).
class A2Colors {
  static const Color primary = Color(0xFFD9733F);
  static const Color primaryDark = Color(0xFFB4582A);
  static const Color primaryLight = Color(0xFFF0A27A);
  static const Color peach = Color(0xFFF8E4D9);
  static const Color background = Color(0xFFFDF7F3);
  static const Color textPrimary = Color(0xFF2E2420);
  static const Color textSecondary = Color(0xFF7D6B62);
  static const Color border = Color(0xFFF1DFD4);
  static const Color success = Color(0xFF2E9E6A);
}

const LinearGradient a2Gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [A2Colors.primaryDark, A2Colors.primary, A2Colors.primaryLight],
);

ThemeData buildA2Theme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: A2Colors.primary,
      primary: A2Colors.primary,
    ),
    scaffoldBackgroundColor: A2Colors.background,
  );
}

/// Same AppBar style on every screen. [leading] is used for the back button
/// (Navigator.pop) and [actions] for the drawer menu button.
PreferredSizeWidget a2AppBar({
  required String title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: A2Colors.peach,
    foregroundColor: A2Colors.textPrimary,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    leading: leading,
    actions: actions,
    title: Text(
      title,
      style: const TextStyle(
        color: A2Colors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

/// Back arrow that calls Navigator.pop
class A2BackButton extends StatelessWidget {
  const A2BackButton({super.key, this.color = A2Colors.textPrimary});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back_rounded, color: color),
      onPressed: () => Navigator.pop(context),
    );
  }
}

/// Opens the Drawer of the nearest Scaffold
class A2MenuButton extends StatelessWidget {
  const A2MenuButton({super.key, this.color = A2Colors.textPrimary});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Open menu',
      icon: Icon(Icons.menu_rounded, color: color),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}

/// White rounded card with a soft shadow
class A2Card extends StatelessWidget {
  const A2Card({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: A2Colors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14B4582A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Small rounded icon tile with a gradient (used in cards, list and grid)
class A2IconBadge extends StatelessWidget {
  const A2IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 46,
    this.iconSize = 24,
    this.radius = 14,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.white, 0.38)!],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(60),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

/// Small pill label
class A2Chip extends StatelessWidget {
  const A2Chip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: A2Colors.peach,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: A2Colors.primaryLight.withAlpha(120)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: A2Colors.primaryDark),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: A2Colors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fade + slight slide page transition (used with Navigator.push)
Route<T> a2FadeRoute<T>(Widget page, {String? name}) {
  return PageRouteBuilder<T>(
    settings: RouteSettings(name: name),
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Items slide up + fade in one after another (staggered list animation)
class A2StaggeredIn extends StatelessWidget {
  const A2StaggeredIn({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
