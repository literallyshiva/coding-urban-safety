import 'dart:html' as html;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/place_labels.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/research_scaffold.dart';
import '../services/app_preferences.dart';

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
  String _gender = 'All';
  int _daysBack = 0;
  final Set<String> _comparePlaces = {}; 
  String _condition = 'All';
  int _minimumSafety = 0;
  String? _selectedPlaceId;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> get _filtered => _records.where((r) {
    final d = r.data();
    if (_daysBack > 0) {
      final created = d['created_at'];
      if (created is! Timestamp || created.toDate().isBefore(DateTime.now().subtract(Duration(days: _daysBack)))) return false;
    }
    if (_gender != 'All' && d['gender'] != _gender) return false;
    if (_condition != 'All' && !(d['unsafe_conditions'] is List &&
        (d['unsafe_conditions'] as List).contains(_condition))) return false;
    final rating = d['safety_rating'];
    if (_minimumSafety > 0 && (rating is! num || rating.toInt() != _minimumSafety)) return false;
    return true;
  }).toList();

  Map<String, List<Map<String, dynamic>>> get _places {
    final result = <String, List<Map<String, dynamic>>>{};
    for (final record in _filtered) {
      final d = record.data();
      final id = d['place_id']?.toString() ?? '';
      if (id.isEmpty) continue;
      result.putIfAbsent(id, () => []).add(d);
    }
    return result;
  }

  double? _mean(Iterable<dynamic> values) {
    final nums = values.whereType<num>().toList();
    if (nums.isEmpty) return null;
    return nums.fold<double>(0, (sum, n) => sum + n.toDouble()) / nums.length;
  }

  Map<String, int> _frequency(Iterable<dynamic> values) {
    final result = <String, int>{};
    for (final value in values) {
      if (value is List) {
        for (final item in value.whereType<String>()) {
          result.update(item, (n) => n + 1, ifAbsent: () => 1);
        }
      }
    }
    return result;
  }

  String _top(Map<String, int> frequencies) {
    if (frequencies.isEmpty) return 'Not reported';
    final sorted = frequencies.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    return '${sorted.first.key} (${sorted.first.value})';
  }

  Color _safetyColor(double? score) {
    if (score == null) return Colors.grey;
    if (score < 2.5) return const Color(0xFFC46A60);
    if (score < 3.5) return const Color(0xFFC79A51);
    return const Color(0xFF638B78);
  }

  void _exportPlaceReport(String placeId, List<Map<String, dynamic>> records) {
    String escape(String value) => const HtmlEscape().convert(value);
    final score = _mean(records.map((r) => r['safety_rating']));
    final ludic = _mean(records.map((r) => r['ludic_rating']));
    final unsafe = _frequency(records.map((r) => r['unsafe_conditions']));
    final interventions = _frequency(records.map((r) => r['design_responses']));
    final location = records.first['location'];
    final coordinates = location is GeoPoint
        ? '${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}'
        : 'Unavailable';
    final report = '''<!doctype html><html lang="en"><head><meta charset="utf-8">
<title>Urban Safety Place Report</title><style>
body{font-family:Arial,sans-serif;max-width:760px;margin:45px auto;color:#202A30;line-height:1.6}
h1{border-bottom:2px solid #647C77;padding-bottom:14px}
.metric{display:inline-block;padding:16px;margin:8px;background:#F6F4EF}
small{color:#555} @media print{body{margin:20mm}}</style></head><body>
<h1>Coding Urban Safety — Place Report</h1>
<p><strong>Place ID:</strong> ${escape(placeId)}</p>
<p><strong>Coordinates:</strong> ${escape(coordinates)}</p>
<div class="metric"><strong>${records.length}</strong><br>Assessments</div>
<div class="metric"><strong>${score?.toStringAsFixed(2) ?? 'N/A'}/5</strong><br>Average safety</div>
<div class="metric"><strong>${ludic?.toStringAsFixed(2) ?? 'N/A'}/5</strong><br>Average ludic potential</div>
<h2>Top unsafe condition</h2><p>${escape(_top(unsafe))}</p>
<h2>Top requested design response</h2><p>${escape(_top(interventions))}</p>
<hr><small>Researcher-only report. Aggregated from the currently loaded, filtered dataset
(maximum $_limit latest assessments). Do not publish small-group results without privacy review.</small>
<p><button onclick="window.print()">Print / Save as PDF</button></p></body></html>''';
    final blob = html.Blob([utf8.encode(report)], 'text/html;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..download = 'urban-safety-place-${placeId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}.html'
      ..click();
    Future.delayed(const Duration(seconds: 10), () => html.Url.revokeObjectUrl(url));
  }

  Widget _analytics() {
    final places = _places;
    final availableConditions = _frequency(_records.map((r) => r.data()['unsafe_conditions'])).keys.toList()..sort();
    final rows = places.entries.toList()
      ..sort((a,b) => b.value.length.compareTo(a.value.length));
    final markers = <Marker>{};
    for (final entry in rows) {
      final geo = entry.value.first['location'];
      if (geo is! GeoPoint) continue;
      final score = _mean(entry.value.map((r) => r['safety_rating']));
      markers.add(Marker(
        markerId: MarkerId(entry.key),
        position: LatLng(geo.latitude, geo.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          score == null ? BitmapDescriptor.hueAzure :
          score < 2.5 ? BitmapDescriptor.hueRed :
          score < 3.5 ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Place ${entry.key.length > 8 ? entry.key.substring(0,8) : entry.key}',
          snippet: '${entry.value.length} assessments · safety ${score?.toStringAsFixed(2) ?? 'N/A'}/5',
          onTap: () => setState(() => _selectedPlaceId = entry.key)),
        onTap: () => setState(() => _selectedPlaceId = entry.key),
      ));
    }
    final firstPoint = rows.map((e) => e.value.first['location']).whereType<GeoPoint>().firstOrNull;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('EXPLORE ASSESSMENTS', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      Wrap(spacing: 12, runSpacing: 10, children: [
        DropdownButton<int>(value: _daysBack,
          items: const [DropdownMenuItem(value: 0, child: Text('All loaded dates')),
            DropdownMenuItem(value: 7, child: Text('Last 7 days')),
            DropdownMenuItem(value: 30, child: Text('Last 30 days')),
            DropdownMenuItem(value: 90, child: Text('Last 90 days'))],
          onChanged: (v) => setState(() => _daysBack = v ?? 0)),
        DropdownButton<String>(value: _gender, items: ['All','Male','Female','Other']
            .map((v) => DropdownMenuItem(value: v, child: Text(v == 'All' ? 'All genders' : v))).toList(),
            onChanged: (v) => setState(() { _gender = v ?? 'All'; _selectedPlaceId = null; })),
        DropdownButton<String>(value: _condition,
            items: ['All',...availableConditions].map((v) => DropdownMenuItem(
              value: v, child: Text(v == 'All' ? 'All unsafe conditions' : v,
                overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (v) => setState(() { _condition = v ?? 'All'; _selectedPlaceId = null; })),
        DropdownButton<int>(value: _minimumSafety,
            items: [0,1,2,3,4,5].map((v) => DropdownMenuItem(value:v,
              child: Text(v == 0 ? 'All safety ratings' : 'Safety rating: $v/5'))).toList(),
            onChanged: (v) => setState(() { _minimumSafety = v ?? 0; _selectedPlaceId = null; })),
      ]),
      const SizedBox(height: 12),
      Text('${_filtered.length} matching assessments across ${places.length} places',
          style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 14),
      if (firstPoint != null)
        SizedBox(height: 330, child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(firstPoint.latitude, firstPoint.longitude), zoom: 11),
            markers: markers, myLocationButtonEnabled: false,
            zoomControlsEnabled: true, mapToolbarEnabled: false),
        ))
      else const Padding(padding: EdgeInsets.all(20), child: Text('No mappable assessments for these filters.')),
      const SizedBox(height: 10),
      const Text('Map marker colors: red = below 2.5 · amber = 2.5–3.49 · green = 3.5 or higher. '
          'Markers show only places within the loaded assessment sample.',
          style: TextStyle(fontSize: 12)),
      const SizedBox(height: 24),
      _safetyOverview(),
      const SizedBox(height: 24),
      _ratingChart(),
      const SizedBox(height: 20),
      _comparison(places),
      const SizedBox(height: 20),
      Text('PLACE SUMMARIES', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      if (rows.isEmpty) const Text('No matching places. Adjust your filters.'),
      for (final entry in rows) _placeCard(entry.key, entry.value,
          selected: entry.key == _selectedPlaceId),
    ]);
  }

  Widget _placeCard(String id, List<Map<String, dynamic>> records, {bool selected = false}) {
    final score = _mean(records.map((r) => r['safety_rating']));
    final ludic = _mean(records.map((r) => r['ludic_rating']));
    final conditions = _frequency(records.map((r) => r['unsafe_conditions']));
    final responses = _frequency(records.map((r) => r['design_responses']));
    return Card(
      color: selected ? Theme.of(context).colorScheme.secondaryContainer : null,
      child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (records.first['location'] is GeoPoint)
            FutureBuilder<String>(
              future: PlaceLabels.forPoint(records.first['location'] as GeoPoint),
              builder: (context, name) => Text(
                name.data ?? 'Finding location…',
                style: const TextStyle(fontWeight: FontWeight.bold))),
          if (records.first['location'] is GeoPoint)
            Text(PlaceLabels.coordinates(records.first['location'] as GeoPoint)),
          Text('Research ID: $id', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 10, children: [
            _metric('Assessments', '${records.length}'),
            _metric('Mean safety / 5', score?.toStringAsFixed(2) ?? '—'),
            _metric('Mean ludic / 5', ludic?.toStringAsFixed(2) ?? '—'),
          ]),
          const SizedBox(height: 10),
          Text('Top unsafe condition: ${_top(conditions)}'),
          Text('Top requested intervention: ${_top(responses)}'),
          const SizedBox(height: 10),
          CheckboxListTile(
            dense: true, contentPadding: EdgeInsets.zero,
            title: const Text('Compare this place (select up to 3)'),
            value: _comparePlaces.contains(id),
            onChanged: (v) => setState(() {
              if (v == true && _comparePlaces.length < 3) _comparePlaces.add(id);
              if (v == false) _comparePlaces.remove(id);
            })),
          OutlinedButton.icon(
            onPressed: () => _exportPlaceReport(id, records),
            icon: const Icon(Icons.description_outlined),
            label: const Text('DOWNLOAD PRINTABLE REPORT')),
        ])),
    );
  }


  Widget _safetyOverview() {
    final ratings = _filtered.map((r) => r.data()['safety_rating']).whereType<num>().toList();
    final low = ratings.where((v) => v < 2.5).length;
    final moderate = ratings.where((v) => v >= 2.5 && v < 3.5).length;
    final high = ratings.where((v) => v >= 3.5).length;
    final total = ratings.length;
    final theme = Theme.of(context);
    Widget category(String label, int count, Color color) => Expanded(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$count', style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold, color: color)),
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: total == 0 ? 0 : count / total,
            color: color, minHeight: 10, borderRadius: BorderRadius.circular(6)),
        ],
      )),
    );
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('SAFETY SNAPSHOT', style: theme.textTheme.titleLarge),
        const SizedBox(height: 6),
        Text('Distribution of $total rated assessments in the current filters',
          style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        Row(children: [
          category('Needs attention', low, const Color(0xFFC46A60)),
          category('Mixed', moderate, const Color(0xFFC79A51)),
          category('Positive', high, const Color(0xFF638B78)),
        ]),
      ],
    )));
  }

  Widget _ratingChart() {
    final counts = List<int>.filled(5, 0);
    for (final record in _filtered) {
      final rating = record.data()['safety_rating'];
      if (rating is num && rating >= 1 && rating <= 5) counts[rating.toInt()-1]++;
    }
    final maximum = counts.fold<int>(1, (m, n) => n > m ? n : m);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('SAFETY RATING DISTRIBUTION', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      for (var i = 0; i < 5; i++) Padding(padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [SizedBox(width: 42, child: Text('${i+1}/5')),
          Expanded(child: LinearProgressIndicator(value: counts[i]/maximum, minHeight: 17,
            borderRadius: BorderRadius.circular(4))),
          SizedBox(width: 45, child: Text('  ${counts[i]}'))])),
      const Text('Counts are based on filtered, loaded assessments only.',
        style: TextStyle(fontSize: 12)),
    ]);
  }

  Widget _comparison(Map<String, List<Map<String, dynamic>>> places) {
    final selected = _comparePlaces.where(places.containsKey).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('COMPARE PLACES', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      const Text('Select up to three place cards below to compare their results.'),
      if (selected.isNotEmpty) SingleChildScrollView(scrollDirection: Axis.horizontal,
        child: DataTable(columns: const [DataColumn(label: Text('Place')),
          DataColumn(label: Text('Assessments')),
          DataColumn(label: Text('Mean safety')),
          DataColumn(label: Text('Mean ludic'))], rows: [
          for (final id in selected) DataRow(cells: [
            DataCell(Text(id.length > 12 ? id.substring(0,12) : id)),
            DataCell(Text('${places[id]!.length}')),
            DataCell(Text(_mean(places[id]!.map((r) => r['safety_rating']))?.toStringAsFixed(2) ?? '—')),
            DataCell(Text(_mean(places[id]!.map((r) => r['ludic_rating']))?.toStringAsFixed(2) ?? '—')),
          ])
        ])),
    ]);
  }

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
    for (final record in _filtered) {
      final data = record.data();
      lines.add(fields.map((field) => _csvCell(data[field])).join(','));
    }
    final blob = html.Blob([utf8.encode('\uFEFF${lines.join('\r\n')}')],
        'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = 'urban-safety-research-filtered.csv';
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
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Signed in as ${user.email ?? 'researcher'}'),
            const SizedBox(height: 12),
            Wrap(spacing: 10, runSpacing: 10, children: [
              FilledButton.icon(onPressed: _loading ? null : _load,
                  icon: const Icon(Icons.refresh), label: const Text('LOAD / REFRESH')),
              OutlinedButton.icon(onPressed: _filtered.isEmpty ? null : _exportCsv,
                  icon: const Icon(Icons.download), label: const Text('EXPORT FILTERED CSV')),
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
                'Charts, comparisons, and filtered CSV export use this loaded sample; these are not all-time totals.',
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Wrap(spacing: 12, runSpacing: 12, children: [
              _metric('Loaded assessments', '${_records.length}'),
              _metric('Filtered assessments', '${_filtered.length}'),
              _metric('Places in selection', '${_places.length}'),
            ]),
            const SizedBox(height: 22),
            _analytics(),
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
