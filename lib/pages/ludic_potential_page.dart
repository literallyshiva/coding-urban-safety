import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'design_response_page.dart';

class LudicPotentialPage extends StatelessWidget {
  const LudicPotentialPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;
  static const _navy = Color(0xFF202A30);
  static const _teal = Color(0xFF647C77);

  static const qualities = [
    'Curiosity',
    'Discovery',
    'Interaction',
    'Playfulness',
    'Mystery',
    'Choice',
    'Spontaneity',
    'Variety',
  ];

  static const _icons = [
    Icons.psychology_outlined,
    Icons.explore_outlined,
    Icons.people_outline,
    Icons.sports_esports_outlined,
    Icons.auto_awesome,
    Icons.alt_route,
    Icons.bolt_outlined,
    Icons.palette_outlined,
  ];

  static const _ratingLabels = [
    'Not interesting',
    'Slightly interesting',
    'Moderately interesting',
    'Interesting',
    'Very interesting',
  ];

  static const _ratingIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  void _next(BuildContext context) {
    if (assessmentState.ludicRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please rate how interesting this place is to explore.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DesignResponsePage(assessmentState: assessmentState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(label: 'NEXT', onPressed: () => _next(context)),
      child: AnimatedBuilder(
        animation: assessmentState,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('04 / LUDIC', style: TextStyle(color: _teal, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Your perspective matters', style: TextStyle(color: Color(0xFF82908A), fontSize: 12)),
            ]),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.8,
                minHeight: 6,
                backgroundColor: Color(0xFFE3E5DF),
                valueColor: AlwaysStoppedAnimation<Color>(_teal),
              ),
            ),
            const SizedBox(height: 32),
            Text('LUDIC POTENTIAL', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: _navy, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('What makes this place inviting, playful, or worth exploring?', style: TextStyle(color: Color(0xFF667570), fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            const Row(children: [
              Icon(Icons.auto_awesome_outlined, color: _teal, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('WHICH QUALITIES DESCRIBE THIS PLACE?', style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
            ]),
            const SizedBox(height: 10),
            const Text('Select all that apply, or leave blank.', style: TextStyle(color: Color(0xFF667570), fontSize: 14)),
            const SizedBox(height: 20),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth < 340 ? 1 : 2;
              final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < qualities.length; i++)
                    SizedBox(
                      width: width,
                      child: _QualityCard(
                        label: qualities[i],
                        icon: _icons[i],
                        selected: assessmentState.ludicQualities.contains(qualities[i]),
                        onTap: () => assessmentState.toggleLudicQuality(qualities[i]),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 36),
            const Divider(color: Color(0xFFDCDDD6)),
            const SizedBox(height: 24),
            const Row(children: [
              Icon(Icons.explore_outlined, color: _teal, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('HOW INTERESTING IS THIS PLACE TO EXPLORE?', style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              for (var i = 1; i <= 5; i++)
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () => assessmentState.setLudicRating(i),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 2),
                      decoration: BoxDecoration(
                        color: assessmentState.ludicRating == i ? const Color(0xFFECEFEA) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: assessmentState.ludicRating == i ? _teal : const Color(0xFFDCDDD6), width: assessmentState.ludicRating == i ? 2 : 1),
                      ),
                      child: Column(children: [
                        Icon(_ratingIcons[i - 1], color: assessmentState.ludicRating == i ? _teal : const Color(0xFF82908A), size: 28),
                        const SizedBox(height: 8),
                        Text('$i', style: const TextStyle(color: _navy, fontWeight: FontWeight.w800, fontSize: 16)),
                      ]),
                    ),
                  ),
                )),
            ]),
            const SizedBox(height: 12),
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Not interesting', style: TextStyle(color: Color(0xFF667570), fontSize: 12)),
              Text('Very interesting', style: TextStyle(color: Color(0xFF667570), fontSize: 12)),
            ]),
            if (assessmentState.ludicRating != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFECEFEA), borderRadius: BorderRadius.circular(16)),
                child: Text(_ratingLabels[assessmentState.ludicRating! - 1], textAlign: TextAlign.center, style: const TextStyle(color: _teal, fontWeight: FontWeight.w800, fontSize: 17)),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _QualityCard extends StatelessWidget {
  const _QualityCard({required this.label, required this.icon, required this.selected, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF647C77);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 110),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFECEFEA) : const Color(0xFFF6F4EF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? teal : const Color(0xFFDCDDD6), width: selected ? 2 : 1),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(icon, color: teal, size: 27),
              if (selected) const Icon(Icons.check_circle, color: teal, size: 21),
            ]),
            const SizedBox(height: 14),
            Text(label, style: const TextStyle(color: Color(0xFF202A30), fontSize: 14, fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
    );
  }
}
