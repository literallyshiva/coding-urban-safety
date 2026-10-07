import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'design_response_page.dart';

class LudicPotentialPage extends StatelessWidget {
  const LudicPotentialPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

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
      bottomButton: PrimaryActionButton(
        label: 'NEXT',
        onPressed: () => _next(context),
      ),
      child: AnimatedBuilder(
        animation: assessmentState,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('LUDIC POTENTIAL', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 28),
            const SectionQuestion('WHICH QUALITIES DESCRIBE THIS PLACE?'),
            ChipWrap(
              options: qualities,
              isSelected: assessmentState.ludicQualities.contains,
              onSelected: assessmentState.toggleLudicQuality,
            ),
            const SizedBox(height: 36),
            const SectionQuestion('HOW INTERESTING IS THIS PLACE TO EXPLORE?'),
            ChipWrap(
              options: const ['1', '2', '3', '4', '5'],
              isSelected: (value) => assessmentState.ludicRating == int.parse(value),
              onSelected: (value) => assessmentState.setLudicRating(int.parse(value)),
            ),
          ],
        ),
      ),
    );
  }
}
