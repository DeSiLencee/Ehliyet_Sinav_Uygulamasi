import 'package:ehliyet_sinav_uyg/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _signInAnonymously(AuthService authService) async {
    setState(() {
      _isLoading = true;
    });
    dynamic result = await authService.signInAnonymously();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giriş yapılamadı. Lütfen tekrar deneyin.'),
        ),
      );
    }
  }

  void _signInWithGoogle(AuthService authService) async {
    setState(() {
      _isLoading = true;
    });
    dynamic result = await authService.signInWithGoogle();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giriş yapılamadı. Lütfen tekrar deneyin.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
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
                'Ehliyetim',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 64),

              // Google Login Button
              ElevatedButton.icon(
                onPressed: () => _signInWithGoogle(authService),
                icon: const Icon(Icons.email),
                label: const Text('Google ile Giriş Yap'),
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
                      onPressed: () => _signInAnonymously(authService),
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
