import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/run.dart';
import '../providers/run_provider.dart';

class AddRunScreen extends StatefulWidget {
  final Run? existingRun;
  const AddRunScreen({super.key, this.existingRun});

  @override
  State<AddRunScreen> createState() => _AddRunScreenState();
}

class _AddRunScreenState extends State<AddRunScreen> {
  final _dateController = TextEditingController();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();

  bool get _isEditMode => widget.existingRun != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _dateController.text = widget.existingRun!.runDate;
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

  Future<void> _handleSave() async {
    final date = _dateController.text.trim();
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
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Lari' : 'Tambah Lari')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Tanggal (cth: 2024-01-15)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Jarak (meter)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Durasi (menit)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                child: Text(_isEditMode ? 'Update' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}