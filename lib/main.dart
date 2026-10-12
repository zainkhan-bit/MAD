import 'package:flutter/material.dart';

import 'animated_container_widget.dart';
import 'animated_cross_fade_widget.dart';
import 'animated_opacity_widget.dart';

void main() {
  runApp(const MyApp());
}

PageRouteBuilder<void> createFadePageRoute(Widget page) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
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
      title: 'My Profile App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDF8F5),
      ),
      home: const LoginPage(),
    );
  }
}

class Login {
  String email = '';
  String password = '';
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final Login _login = Login();
  double _loginOpacity = 1.0;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Required';
    }
    if (!value.contains('@')) {
      return 'Enter a valid Email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password Required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Fade out login page content
      setState(() {
        _loginOpacity = 0.0;
      });

      // Shift to ProfilePage with smooth fade route transition
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          createFadePageRoute(const ProfilePage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFD97746);
    const headerBgColor = Color(0xFFF3D9CB);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      appBar: AppBar(
        backgroundColor: headerBgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedOpacity(
          opacity: _loginOpacity,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/profile.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const CircleAvatar(
                              radius: 50,
                              backgroundColor: headerBgColor,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.black87,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please sign in to continue to your profile',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: '66157@students.riphah.edu.pk',
                        prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: _validateEmail,
                      onSaved: (value) => _login.email = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined, color: primaryColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: _validatePassword,
                      onSaved: (value) => _login.password = value!,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const headerBgColor = Color(0xFFF3D9CB);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      appBar: AppBar(
        backgroundColor: headerBgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              createFadePageRoute(const LoginPage()),
            );
          },
        ),
        title: const Text(
          'MUHAMMAD ZAIN KHAN',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            fontSize: 18,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Profile Header with integrated AnimatedContainer
              AnimatedContainerWidget(),
              Divider(height: 1, thickness: 1, color: Color(0xFFE5D0C5)),

              // 2. Personal Information with integrated AnimatedOpacity
              AnimatedOpacityWidget(),
              Divider(height: 1, thickness: 1, color: Color(0xFFE5D0C5)),

              // 3. About Me Section with integrated AnimatedCrossFade
              AnimatedCrossFadeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
