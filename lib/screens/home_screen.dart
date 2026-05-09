import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/run.dart';
import '../providers/run_provider.dart';
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
    // Load data saat pertama kali ditampilkan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RunProvider>().loadRuns();
      }
    });
  }

  void _confirmDelete(BuildContext context, Run run) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Yakin ingin menghapus data lari ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<RunProvider>().deleteRun(run);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final runList = context.watch<RunProvider>().runHistory;
    final userName = widget.user?.name ?? 'User';

    return Scaffold(
      appBar: AppBar(title: Text('Halo, $userName')),
      body: runList.isEmpty
          ? const Center(child: Text('Belum ada data lari'))
          : ListView.builder(
              itemCount: runList.length,
              itemBuilder: (context, index) {
                final run = runList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(run.runDate),
                    subtitle: Text('${run.runDistance} M  •  ${run.runDuration} menit'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddRunScreen(existingRun: run),
                              ),
                            );
                            if (context.mounted) {
                              context.read<RunProvider>().loadRuns();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, run),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRunScreen()),
          );
          if (context.mounted) {
            context.read<RunProvider>().loadRuns();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}