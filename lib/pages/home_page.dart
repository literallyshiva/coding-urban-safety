import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../services/app_preferences.dart';
import '../widgets/research_scaffold.dart';
import '../widgets/animated_research_emoji.dart';
import '../widgets/editorial_city_artwork.dart';
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
    final colors = Theme.of(context).colorScheme;
    final textColor = colors.onSurface;
    final secondary = colors.onSurfaceVariant;
    return ResearchScaffold(
      illustration: 'assets/images/illustrated/01_welcome.png',
      sectionLabel: 'WELCOME',
      showFieldNote: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grid_on_rounded, size: 19, color: colors.primary),
                const SizedBox(width: 9),
                Expanded(
                  child: Text('FIELD NOTES  /  URBAN RESEARCH',
                    style: TextStyle(fontSize: 11, letterSpacing: 1.7,
                      fontWeight: FontWeight.w700, color: secondary)),
                ),
                IconButton(
                  tooltip: 'Researcher access',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ResearchDashboardPage())),
                  icon: Icon(Icons.lock_outline, size: 20, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text('PEOPLE  /  PLACES  /  SAFER CITIES',
              style: TextStyle(fontSize: 11, letterSpacing: 2,
                fontWeight: FontWeight.w700, color: colors.primary)),
            const SizedBox(height: 13),
            Text('CODING\nURBAN SAFETY',
              style: TextStyle(fontSize: 43, height: 1.04,
                fontWeight: FontWeight.w600, letterSpacing: -0.7, color: textColor)),
            const SizedBox(height: 20),
            Container(height: 2, width: 65, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 21),
            Text(AppPreferences.instance.tr('A study of safety, movement and playful exploration in public spaces.', 'പൊതു ഇടങ്ങളിലെ സുരക്ഷ, സഞ്ചാരം, വിനോദാനുഭവങ്ങൾ എന്നിവയെക്കുറിച്ചുള്ള പഠനം.'),
              style: TextStyle(fontSize: 17, height: 1.55, color: textColor)),
            const SizedBox(height: 27),
            // Illustrated scene is now the page hero, not an embedded picture.
            const SizedBox(height: 14),
            const _EditorialNote(),
            const SizedBox(height: 22),
            const _ExploreResearchCard(),
            const SizedBox(height: 22),
            const Wrap(spacing: 8, runSpacing: 8, children: [
              _Keyword('🛡️  SAFETY'),
              _Keyword('🏙️  PUBLIC SPACE'),
              _Keyword('🧭  EXPLORATION'),
            ]),
            const SizedBox(height: 23),
            Text(AppPreferences.instance.tr('Every place has a story. Your observations can help us understand how public spaces feel and function.', 'ഓരോ ഇടത്തിനും ഒരു കഥയുണ്ട്. നിങ്ങളുടെ നിരീക്ഷണങ്ങൾ പൊതു ഇടങ്ങളെ മനസ്സിലാക്കാൻ സഹായിക്കും.'),
              style: TextStyle(fontSize: 14, height: 1.65, color: secondary)),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                onPressed: () => _start(context),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(AppPreferences.instance.tr('BEGIN THE STUDY', 'പഠനം ആരംഭിക്കുക'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.6)),
                    const SizedBox(width: 13), const Icon(Icons.arrow_forward, size: 19)]),
              ),
            ),
            AnimatedBuilder(
              animation: assessmentState,
              builder: (context, _) => assessmentState.hasDraft
                ? Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: colors.surfaceContainerHigh,
                        border: Border.all(color: colors.outlineVariant), borderRadius: BorderRadius.circular(12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('UNFINISHED FIELD NOTE',
                            style: TextStyle(color: colors.primary, fontSize: 11,
                              fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          const SizedBox(height: 6),
                          Text('Your progress is saved on this device.',
                            style: TextStyle(color: textColor, fontSize: 13)),
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
              decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.outlineVariant))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, color: colors.primary, size: 18),
                  const SizedBox(width: 12),
                  Expanded(child: Text(
                    'RESEARCH PRIVACY  /  Information submitted is intended solely for research purposes. Please avoid names or other identifying details.',
                    style: TextStyle(fontSize: 12, height: 1.6, color: secondary))),
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
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
    child: Text(label, style: TextStyle(fontSize: 10,
      fontWeight: FontWeight.w700, letterSpacing: 0.7,
      color: Theme.of(context).colorScheme.onSurface)),
  );
}



/// A wholly rebuilt city scene using Flutter shapes, with continuous movement.
/// No network image dependency; all elements adapt to the selected colour theme.
class _AnimatedCityHero extends StatefulWidget {
  const _AnimatedCityHero();
  @override
  State<_AnimatedCityHero> createState() => _AnimatedCityHeroState();
}

