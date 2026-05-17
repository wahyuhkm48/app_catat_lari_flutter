import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Data tidak berubah
    final user = context.watch<UserProvider>().currentUser;

    final screens = [
      HomeScreen(user: user),
      ProfileScreen(user: user),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Stack(
          children: [
            CustomPaint(
              painter: _BgPainter(_anim.value),
              size: MediaQuery.of(context).size,
            ),
            screens[_currentIndex],
          ],
        ),
      ),
      bottomNavigationBar: _GlassNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020B18), Color(0xFF041428), Color(0xFF061C38)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.2),
        size.width * 0.6,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFF1565C0).withOpacity(0.3 * t),
            Colors.transparent
          ]).createShader(Rect.fromCircle(
              center: Offset(size.width * 0.15, size.height * 0.2),
              radius: size.width * 0.6)));
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.78),
        size.width * 0.45,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFF00B8D9).withOpacity(0.18 * t),
            Colors.transparent
          ]).createShader(Rect.fromCircle(
              center: Offset(size.width * 0.85, size.height * 0.78),
              radius: size.width * 0.45)));
    final g = Paint()
      ..color = const Color(0xFF1A4A7A).withOpacity(0.1)
      ..strokeWidth = 0.5;
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), g);
    }
    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), g);
    }
  }
  @override
  bool shouldRepaint(_BgPainter o) => o.t != t;
}

class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _GlassNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, pad + 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: AppColors.bgCard.withOpacity(0.72),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                  color: AppColors.border.withOpacity(0.28), width: 0.8),
              boxShadow: [
                BoxShadow(
                    color: AppColors.blue.withOpacity(0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  active: currentIndex == 0,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(0);
                  },
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  active: currentIndex == 1,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(1);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.blue.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: active
              ? Border.all(
                  color: AppColors.blueLight.withOpacity(0.35), width: 0.8)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            active
                ? ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.blueLight, AppColors.blueCyan],
                    ).createShader(b),
                    child: Icon(icon, size: 24, color: Colors.white),
                  )
                : Icon(icon, size: 24, color: AppColors.textMuted),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 260),
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.blueLight : AppColors.textMuted,
                letterSpacing: 0.3,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}