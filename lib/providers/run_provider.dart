import 'package:flutter/material.dart';
import '../data/run_dao.dart';
import '../models/run.dart';

class RunProvider extends ChangeNotifier {
  final RunDao _runDao = RunDao();

  List<Run> _runHistory = [];
  List<Run> get runHistory => _runHistory;

  Future<void> loadRuns() async {
    _runHistory = await _runDao.getAllRuns();
    notifyListeners();
  }

  Future<void> addRun(Run run) async {
    await _runDao.insertRun(run);
    await loadRuns();
  }

  Future<void> updateRun(Run run) async {
    await _runDao.updateRun(run);
    await loadRuns();
  }

  Future<void> deleteRun(Run run) async {
    await _runDao.deleteRun(run);
    await loadRuns();
  }
}