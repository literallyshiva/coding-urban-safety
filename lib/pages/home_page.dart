import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../services/app_preferences.dart';
import '../widgets/research_scaffold.dart';
import '../widgets/animated_research_emoji.dart';
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
            Text('01  /  INTRODUCTION',
              style: TextStyle(fontSize: 11, letterSpacing: 2,
                fontWeight: FontWeight.w700, color: colors.primary)),
            const SizedBox(height: 13),
            Text(AppPreferences.instance.tr('How do we\nexperience\nour cities?', 'നമ്മുടെ നഗരങ്ങളെ\nനാം എങ്ങനെ\nഅനുഭവിക്കുന്നു?'),
              style: TextStyle(fontSize: 42, height: 1.23,
                fontWeight: FontWeight.w600, letterSpacing: -0.7, color: textColor)),
            const SizedBox(height: 20),
            Container(height: 2, width: 65, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 21),
            Text(AppPreferences.instance.tr('A study of safety, movement and playful exploration in public spaces.', 'പൊതു ഇടങ്ങളിലെ സുരക്ഷ, സഞ്ചാരം, വിനോദാനുഭവങ്ങൾ എന്നിവയെക്കുറിച്ചുള്ള പഠനം.'),
              style: TextStyle(fontSize: 17, height: 1.55, color: textColor)),
            const SizedBox(height: 27),
            const _AnimatedCityHero(),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
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


/// Retains the original research artwork; adds moving, accessible city details.
class _AnimatedCityHero extends StatefulWidget {
  const _AnimatedCityHero();
  @override
  State<_AnimatedCityHero> createState() => _AnimatedCityHeroState();
}

class _AnimatedCityHeroState extends State<_AnimatedCityHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this, duration: const Duration(seconds: 9))..repeat();

  @override
  void dispose() { _motion.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final reduced = MediaQuery.of(context).disableAnimations;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(children: [
        const _ArchitecturalIllustration(),
        Positioned(top: 10, right: 12,
          child: DecoratedBox(decoration: BoxDecoration(
            color: c.surface.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(20)),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text('🏙️  Explore your city',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: c.onSurface))))),
        if (!reduced)
          Positioned.fill(child: IgnorePointer(child: AnimatedBuilder(
            animation: _motion,
            builder: (context, _) => Align(
              alignment: Alignment(-1.15 + 2.3 * _motion.value, .68),
              child: const Text('🚶', style: TextStyle(fontSize: 30)),
            ),
          ))),
        if (reduced)
          const Positioned(bottom: 10, left: 16,
            child: Text('🚶', style: TextStyle(fontSize: 26))),
      ]),
    );
  }
}

class _ArchitecturalIllustration extends StatelessWidget {
  const _ArchitecturalIllustration();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: ClipRect(
      child: Image.asset(
        'assets/images/urban_waterfront_sketch.png',
        width: double.infinity,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        semanticLabel: 'Hand-drawn architectural sketch of a lively waterfront promenade with pedestrians, cyclists, trees, and buildings.',
      ),
    ),
  );
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
