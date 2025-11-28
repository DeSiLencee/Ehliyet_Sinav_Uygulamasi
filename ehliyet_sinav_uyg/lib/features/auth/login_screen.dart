import 'package:ehliyet_sinav_uyg/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ehliyet_sinav_uyg/features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  void _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    dynamic result = await _auth.signInAnonymously();
    setState(() {
      _isLoading = false;
    });
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giriş yapılamadı. Lütfen tekrar deneyin.'),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo or Title
              const Text(
                'Ehliyet Sınavı Hazırlık',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 64),

              // Email Login Button
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Email Login
                },
                icon: const Icon(Icons.email),
                label: const Text('E-posta ile Giriş Yap'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // Guest Login Button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _signInAnonymously,
                      icon: const Icon(Icons.person),
                      label: const Text('Misafir Olarak Devam Et'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: Colors.grey[700],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
