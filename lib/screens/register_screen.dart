import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ✅ Logika backend tidak berubah
  Future<void> _handleRegister() async {
    final name     = _nameController.text.trim();
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm  = _confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi semua field!')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak sama!')),
      );
      return;
    }

    final provider = context.read<UserProvider>();
    final success  = await provider.register(name, email, password);
    if (!mounted) return;
    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Registrasi gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FuturisticBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: GlassCard(
                        padding: const EdgeInsets.all(10),
                        radius: 12,
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.blueLight, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buat Akun',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Mulai perjalanan larimu hari ini',
                          style: TextStyle(
                              color: AppColors.textSec, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      FuturisticTextField(
                        controller: _nameController,
                        label: 'Nama',
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      FuturisticTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 14),
                      FuturisticTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      FuturisticTextField(
                        controller: _confirmController,
                        label: 'Konfirmasi Password',
                        obscureText: true,
                        prefixIcon: Icons.lock_reset_rounded,
                      ),
                      const SizedBox(height: 28),
                      FuturisticButton(
                        label: 'Daftar',
                        onPressed: isLoading ? null : _handleRegister,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}