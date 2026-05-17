import 'package:flutter/material.dart';
import 'dart:ui';

// ─── Warna utama ────────────────────────────────────────────
class AppColors {
  static const bg         = Color(0xFF020B18);
  static const bgCard     = Color(0xFF0A1929);
  static const blue       = Color(0xFF1E88E5);
  static const blueLight  = Color(0xFF42A5F5);
  static const blueCyan   = Color(0xFF00E5FF);
  static const border     = Color(0xFF1E88E5);
  static const textPri    = Color(0xFFE3F2FD);
  static const textSec    = Color(0xFF90CAF9);
  static const textMuted  = Color(0xFF546E7A);
}

// ─── Latar belakang + grid animasi ──────────────────────────
class FuturisticBackground extends StatefulWidget {
  final Widget child;
  const FuturisticBackground({super.key, required this.child});

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Stack(
        children: [
          CustomPaint(
            painter: _BgPainter(_anim.value),
            size: MediaQuery.of(context).size,
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF020B18), Color(0xFF041428), Color(0xFF061C38)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    // glow kiri atas
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.2),
      size.width * 0.6,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF1565C0).withOpacity(0.3 * t),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.15, size.height * 0.2),
          radius: size.width * 0.6,
        )),
    );
    // glow kanan bawah
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.78),
      size.width * 0.45,
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF00B8D9).withOpacity(0.2 * t),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.85, size.height * 0.78),
          radius: size.width * 0.45,
        )),
    );
    // grid
    final grid = Paint()
      ..color = const Color(0xFF1A4A7A).withOpacity(0.12)
      ..strokeWidth = 0.5;
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.t != t;
}

// ─── Glass Card ─────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 16,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.bgCard.withOpacity(0.65),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: (borderColor ?? AppColors.border).withOpacity(0.28),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── TextField futuristik ────────────────────────────────────
class FuturisticTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;

  const FuturisticTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.textPri, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSec, fontSize: 13),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.blueLight, size: 20)
            : null,
        filled: true,
        fillColor: AppColors.bgCard.withOpacity(0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.border.withOpacity(0.25),
            width: 0.8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.blueLight, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ─── Tombol utama ────────────────────────────────────────────
class FuturisticButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;

  const FuturisticButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: color != null
                ? [color!.withOpacity(0.8), color!]
                : [const Color(0xFF1565C0), const Color(0xFF1E88E5)],
          ),
          boxShadow: [
            BoxShadow(
              color: (color ?? AppColors.blue).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Tombol outline ──────────────────────────────────────────
class FuturisticOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const FuturisticOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blueLight,
          side: const BorderSide(color: AppColors.blueLight, width: 0.8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}