import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;
  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            // Avatar card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF00B8D9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.blue.withOpacity(0.4),
                            blurRadius: 14),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        (user?.name ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '-',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '-',
                          style: const TextStyle(
                              color: AppColors.textSec, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Info rows
            GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Column(
                children: [
                  _InfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Nama',
                      value: user?.name ?? '-'),
                  const Divider(
                      color: Color(0xFF1A3A5C), height: 1, thickness: 0.5),
                  _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '-'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Logout
            FuturisticButton(
              label: 'Logout',
              color: const Color(0xFFB71C1C),
              onPressed: () {
                // ✅ Tidak berubah
                context.read<UserProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.blueLight),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSec, fontSize: 13)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPri,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}