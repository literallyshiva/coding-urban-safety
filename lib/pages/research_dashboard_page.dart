import 'dart:html' as html;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/research_scaffold.dart';

/// Access is enforced by Firestore rules, NOT by hiding this route.
class ResearchDashboardPage extends StatefulWidget {
  const ResearchDashboardPage({super.key});
  @override
  State<ResearchDashboardPage> createState() => _ResearchDashboardPageState();
}

class _ResearchDashboardPageState extends State<ResearchDashboardPage> {
  bool _loading = false;
  String? _error;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _records = [];
  static const _limit = 500;

  Future<void> _signIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      await _load();
    } catch (e) {
      if (mounted) setState(() => _error = 'Sign-in failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await FirebaseFirestore.instance.collection('assessments')
          .orderBy('created_at', descending: true).limit(_limit).get();
      if (mounted) setState(() => _records = result.docs);
    } catch (_) {
      if (mounted) setState(() => _error =
          'Access denied or data unavailable. Only the configured researcher account can read assessments.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _csvCell(Object? value) {
    String text;
    if (value is List) {
      text = value.join(' | ');
    } else if (value is GeoPoint) {
      text = '${value.latitude},${value.longitude}';
    } else if (value is Timestamp) {
      text = value.toDate().toUtc().toIso8601String();
    } else {
      text = value?.toString() ?? '';
    }
    // Prevent spreadsheet formula injection in exported research data.
    if (text.isNotEmpty && '=+-@'.contains(text[0])) text = "'$text";
    return '"${text.replaceAll('"', '""')}"';
  }

  void _exportCsv() {
    if (_records.isEmpty) return;
    const fields = [
      'place_id', 'location_source', 'location', 'gender',
      'safety_rating', 'unsafe_conditions', 'place_experience',
      'spend_more_time', 'spatial_conditions', 'ludic_qualities',
      'ludic_rating', 'design_responses', 'other_suggestion', 'created_at',
    ];
    final lines = <String>[fields.join(',')];
    for (final record in _records) {
      final data = record.data();
      lines.add(fields.map((field) => _csvCell(data[field])).join(','));
    }
    final blob = html.Blob([utf8.encode('\uFEFF${lines.join('\r\n')}')],
        'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = 'urban-safety-research.csv';
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      appBarTitle: 'RESEARCH DASHBOARD',
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lock_outline, size: 44),
              const SizedBox(height: 18),
              Text('PRIVATE RESEARCH ACCESS',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              const Text('Only the authorized researcher can view assessment data. '
                  'Sign in with the configured Google account.'),
              const SizedBox(height: 20),
              FilledButton.icon(onPressed: _loading ? null : _signIn,
                  icon: const Icon(Icons.login), label: const Text('SIGN IN WITH GOOGLE')),
              if (_error != null) Text(_error!,
                  style: const TextStyle(color: Colors.red)),
            ]);
          }
          final scores = _records.map((r) => r.data()['safety_rating'])
              .whereType<int>().toList();
          final ludic = _records.map((r) => r.data()['ludic_rating'])
              .whereType<int>().toList();
          String average(List<int> values) => values.isEmpty ? '—'
              : (values.reduce((a, b) => a + b) / values.length).toStringAsFixed(2);
          final conditions = <String, int>{};
          for (final record in _records) {
            final list = record.data()['unsafe_conditions'];
            if (list is List) {
              for (final value in list.whereType<String>()) {
                conditions.update(value, (v) => v + 1, ifAbsent: () => 1);
              }
            }
          }
          final sorted = conditions.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Signed in as ${user.email ?? 'researcher'}'),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: [
              FilledButton.icon(onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh), label: const Text('LOAD / REFRESH')),
              OutlinedButton.icon(onPressed: _records.isEmpty ? null : _exportCsv,
                  icon: const Icon(Icons.download), label: const Text('EXPORT CSV')),
              TextButton(onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) setState(() { _records = []; _error = null; });
              }, child: const Text('SIGN OUT')),
            ]),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) Padding(padding: const EdgeInsets.all(10),
                child: Text(_error!, style: const TextStyle(color: Colors.red))),
            const SizedBox(height: 16),
            const Text('Results cover only the latest 500 assessments. '
                'CSV export has the same limit; this is not an all-time total.',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: [
              _metric('Loaded assessments', '${_records.length}'),
              _metric('Average safety', average(scores)),
              _metric('Average ludic rating', average(ludic)),
            ]),
            const SizedBox(height: 22),
            Text('MOST COMMON UNSAFE CONDITIONS',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            for (final entry in sorted.take(8))
              ListTile(title: Text(entry.key), trailing: Text('${entry.value}')),
          ]);
        },
      ),
    );
  }

  Widget _metric(String label, String value) => SizedBox(
    width: 190,
    child: Card(child: Padding(padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6), Text(label),
      ]))),
  );
}
