import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/run.dart';
import '../providers/run_provider.dart';
import '../theme/app_theme.dart';
import 'add_run_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Tidak berubah
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<RunProvider>().loadRuns();
    });
  }

  // ✅ Tidak berubah
  void _confirmDelete(BuildContext context, Run run) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFEF5350), size: 40),
              const SizedBox(height: 12),
              const Text(
                'Hapus Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Yakin ingin menghapus data lari ini?',
                style: TextStyle(color: AppColors.textSec, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FuturisticOutlineButton(
                      label: 'Batal',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FuturisticButton(
                      label: 'Hapus',
                      color: const Color(0xFFEF5350),
                      onPressed: () {
                        // ✅ Tidak berubah
                        context.read<RunProvider>().deleteRun(run);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Tidak berubah
  Future<void> _goToAddRun({Run? existing}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddRunScreen(existingRun: existing),
      ),
    );
    if (mounted) context.read<RunProvider>().loadRuns();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Tidak berubah
    final runList  = context.watch<RunProvider>().runHistory;
    final userName = widget.user?.name ?? 'User';

    // Hitung tinggi navbar glass secara dinamis agar pas di semua HP
    final bottomPad    = MediaQuery.of(context).padding.bottom;
    final navBarHeight = bottomPad + 66 + 16 + 16;

    return Scaffold(
      backgroundColor: Colors.transparent,

      // ── FAB mengambang di atas navbar ──────────────────────
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: navBarHeight - 84),
        child: _FuturisticFAB(onTap: _goToAddRun),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $userName 👟',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Riwayat larimu ada di sini',
                        style: TextStyle(
                            color: AppColors.textSec, fontSize: 12),
                      ),
                    ],
                  ),
                  // Badge total lari
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    radius: 14,
                    child: Column(
                      children: [
                        Text(
                          '${runList.length}',
                          style: const TextStyle(
                            color: AppColors.blueLight,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Total',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── List riwayat lari ─────────────────────────────
            Expanded(
              child: runList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_run_rounded,
                            size: 64,
                            color: AppColors.blue.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada data lari',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ketuk + untuk menambah',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      // Padding bawah agar item terakhir tidak tertutup navbar + FAB
                      padding: EdgeInsets.fromLTRB(20, 0, 20, navBarHeight + 70),
                      itemCount: runList.length,
                      itemBuilder: (context, index) {
                        final run = runList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                // Ikon lari
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1565C0),
                                        Color(0xFF00B8D9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.blue.withOpacity(0.4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.directions_run_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Info tanggal & statistik
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        run.runDate,
                                        style: const TextStyle(
                                          color: AppColors.textPri,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          _StatChip(
                                            icon: Icons.straighten_rounded,
                                            label: '${run.runDistance} M',
                                          ),
                                          const SizedBox(width: 8),
                                          _StatChip(
                                            icon: Icons.timer_outlined,
                                            label:
                                                '${run.runDuration} menit',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol edit & hapus
                                Column(
                                  children: [
                                    _ActionBtn(
                                      icon: Icons.edit_rounded,
                                      color: AppColors.blueLight,
                                      onTap: () =>
                                          _goToAddRun(existing: run),
                                    ),
                                    const SizedBox(height: 6),
                                    _ActionBtn(
                                      icon: Icons.delete_outline_rounded,
                                      color: const Color(0xFFEF5350),
                                      onTap: () =>
                                          _confirmDelete(context, run),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── FAB futuristik ────────────────────────────────────────────
class _FuturisticFAB extends StatelessWidget {
  final Future<void> Function({Run? existing}) onTap;
  const _FuturisticFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: AppColors.blue.withOpacity(0.55),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => onTap(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}

// ── Chip statistik kecil ──────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.blueLight),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSec, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Tombol aksi (edit / hapus) ────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25), width: 0.6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}