import '../widgets/research_progress.dart';

import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import '../widgets/animated_research_choices.dart';
import 'ludic_assessment_page.dart';

class SafetyAssessmentPage extends StatefulWidget {
  const SafetyAssessmentPage({
    super.key,
    required this.assessmentState,
  });

  final AssessmentState assessmentState;

  @override
  State<SafetyAssessmentPage> createState() =>
      _SafetyAssessmentPageState();
}

class _SafetyAssessmentPageState extends State<SafetyAssessmentPage> {
  static const navy = Color(0xFF202A30);
  static const teal = Color(0xFF647C77);

  static const unsafeOptions = [
    'Poor lighting',
    'Poor visibility',
    'Isolated / few people',
    'Lack of activity',
    'Difficult pedestrian movement',
    'Traffic conflict',
    'Poor maintenance',
    'Inactive / blank edges',
  ];

  static const unsafeEmojis = [
    '💡', '👁️', '🏜️', '🌙', '🚶', '🚦', '🧹', '🏚️',
  ];

  static const ratingLabels = [
    'Very unsafe',
    'Unsafe',
    'Neutral',
    'Safe',
    'Very safe',
  ];

  static const ratingIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  void _next() {
    if (widget.assessmentState.safetyRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a safety rating.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LudicAssessmentPage(
          assessmentState: widget.assessmentState,
        ),
      ),
    );
  }

  Widget _ratingOption(AssessmentState state, int rating) {
    return AnimatedResearchRating(
      rating: rating,
      selected: state.safetyRating == rating,
      onTap: () => state.setSafetyRating(rating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.assessmentState;

    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: 'NEXT',
        onPressed: _next,
      ),
      child: AnimatedBuilder(
        animation: state,
        builder: (_, __) {
          final rating = state.safetyRating;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ResearchProgress(stage: 0),
              const SizedBox(height: 18),
              Row(children: [
                Icon(Icons.shield_outlined,
                  color: Theme.of(context).colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Text('01 / SAFETY',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                const Spacer(),
                Text('YOUR PERSPECTIVE',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 22),
              Text('How safe do you\\nfeel here?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 35, height: 1.12, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text('Think about your experience at this location. There are no right or wrong answers.',
                style: TextStyle(fontSize: 15, height: 1.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Column(children: [
                  Row(children: [
                    for (int i = 1; i <= 5; i++) _ratingOption(state, i),
                  ]),
                  const SizedBox(height: 14),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('VERY UNSAFE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    Text('VERY SAFE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ]),
                  if (rating != null) ...[
                    const SizedBox(height: 18),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        Text(ratingLabels[rating - 1],
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19,
                            color: Theme.of(context).colorScheme.onPrimaryContainer)),
                        const SizedBox(height: 3),
                        Text('Your safety perception',
                          style: TextStyle(fontSize: 12,
                            color: Theme.of(context).colorScheme.onPrimaryContainer)),
                      ]),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(Icons.visibility_outlined, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(child: Text('What conditions affect safety here?',
                      style: TextStyle(fontSize: 19, height: 1.25,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface))),
                  ]),
                  const SizedBox(height: 8),
                  Text('Select any that you noticed. This question is optional.',
                    style: TextStyle(fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  Text('${state.unsafeConditions.length} SELECTED',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 12),
                  LayoutBuilder(builder: (context, constraints) {
                    final columns = constraints.maxWidth < 390 ? 1 : 2;
                    final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
                    return Wrap(spacing: 12, runSpacing: 12, children: [
                      for (var i = 0; i < unsafeOptions.length; i++)
                        SizedBox(width: width, child: AnimatedResearchChoice(
                          label: unsafeOptions[i],
                          emoji: unsafeEmojis[i],
                          delay: i * .09,
                          selected: state.unsafeConditions.contains(unsafeOptions[i]),
                          onTap: () => state.toggleUnsafeCondition(unsafeOptions[i]),
                        )),
                    ]);
                  }),
                ]),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