class _AnimatedCityHeroState extends State<_AnimatedCityHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this, duration: const Duration(seconds: 12))..repeat();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final reduced = MediaQuery.of(context).disableAnimations;
    return Semantics(
      label: 'Animated city park with moving pedestrians, cycling, trees and sunlight',
      child: AspectRatio(
        aspectRatio: 1.65,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _CityScenePainter(
                scheme: c, progress: reduced ? .35 : _controller.value),
              child: Stack(children: [
                Positioned(top: 14, left: 15,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.surface.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Text('🌆', style: TextStyle(fontSize: 17)),
                        const SizedBox(width: 6),
                        Text('THE CITY IS YOUR STORY',
                          style: TextStyle(color: c.onSurface,
                            fontSize: 10, fontWeight: FontWeight.w800,
                            letterSpacing: .7)),
                      ]),
                    ),
                  ),
                ),
                Positioned(right: 12, bottom: 13,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.surface.withValues(alpha: .94),
                      borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                      child: Text('🚶  Explore  •  🛡️  Observe  •  ✨  Share',
                        style: TextStyle(color: c.onSurface,
                          fontWeight: FontWeight.w700, fontSize: 10)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _CityScenePainter extends CustomPainter {
  const _CityScenePainter({required this.scheme, required this.progress});
  final ColorScheme scheme;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final sky = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(sky, Paint()..shader = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [scheme.primaryContainer, scheme.tertiaryContainer,
        scheme.secondaryContainer],
    ).createShader(sky));

    void rect(double x, double y, double width, double height, Color color,
        {double radius = 0}) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x*w,y*h,width*w,height*h),
          Radius.circular(radius)),
        Paint()..color = color);
    }
    void circle(double x, double y, double r, Color color) {
      canvas.drawCircle(Offset(x*w,y*h), r*w, Paint()..color = color);
    }
    // Sunlight and two drifting clouds.
    circle(.79, .19, .092, const Color(0xFFFFC85A));
    circle(.79, .19, .12, const Color(0x55FFDF89));
    for (final shift in [0.0, .53]) {
      final x = ((.12 + shift + progress*.12) % 1.18) - .09;
      for (final dx in [0.0, .035, .075]) {
        circle(x+dx, .20 + dx*.18, .045, scheme.surface.withValues(alpha:.7));
      }
    }
    // Distinctive colourful urban skyline.
    final buildings = <(double,double,double,double,Color)>[
      (.02,.40,.14,.34,scheme.primary),
      (.15,.32,.16,.42,scheme.secondary),
      (.29,.44,.14,.30,scheme.tertiary),
      (.43,.25,.15,.49,scheme.primary),
      (.57,.39,.13,.35,scheme.secondary),
      (.69,.33,.16,.41,scheme.tertiary),
      (.84,.46,.14,.28,scheme.primary),
    ];
    for (final b in buildings) {
      rect(b.$1,b.$2,b.$3,b.$4,b.$5.withValues(alpha:.78),radius:7);
      for (var i=0; i<3; i++) {
        for (var j=0; j<2; j++) {
          rect(b.$1+.025+j*.053,b.$2+.045+i*.092,.026,.044,
            const Color(0xFFFFE8A6),radius:2);
        }
      }
    }
    // Planted park, street and a continuous walkway.
    rect(0,.72,1,.11,const Color(0xFF7EC4A1));
    rect(0,.83,1,.17,const Color(0xFF4E697B));
    rect(0,.84,1,.025,const Color(0xFFF5E9CF));
    for (final x in [.13,.38,.65,.89]) {
      rect(x,.89,.07,.009,const Color(0xFFF5E9CF),radius:4);
    }
    for (final x in [.10,.34,.62,.93]) {
      rect(x,.62,.013,.14,const Color(0xFF765D4B),radius:3);
      circle(x+.005,.60,.057,const Color(0xFF40A879));
      circle(x-.025,.62,.036,const Color(0xFF65C893));
    }
    // People and a cyclist travel continuously through the scene.
    final personX = (progress*1.35) - .15;
    final cyclistX = 1.15 - progress*1.35;
    _drawPerson(canvas,w,h,personX,.79,const Color(0xFFFF835C));
    _drawPerson(canvas,w,h,(personX+.43)%1.24,.77,
      const Color(0xFF7A65D8));
    _drawBike(canvas,w,h,cyclistX,.88);
  }

  void _drawPerson(Canvas canvas,double w,double h,double x,double y,Color shirt) {
    final p=Paint()..strokeWidth=w*.009..strokeCap=StrokeCap.round;
    void line(double x1,double y1,double x2,double y2,Color color) {
      canvas.drawLine(Offset(x1*w,y1*h),Offset(x2*w,y2*h),p..color=color);
    }
    canvas.drawCircle(Offset(x*w,(y-.11)*h),w*.018,
      Paint()..color=const Color(0xFFAE7150));
    line(x,y-.085,x,y-.025,shirt);
    line(x,y-.025,x-.019,y+.018,scheme.onSurface);
    line(x,y-.025,x+.02,y+.018,scheme.onSurface);
    line(x,y-.074,x-.027,y-.038,shirt);
    line(x,y-.074,x+.027,y-.044,shirt);
  }

  void _drawBike(Canvas canvas,double w,double h,double x,double y) {
    final paint=Paint()..color=scheme.onSurface..strokeWidth=w*.006
      ..style=PaintingStyle.stroke;
    final a=Offset((x-.035)*w,y*h), b=Offset((x+.045)*w,y*h);
    canvas.drawCircle(a,w*.025,paint);
    canvas.drawCircle(b,w*.025,paint);
    final center=Offset(x*w,(y-.035)*h);
    canvas.drawLine(a,center,paint);
    canvas.drawLine(center,b,paint);
    canvas.drawLine(a,b,paint);
    canvas.drawCircle(Offset(x*w,(y-.095)*h),w*.013,
      Paint()..color=const Color(0xFFAE7150));
    canvas.drawLine(Offset(x*w,(y-.078)*h),center,
      Paint()..color=scheme.primary..strokeWidth=w*.014);
  }

  @override
  bool shouldRepaint(covariant _CityScenePainter old) =>
      old.progress != progress || old.scheme != scheme;
}

