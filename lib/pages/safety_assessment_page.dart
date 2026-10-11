
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
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
  static const navy = Color(0xFF183153);
  static const teal = Color(0xFF087F8C);

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

  Widget _ratingOption(
    AssessmentState state,
    int rating,
  ) {
    final selected = state.safetyRating == rating;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: () => state.setSafetyRating(rating),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              vertical: 17,
              horizontal: 3,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE6F5F2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? teal
                    : const Color(0xFFE0E2E8),
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  ratingIcons[rating - 1],
                  color: selected
                      ? teal
                      : const Color(0xFF8290A0),
                  size: 30,
                ),
                const SizedBox(height: 9),
                Text(
                  '$rating',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: selected ? teal : navy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '01 / SAFETY',
                    style: TextStyle(
                      color: teal,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Your perspective matters',
                    style: TextStyle(
                      color: Colors.blueGrey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: 0.2,
                  minHeight: 6,
                  backgroundColor: Color(0xFFE4E7ED),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(teal),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'HOW SAFE DO YOU FEEL HERE?',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: navy,
                      fontWeight: FontWeight.w900,
                    ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Choose the feeling that best describes '
                'this place.',
                style: TextStyle(
                  color: Color(0xFF667589),
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

              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Very Unsafe',
                    style: TextStyle(
                      color: Color(0xFF667589),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Very Safe',
                    style: TextStyle(
                      color: Color(0xFF667589),
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
                    color: const Color(0xFFE6F5F2),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        ratingLabels[rating - 1],
                        style: const TextStyle(
                          color: teal,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Your selected safety rating',
                        style: TextStyle(
                          color: Color(0xFF667589),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 36),

              const Divider(
                color: Color(0xFFE2E5EB),
              ),

              const SizedBox(height: 24),

              const Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: teal,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'WHAT MAKES THIS PLACE FEEL UNSAFE?',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                'Select all that apply, or leave blank.',
                style: TextStyle(
                  color: Color(0xFF667589),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 9,
                runSpacing: 10,
                children: unsafeOptions.map((option) {
                  final selected =
                      state.unsafeConditions.contains(option);

                  return ChoiceChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (_) =>
                        state.toggleUnsafeCondition(option),
                    showCheckmark: selected,
                    checkmarkColor: teal,
                    selectedColor:
                        const Color(0xFFE6F5F2),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: selected
                          ? teal
                          : const Color(0xFFDADDE4),
                    ),
                    labelStyle: TextStyle(
                      color: selected ? teal : navy,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 10,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
