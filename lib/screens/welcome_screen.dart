import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FuturisticBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo / Icon
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF00B8D9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.5),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.directions_run_rounded,
                      color: Colors.white, size: 44),
                ),
                const SizedBox(height: 28),
                // Judul
                const Text(
                  'CATAT LARI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Track your journey. Own your pace.',
                  style: TextStyle(
                    color: AppColors.textSec,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(flex: 2),
                // Kartu tombol
                GlassCard(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      FuturisticButton(
                        label: 'Login',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                      ),
                      const SizedBox(height: 14),
                      FuturisticOutlineButton(
                        label: 'Daftar',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}