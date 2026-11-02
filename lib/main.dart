import 'package:flutter/material.dart';

import 'animated_container_widget.dart';
import 'animated_cross_fade_widget.dart';
import 'animated_opacity_widget.dart';
import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class Student {
  final String name;
  final String role;
  final String email;
  final String password;
  final String university;
  final String program;
  final String semester;
  final String aboutSummary;
  final String aboutFull;
  final String? avatarPath;

  const Student({
    required this.name,
    required this.role,
    required this.email,
    required this.password,
    required this.university,
    required this.program,
    required this.semester,
    required this.aboutSummary,
    required this.aboutFull,
    this.avatarPath,
  });

  /// SAP ID = email ka pehla hissa (66157@students... -> 66157)
  String get sapId => email.split('@').first;
}

// ===== HARD-CODED LOGIN ACCOUNTS =====
// Naya student add karna ho to neeche ek aur Student(...) copy-paste karo.
// Login par jo email + password match karega, usi ki details Profile par show hongi.
final List<Student> mockStudents = [
  const Student(
    name: 'Muhammad Zain Khan',
    role: 'Software Engineer',
    email: '66157@students.riphah.edu.pk',
    password: '123456',
    university: 'Riphah International University',
    program: 'BS Software Engineering',
    semester: '5th Semester',
    aboutSummary:
        'I am a passionate Software Engineering student at Riphah International University (5th Semester). Specializing in Mobile App Development using Flutter...',
    aboutFull:
        'I am a passionate Software Engineering student at Riphah International University (5th Semester). I specialize in Mobile App Development using Flutter, Database Management Systems, Programming Fundamentals (PF), and Website Development. I enjoy creating clean, efficient, and user-friendly applications that deliver great user experiences.',
    avatarPath: 'assets/profile.jpg',
  ),
  const Student(
    name: 'Student 64860',
    role: 'Software Engineer',
    email: '64860@students.riphah.edu.pk',
    password: '123456',
    university: 'Riphah International University',
    program: 'BS Software Engineering',
    semester: '5th Semester',
    aboutSummary:
        'I am a dedicated Software Engineering student at Riphah International University (5th Semester). Specializing in Mobile App Development...',
    aboutFull:
        'I am a dedicated Software Engineering student at Riphah International University (5th Semester). I specialize in Mobile App Development using Flutter, UI/UX Design, Cross-Platform Architecture, and Cloud Systems. I enjoy working on innovative software solutions.',
    avatarPath: 'assets/student2.jpg',
  ),
];

PageRouteBuilder<void> createFadePageRoute(Widget page) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riphah Student Portal',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class Login {
  String email = '';
  String password = '';
}

// =====================================================================
// LOGIN PAGE
// =====================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final Login _login = Login();
  final FocusNode _passwordFocus = FocusNode();

  bool _obscurePassword = true; // show / hide password
  bool _isLoading = false; // button spinner (system status)
  double _loginOpacity = 1.0;

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Please enter your university email';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) {
      return 'Enter a valid email, e.g. 12345@students.riphah.edu.pk';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) {
      return 'Please enter your password';
    }
    if (v.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final enteredEmail = _login.email.trim().toLowerCase();
    final enteredPass = _login.password.trim();

    Student? matchedStudent;
    for (final s in mockStudents) {
      if (s.email.toLowerCase() == enteredEmail && s.password == enteredPass) {
        matchedStudent = s;
        break;
      }
    }

    if (matchedStudent == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 3),
            content: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Incorrect email or password. Please try again.'),
                ),
              ],
            ),
          ),
        );
      return;
    }

    final Student student = matchedStudent;

    // Fade out login, then open that student's profile
    setState(() => _loginOpacity = 0.0);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      createFadePageRoute(ProfilePage(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _loginOpacity,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: Stack(
          children: [
            // Curved gradient header behind the card
            Container(
              height: 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        const _PortalBadge(),
                        const SizedBox(height: 16),
                        const Text(
                          'Riphah Student Portal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'UNIVERSITY PORTAL',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.5,
                            color: Colors.white.withAlpha(210),
                          ),
                        ),
                        const SizedBox(height: 28),
                        AppCard(
                          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: AutofillGroup(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Sign in with your university email to view your profile.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.4,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    enabled: !_isLoading,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: appInputDecoration(
                                      label: 'University Email',
                                      hint: '12345@students.riphah.edu.pk',
                                      icon: Icons.alternate_email_rounded,
                                    ),
                                    validator: _validateEmail,
                                    onSaved: (value) => _login.email = value ?? '',
                                    onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    enabled: !_isLoading,
                                    focusNode: _passwordFocus,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [AutofillHints.password],
                                    decoration: appInputDecoration(
                                      label: 'Password',
                                      icon: Icons.lock_outline_rounded,
                                      suffix: IconButton(
                                        tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: AppColors.textSecondary,
                                        ),
                                        onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword,
                                        ),
                                      ),
                                    ),
                                    validator: _validatePassword,
                                    onSaved: (value) => _login.password = value ?? '',
                                    onFieldSubmitted: (_) => _handleLogin(),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    height: 54,
                                    child: FilledButton(
                                      onPressed: _isLoading ? null : _handleLogin,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor: AppColors.primary.withAlpha(170),
                                        disabledForegroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 250),
                                        child: _isLoading
                                            ? const SizedBox(
                                                key: ValueKey('loading'),
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.6,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Row(
                                                key: ValueKey('label'),
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Login'),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.arrow_forward_rounded, size: 20),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_user_outlined, size: 16, color: AppColors.textSecondary),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Secure access for registered students only',
                                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple university portal logo
class _PortalBadge extends StatelessWidget {
  const _PortalBadge();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'University portal logo',
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.account_balance_rounded,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// =====================================================================
// PROFILE PAGE
// =====================================================================
class ProfilePage extends StatelessWidget {
  final Student student;

  const ProfilePage({
    super.key,
    required this.student,
  });

  // Confirm before logout (HCI: error prevention)
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to view your profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pushReplacement(
        context,
        createFadePageRoute(const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.peach,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout_rounded, color: AppColors.textPrimary),
            onPressed: () => _confirmLogout(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
            // 1. Header with AnimatedContainer (tap photo to enlarge)
            AnimatedContainerWidget(
              name: student.name,
              role: student.role,
              avatarPath: student.avatarPath,
              sapId: student.sapId,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  // 2. Personal info with AnimatedOpacity (hide / show)
                  AnimatedOpacityWidget(
                    sapId: student.sapId,
                    email: student.email,
                    university: student.university,
                    program: student.program,
                    semester: student.semester,
                  ),
                  const SizedBox(height: 16),

                  // 3. About Me with AnimatedCrossFade (read more / less)
                  AnimatedCrossFadeWidget(
                    summary: student.aboutSummary,
                    full: student.aboutFull,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
