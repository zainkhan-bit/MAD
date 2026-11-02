import 'package:flutter/material.dart';

import 'animated_container_widget.dart';
import 'animated_cross_fade_widget.dart';
import 'animated_opacity_widget.dart';
import 'app_theme.dart';
import 'contact_widget.dart';
import 'mobile_frame.dart';

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

  // Week 11: Contact tab details
  final String phone;
  final String linkedin;
  final String github;
  final String location;

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
    this.phone = '',
    this.linkedin = '',
    this.github = '',
    this.location = '',
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
    phone: '+92 300 0000000',
    linkedin: 'linkedin.com/in/muhammad-zain-khan-251b58337',
    github: 'github.com/your-username',
    location: 'Islamabad, Pakistan',
  ),
  const Student(
    name: 'Sameer Abdullah',
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
    phone: '+92 300 1111111',
    linkedin: 'linkedin.com/in/sameer-abdullah-0807bb37b',
    github: 'github.com/student-64860',
    location: 'Islamabad, Pakistan',
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
      // Chrome / desktop par phone frame mein preview
      builder: (context, child) => MobileFrame(child: child ?? const SizedBox()),
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
              height: 290,
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        const _PortalBadge(),
                        const SizedBox(height: 14),
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
                        const SizedBox(height: 22),
                        AppCard(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
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
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    enabled: !_isLoading,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(fontSize: 14.5),
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
                                    style: const TextStyle(fontSize: 14.5),
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
                                  const SizedBox(height: 22),
                                  SizedBox(
                                    height: 52,
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
        width: 84,
        height: 84,
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
          size: 42,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// =====================================================================
// PROFILE PAGE
// =====================================================================
class ProfilePage extends StatefulWidget {
  final Student student;

  const ProfilePage({
    super.key,
    required this.student,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Week 11: Bottom Navigation -> 0 = Personal, 1 = About, 2 = Contact
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Confirm before logout (HCI: error prevention)
  Future<void> _confirmLogout() async {
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

    if (confirmed == true && mounted) {
      Navigator.pushReplacement(
        context,
        createFadePageRoute(const LoginPage()),
      );
    }
  }

  // Selected tab ka content
  Widget _buildTab(Student s) {
    switch (_currentIndex) {
      case 0:
        // AnimatedOpacity (Hide / Show)
        return AnimatedOpacityWidget(
          email: s.email,
          university: s.university,
          program: s.program,
          semester: s.semester,
        );
      case 1:
        // AnimatedCrossFade (Read more / Show less)
        return AnimatedCrossFadeWidget(
          summary: s.aboutSummary,
          full: s.aboutFull,
        );
      default:
        return ContactWidget(
          email: s.email,
          phone: s.phone,
          linkedin: s.linkedin,
          github: s.github,
          location: s.location,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.peach,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 48,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout_rounded, color: AppColors.textPrimary),
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Header stays on every tab (AnimatedContainer: tap photo to enlarge)
          AnimatedContainerWidget(
            name: student.name,
            role: student.role,
            avatarPath: student.avatarPath,
            sapId: student.sapId,
          ),
          // Tab content with a smooth fade + slide when switching
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                key: ValueKey<int>(_currentIndex),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                child: _buildTab(student),
              ),
            ),
          ),
        ],
      ),
      // ===== WEEK 11: BOTTOM NAVIGATION BAR =====
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              color: Color(0x12B4582A),
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 11.5,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Personal',
              tooltip: 'Personal Information',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined),
              activeIcon: Icon(Icons.auto_stories_rounded),
              label: 'About',
              tooltip: 'About Me',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone_outlined),
              activeIcon: Icon(Icons.contact_phone_rounded),
              label: 'Contact',
              tooltip: 'Contact Details',
            ),
          ],
        ),
      ),
    );
  }
}
