import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../state/assessment_state.dart';

/// Stores drafts on this browser/device only. Never uploads unfinished answers.
class DraftStorage {
  DraftStorage(this.state);
  final AssessmentState state;
  static const _key = 'urban_safety_draft_v1';
  Timer? _timer;
  bool _restoring = false;

  Future<void> initialize() async {
    _restoring = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        try { state.restoreDraft(raw); } catch (_) {
          await prefs.remove(_key);
        }
      }
    } finally {
      _restoring = false;
      state.addListener(_schedule);
    }
  }

  void _schedule() {
    if (_restoring) return;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 350), () async {
      final prefs = await SharedPreferences.getInstance();
      if (state.hasDraft) {
        await prefs.setString(_key, state.toDraftJson());
      } else {
        await prefs.remove(_key);
      }
    });
  }

  Future<void> clear() async {
    _timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