/// Interactive infographic on the landing page. Purely local UI; no research data is changed.
class _ExploreResearchCard extends StatefulWidget {
  const _ExploreResearchCard();
  @override
  State<_ExploreResearchCard> createState() => _ExploreResearchCardState();
}

class _ExploreResearchCardState extends State<_ExploreResearchCard> {
  int selected = 0;
  static const emojis = ['🛡️', '🚶🏽', '✨'];
  static const headings = ['Safety', 'Movement', 'Your voice'];
  static const descriptions = [
    'Notice how comfortable, welcoming and safe each place feels.',
    'Explore accessibility, movement and the ways people use public space.',
    'Share your experience to help researchers understand better cities.',
  ];
  static const descriptionsMl = [
    'ഓരോ ഇടവും എത്രത്തോളം സുരക്ഷിതവും സൗകര്യപ്രദവുമാണെന്ന് വിലയിരുത്തൂ.',
    'പൊതു ഇടങ്ങളിലെ സഞ്ചാരവും ഉപയോഗവും ശ്രദ്ധിക്കൂ.',
    'നഗരങ്ങളെ മെച്ചമായി മനസ്സിലാക്കാൻ നിങ്ങളുടെ അനുഭവം പങ്കുവയ്ക്കൂ.',
  ];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surfaceContainerLow,
        border: Border.all(color: c.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.auto_graph_rounded, color: c.primary, size: 19),
          const SizedBox(width: 9),
          Expanded(child: Text('EXPLORE THE STUDY', style: TextStyle(
            fontSize: 12, letterSpacing: 1.1, fontWeight: FontWeight.w800,
            color: c.onSurface))),
          Text('${selected + 1} / 3', style: TextStyle(
            fontWeight: FontWeight.w700, color: c.onSurfaceVariant)),
        ]),
        const SizedBox(height: 14),
        Row(children: List.generate(3, (i) => Expanded(
          child: Padding(padding: EdgeInsets.only(right: i == 2 ? 0 : 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280), height: 5,
              decoration: BoxDecoration(
                color: i <= selected ? c.primary : c.outlineVariant,
                borderRadius: BorderRadius.circular(6))),
          ),
        ))),
        const SizedBox(height: 14),
        Row(children: List.generate(3, (i) => Expanded(
          child: Padding(padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
            child: Semantics(button: true, selected: selected == i,
              label: 'Explore ${headings[i]}',
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: selected == i
                        ? [c.primaryContainer, c.tertiaryContainer.withValues(alpha: 0.85)]
                        : [c.surfaceContainerHighest, c.secondaryContainer.withValues(alpha: 0.55)],
                    ),
                    border: Border.all(
                      color: selected == i ? c.primary : c.outlineVariant,
                      width: selected == i ? 1.6 : 0.8),
                    boxShadow: selected == i ? [
                      BoxShadow(color: c.primary.withValues(alpha: 0.14),
                        blurRadius: 13, offset: const Offset(0, 5))
                    ] : []),
                  child: Column(children: [
                    AnimatedResearchEmoji(
                      emoji: emojis[i], size: 35,
                      delay: i * 0.21,
                    ),
                    const SizedBox(height: 6),
                    Text(headings[i], textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: selected == i ? c.onPrimaryContainer : c.onSurface)),
                  ]),
                ),
              ),
            ),
          ),
        ))),
        const SizedBox(height: 14),
        AnimatedSwitcher(duration: const Duration(milliseconds: 240),
          child: Text(
            AppPreferences.instance.language == 'ml'
                ? descriptionsMl[selected] : descriptions[selected],
            key: ValueKey('${AppPreferences.instance.language}-$selected'),
            style: TextStyle(fontSize: 13, height: 1.5, color: c.onSurfaceVariant))),
      ]),
    );
  }
}

class _EditorialNote extends StatelessWidget {
  const _EditorialNote();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF26314B),
        borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFC84B), size: 28),
        const SizedBox(width: 13),
        Expanded(child: Text('A field guide to the spaces we share.',
          style: const TextStyle(color: Colors.white, fontSize: 16,
            height: 1.25, fontWeight: FontWeight.w800))),
        const Icon(Icons.north_east_rounded, color: Color(0xFFFFC84B)),
      ]),
    );
  }
}
