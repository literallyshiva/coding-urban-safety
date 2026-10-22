import '../widgets/research_progress.dart';
import '../widgets/editorial_city_artwork.dart';

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
      illustration: 'assets/images/illustrated/06_safety.png',
      sectionLabel: 'SAFETY',
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
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '01 / SAFETY',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Your perspective matters',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.2,
                  minHeight: 6,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(height: 24),
              // Safety illustration is integrated into the page header.
              const SizedBox(height: 26),

              Text(
                'How safe do you\nfeel here?',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 34,
                      height: 1.12,
                    ),
              ),

              const SizedBox(height: 12),

              Text(
                'Choose the feeling that best describes '
                'this place.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 26),

              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    _ratingOption(state, i),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Very Unsafe',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Very Safe',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
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

              const SizedBox(height: 34),
              Container(height: 5, width: 62,
                decoration: BoxDecoration(color: const Color(0xFFFF775F),
                  borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 26),

              Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'WHAT MAKES THIS PLACE FEEL UNSAFE?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                'Select all that apply, or leave blank.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
