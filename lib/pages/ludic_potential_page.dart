import '../widgets/research_progress.dart';
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import '../widgets/animated_research_choices.dart';
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
  static const _cardEmojis = ['🧠', '🧭', '🤝', '🎮', '✨', '🛤️', '⚡', '🎨'];

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
              const ResearchProgress(stage: 3),
              const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('04 / LUDIC', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Your perspective matters', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
            ]),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.8,
                minHeight: 6,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 32),
            Text('LUDIC POTENTIAL', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text('What makes this place inviting, playful, or worth exploring?', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            Row(children: [
              Icon(Icons.auto_awesome_outlined, color: Theme.of(context).colorScheme.primary, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('WHICH QUALITIES DESCRIBE THIS PLACE?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
            ]),
            const SizedBox(height: 10),
            Text('Select all that apply, or leave blank.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
            const SizedBox(height: 20),
            Text('\u2713 ${assessmentState.ludicQualities.length} of ${qualities.length} selected', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
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
                      child: AnimatedResearchChoice(
                        label: qualities[i],
                        emoji: _cardEmojis[i],
                        delay: i * 0.11,
                        selected: assessmentState.ludicQualities.contains(qualities[i]),
                        onTap: () => assessmentState.toggleLudicQuality(qualities[i]),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 36),
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 24),
            Row(children: [
              Icon(Icons.explore_outlined, color: Theme.of(context).colorScheme.primary, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('HOW INTERESTING IS THIS PLACE TO EXPLORE?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              for (var i = 1; i <= 5; i++)
                AnimatedResearchRating(
                  rating: i,
                  selected: assessmentState.ludicRating == i,
                  onTap: () => assessmentState.setLudicRating(i),
                ),
            ]),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Not interesting', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              Text('Very interesting', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
            ]),
            if (assessmentState.ludicRating != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                child: Text(_ratingLabels[assessmentState.ludicRating! - 1], textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.w800, fontSize: 17)),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

