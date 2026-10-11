import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'study_area_page.dart';
import 'safety_assessment_page.dart';
import 'research_dashboard_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  static const ivory = Color(0xFFF6F4EF);
  static const ink = Color(0xFF202A30);
  static const sage = Color(0xFF647C77);
  static const clay = Color(0xFFD2A27B);
  static const line = Color(0xFFDCDDD6);

  void _start(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => StudyAreaPage(assessmentState: assessmentState),
    ));
  }

  void _resume(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => assessmentState.location == null
          ? StudyAreaPage(assessmentState: assessmentState)
          : SafetyAssessmentPage(assessmentState: assessmentState),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.grid_on_rounded, size: 19, color: sage),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text('FIELD NOTES  /  URBAN RESEARCH',
                    style: TextStyle(fontSize: 11, letterSpacing: 1.7,
                      fontWeight: FontWeight.w700, color: sage)),
                ),
                IconButton(
                  tooltip: 'Researcher access',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ResearchDashboardPage())),
                  icon: const Icon(Icons.lock_outline, size: 20, color: ink),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text('01  /  INTRODUCTION',
              style: TextStyle(fontSize: 11, letterSpacing: 2,
                fontWeight: FontWeight.w700, color: sage)),
            const SizedBox(height: 13),
            const Text('How do we\nexperience\nour cities?',
              style: TextStyle(fontSize: 47, height: 1.06,
                fontWeight: FontWeight.w500, letterSpacing: -2.0, color: ink)),
            const SizedBox(height: 20),
            Container(height: 2, width: 65, color: clay),
            const SizedBox(height: 21),
            const Text('A study of safety, movement and playful exploration in public spaces.',
              style: TextStyle(fontSize: 17, height: 1.55, color: ink)),
            const SizedBox(height: 27),
            const _ArchitecturalIllustration(),
            const SizedBox(height: 24),
            const Wrap(spacing: 8, runSpacing: 8, children: [
              _Keyword('01  SAFETY'),
              _Keyword('02  PUBLIC SPACE'),
              _Keyword('03  EXPLORATION'),
            ]),
            const SizedBox(height: 23),
            const Text('Every place has a story. Your observations can help us understand how public spaces feel and function.',
              style: TextStyle(fontSize: 14, height: 1.65, color: ink)),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: ink, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                onPressed: () => _start(context),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('BEGIN THE STUDY',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.6)),
                    SizedBox(width: 13), Icon(Icons.arrow_forward, size: 19)]),
              ),
            ),
            AnimatedBuilder(
              animation: assessmentState,
              builder: (context, _) => assessmentState.hasDraft
                ? Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: ivory,
                        border: Border.all(color: line)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('UNFINISHED FIELD NOTE',
                            style: TextStyle(color: sage, fontSize: 11,
                              fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          const SizedBox(height: 6),
                          const Text('Your progress is saved on this device.',
                            style: TextStyle(color: ink, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextButton.icon(onPressed: () => _resume(context),
                            icon: const Icon(Icons.arrow_forward, size: 18),
                            label: const Text('RESUME ASSESSMENT')),
                          TextButton(onPressed: assessmentState.reset,
                            child: const Text('DISCARD SAVED ANSWERS')),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: line))),
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, color: sage, size: 18),
                  SizedBox(width: 12),
                  Expanded(child: Text(
                    'RESEARCH PRIVACY  /  Information submitted is intended solely for research purposes. Please avoid names or other identifying details.',
                    style: TextStyle(fontSize: 12, height: 1.6, color: sage))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Keyword extends StatelessWidget {
  const _Keyword(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(border: Border.all(color: HomePage.line)),
    child: Text(label, style: const TextStyle(fontSize: 10,
      fontWeight: FontWeight.w700, letterSpacing: 1, color: HomePage.sage)),
  );
}

class _ArchitecturalIllustration extends StatelessWidget {
  const _ArchitecturalIllustration();
  @override
  Widget build(BuildContext context) => Container(
    height: 250,
    width: double.infinity,
    decoration: BoxDecoration(color: HomePage.ivory,
      border: Border.all(color: HomePage.line)),
    child: const CustomPaint(painter: _CityLineDrawing()),
  );
}

class _CityLineDrawing extends CustomPainter {
  const _CityLineDrawing();
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 360;
    final sy = size.height / 250;
    canvas.save();
    canvas.scale(sx, sy);
    final pen = Paint()..color = HomePage.ink..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final faint = Paint()..color = HomePage.sage.withValues(alpha: .45)..style = PaintingStyle.stroke..strokeWidth = 1;
    final accent = Paint()..color = HomePage.clay..style = PaintingStyle.stroke..strokeWidth = 2;
    void segment(double x1, double y1, double x2, double y2, Paint p) =>
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), p);
    void rect(double x, double y, double w, double h, Paint p) =>
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), p);
    // Architectural elevations: towers, windows, street level.
    rect(23, 85, 85, 130, pen);
    rect(119, 40, 105, 175, pen);
    rect(235, 101, 99, 114, pen);
    for (var x = 35.0; x < 100; x += 20) {
      for (var y = 101.0; y < 195; y += 24) rect(x, y, 10, 14, faint);
    }
    for (var x = 134.0; x < 215; x += 25) {
      for (var y = 57.0; y < 186; y += 28) rect(x, y, 13, 17, faint);
    }
    for (var x = 248.0; x < 325; x += 23) {
      for (var y = 117.0; y < 194; y += 25) rect(x, y, 12, 15, faint);
    }
    segment(0, 215, 360, 215, pen);
    segment(0, 231, 360, 231, faint);
    segment(165, 16, 165, 39, accent);
    segment(155, 27, 175, 27, accent);
    // A tree and human-scale markers in the foreground.
    segment(282, 187, 282, 215, pen);
    canvas.drawCircle(const Offset(282, 174), 15, pen);
    canvas.drawCircle(const Offset(272, 180), 12, faint);
    canvas.drawCircle(const Offset(292, 182), 12, faint);
    canvas.drawCircle(const Offset(83, 198), 5, accent);
    segment(83, 203, 83, 218, accent);
    segment(83, 209, 76, 214, accent);
    segment(83, 209, 90, 214, accent);
    segment(83, 218, 78, 227, accent);
    segment(83, 218, 89, 227, accent);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
