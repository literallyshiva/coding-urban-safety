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
  static const teal = Color(0xFF007D78);

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
      immersiveSafety: true,
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
              Row(children: [
                const Icon(Icons.shield_outlined, color: Color(0xFF007D78), size: 22),
                const SizedBox(width: 9),
                const Expanded(child: Text('YOUR CITY EXPLORATION', style: TextStyle(
                  color: Color(0xFF12374A), fontWeight: FontWeight.w900,
                  letterSpacing: 1.2, fontSize: 11))),
                const Text('1 / 5', style: TextStyle(fontWeight: FontWeight.w800,
                  color: Color(0xFF12374A))),
              ]),
              const SizedBox(height: 13),
              ClipRRect(borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(value: .2, minHeight: 7,
                  backgroundColor: Color(0xFFE5E9E6),
                  valueColor: AlwaysStoppedAnimation(Color(0xFF007D78)))),
              const SizedBox(height: 19),
              const Text('How safe do you\nfeel here?',
                style: TextStyle(color: Color(0xFF103247),
                  fontSize: 32, height: 1.12, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('Think about your overall experience at this location.',
                style: TextStyle(color: Color(0xFF56636A), fontSize: 14, height: 1.45)),
              const SizedBox(height: 22),
              Row(children: [for (var i=1; i<=5; i++)
                Expanded(child: _SafetyRatingTile(
                  rating: i, label: ratingLabels[i-1],
                  selected: rating == i,
                  onTap: () => state.setSafetyRating(i))),
              ]),
              if (rating != null) ...[
                const SizedBox(height: 12),
                Text('Selected: ${ratingLabels[rating-1]}',
                  style: const TextStyle(color: Color(0xFF007D78),
                    fontSize: 13, fontWeight: FontWeight.w700)),
              ],
              const SizedBox(height: 22),
              Row(children: [
                const Icon(Icons.visibility_outlined, color: Color(0xFF007D78), size: 24),
                const SizedBox(width: 10),
                const Expanded(child: Text('What makes this place feel unsafe?',
                  style: TextStyle(fontSize: 19, height: 1.25,
                    color: Color(0xFF103247), fontWeight: FontWeight.w900))),
              ]),
              const SizedBox(height: 7),
              const Text('Select all that apply, or leave blank.',
                style: TextStyle(fontSize: 13, color: Color(0xFF56636A))),
              const SizedBox(height: 15),
              LayoutBuilder(builder: (context, constraints) {
                final cols = constraints.maxWidth < 440 ? 1 : 2;
                final width = (constraints.maxWidth - (cols-1)*10) / cols;
                return Wrap(spacing: 10, runSpacing: 10, children: [
                  for (var i=0; i<unsafeOptions.length; i++)
                    SizedBox(width: width, child: _SafetyConditionTile(
                      label: unsafeOptions[i], emoji: unsafeEmojis[i],
                      selected: state.unsafeConditions.contains(unsafeOptions[i]),
                      onTap: () => state.toggleUnsafeCondition(unsafeOptions[i]))),
                ]);
              }),
              const SizedBox(height: 12),
              Text('${state.unsafeConditions.length} of ${unsafeOptions.length} selected',
                style: const TextStyle(color: Color(0xFF007D78),
                  fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _SafetyRatingTile extends StatelessWidget {
  const _SafetyRatingTile({required this.rating, required this.label,
    required this.selected, required this.onTap});
  final int rating;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  static const faceIcons = [
    Icons.sentiment_very_dissatisfied_rounded,
    Icons.sentiment_dissatisfied_rounded,
    Icons.sentiment_neutral_rounded,
    Icons.sentiment_satisfied_rounded,
    Icons.sentiment_very_satisfied_rounded,
  ];
  static const faceColors = [
    Color(0xFFFF626C), Color(0xFFFF974F), Color(0xFFFFCC4E),
    Color(0xFF19C8BA), Color(0xFF007F7A),
  ];
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Semantics(button: true, selected: selected,
        label: '$rating: $label', child: InkWell(
          onTap: onTap, borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(duration: const Duration(milliseconds: 180),
            constraints: const BoxConstraints(minHeight: 126),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFDDF7F1) : const Color(0xFFFFFBF7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? const Color(0xFF007D78)
                : const Color(0xFFE5DDD6), width: selected ? 2 : 1),
              boxShadow: selected ? [const BoxShadow(
                color: Color(0x26007D78), blurRadius: 12, offset: Offset(0, 5))] : null),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 43, height: 43,
                decoration: BoxDecoration(
                  color: faceColors[rating - 1], shape: BoxShape.circle),
                child: Icon(faceIcons[rating - 1], size: 30,
                  color: rating == 5 ? Colors.white : const Color(0xFF163646)),
              ),
              const SizedBox(height: 5),
              Text('$rating', style: const TextStyle(fontSize: 15,
                color: Color(0xFF12374A), fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Color(0xFF12374A),
                  height: 1.15, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ),
  );
}

class _SafetyConditionTile extends StatelessWidget {
  const _SafetyConditionTile({required this.label, required this.emoji,
    required this.selected, required this.onTap});
  final String label, emoji;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true, selected: selected, label: label,
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE4F7F1) : const Color(0xFFF7F8F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? const Color(0xFF80CFC0)
            : const Color(0xFFE6E9E7))),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFBDEBE1) : const Color(0xFFFFEEDB),
              borderRadius: BorderRadius.circular(11)),
            child: Text(emoji, style: const TextStyle(fontSize: 19))),
          const SizedBox(width: 9),
          Expanded(child: Text(label, style: const TextStyle(
            color: Color(0xFF12374A), fontSize: 12, fontWeight: FontWeight.w600))),
          Icon(selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
            size: 21, color: selected ? const Color(0xFF007D78)
              : const Color(0xFFBBC6C7)),
        ]),
      ),
    ),
  );
}
