import '../widgets/research_progress.dart';
import '../widgets/v2_question_card.dart';

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
      v2Mode: true,
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
              V2QuestionCard(
                number: '01',
                icon: Icons.shield_outlined,
                title: 'How safe do you feel here?',
                description: 'Think about your experience at this location. Choose one answer.',
                child: Column(children: [
                  Row(children: [for (int i = 1; i <= 5; i++)
                    _ratingOption(state, i)]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Very unsafe', style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12)), Text('Very safe', style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12))]),
                ]),
              ),
              if (rating != null) ...[
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        ratingLabels[rating - 1],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your selected safety rating',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 18),
              V2QuestionCard(
                number: '02',
                icon: Icons.visibility_outlined,
                title: 'Which conditions affect safety here?',
                description: 'Select any conditions you observed. This question is optional for every safety rating.',
                optional: true,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('\u2713 ${state.unsafeConditions.length} of ${unsafeOptions.length} selected', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            LayoutBuilder(builder: (context, constraints) {
                final columns = constraints.maxWidth < 340 ? 1 : 2;
                final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (var i = 0; i < unsafeOptions.length; i++)
                      SizedBox(
                        width: width,
                        child: AnimatedResearchChoice(
                          label: unsafeOptions[i],
                          emoji: unsafeEmojis[i],
                          delay: i * .13,
                          selected: state.unsafeConditions.contains(unsafeOptions[i]),
                          onTap: () => state.toggleUnsafeCondition(unsafeOptions[i]),
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 8),
                ]),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
