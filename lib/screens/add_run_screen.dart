import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/run.dart';
import '../providers/run_provider.dart';
import '../theme/app_theme.dart';

class AddRunScreen extends StatefulWidget {
  final Run? existingRun;
  const AddRunScreen({super.key, this.existingRun});

  @override
  State<AddRunScreen> createState() => _AddRunScreenState();
}

class _AddRunScreenState extends State<AddRunScreen> {
  final _dateController     = TextEditingController();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();

  bool get _isEditMode => widget.existingRun != null;

  @override
  void initState() {
    super.initState();
    // ✅ Tidak berubah
    if (_isEditMode) {
      _dateController.text     = widget.existingRun!.runDate;
      _distanceController.text = widget.existingRun!.runDistance.toString();
      _durationController.text = widget.existingRun!.runDuration.toString();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // ✅ Tidak berubah
  Future<void> _handleSave() async {
    final date        = _dateController.text.trim();
    final distanceStr = _distanceController.text.trim();
    final durationStr = _durationController.text.trim();

    if (date.isEmpty || distanceStr.isEmpty || durationStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final distance = int.tryParse(distanceStr);
    final duration = int.tryParse(durationStr);

    if (distance == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jarak dan durasi harus berupa angka!')),
      );
      return;
    }

    final provider = context.read<RunProvider>();
    if (_isEditMode) {
      await provider.updateRun(
        widget.existingRun!.copyWith(
          runDate: date,
          runDistance: distance,
          runDuration: duration,
        ),
      );
    } else {
      await provider.addRun(
        Run(runDate: date, runDistance: distance, runDuration: duration),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background
          CustomPaint(
            painter: _SimpleBg(),
            size: MediaQuery.of(context).size,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Back + judul
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
                      const SizedBox(width: 16),
                      Text(
                        _isEditMode ? 'Edit Lari' : 'Tambah Lari',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // Ikon dekoratif
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF00B8D9)],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.blue.withOpacity(0.45),
                            blurRadius: 22,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Icon(
                      _isEditMode
                          ? Icons.edit_rounded
                          : Icons.add_circle_outline_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Form
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        FuturisticTextField(
                          controller: _dateController,
                          label: 'Tanggal (cth: 2024-01-15)',
                          prefixIcon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: 16),
                        FuturisticTextField(
                          controller: _distanceController,
                          label: 'Jarak (meter)',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.straighten_rounded,
                        ),
                        const SizedBox(height: 16),
                        FuturisticTextField(
                          controller: _durationController,
                          label: 'Durasi (menit)',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.timer_outlined,
                        ),
                        const SizedBox(height: 28),
                        FuturisticButton(
                          label: _isEditMode ? 'Update' : 'Simpan',
                          onPressed: _handleSave,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleBg extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF020B18), Color(0xFF041428), Color(0xFF061C38)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
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
  bool shouldRepaint(_SimpleBg o) => false;
}