import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'ludic_potential_page.dart';

class SpatialAssessmentPage extends StatelessWidget {
  const SpatialAssessmentPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  static const spatialOptions = [
    'Good visibility',
    'Active edges / frontages',
    'Good pedestrian connectivity',
    'Multiple route choices',
    'Presence of people / activity',
    'Comfortable walking space',
    'Adequate lighting',
    'Places to sit / stay',
    'Clear entrances and exits',
    'Interesting spatial elements',
  ];

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: 'NEXT',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LudicPotentialPage(
                assessmentState: assessmentState,
              ),
            ),
          );
        },
      ),
      child: AnimatedBuilder(
        animation: assessmentState,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SPATIAL CONDITIONS', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 28),
            const SectionQuestion('WHICH SPATIAL CONDITIONS ARE PRESENT HERE?'),
            ChipWrap(
              options: spatialOptions,
              isSelected: assessmentState.spatialConditions.contains,
              onSelected: assessmentState.toggleSpatialCondition,
            ),
          ],
        ),
      ),
    );
  }
}
