import '../widgets/research_progress.dart';
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import '../widgets/animated_research_choices.dart';
import 'ludic_potential_page.dart';

class SpatialAssessmentPage extends StatelessWidget {
  const SpatialAssessmentPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  static const _navy = Color(0xFF202A30);
  static const _teal = Color(0xFF647C77);

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

  static const _icons = [
    Icons.visibility_outlined,
    Icons.storefront_outlined,
    Icons.directions_walk,
    Icons.alt_route,
    Icons.groups_outlined,
    Icons.accessibility_new_outlined,
    Icons.lightbulb_outline,
    Icons.chair_outlined,
    Icons.door_front_door_outlined,
    Icons.architecture_outlined,
  ];
  static const _cardEmojis = ['👀', '🏪', '🚶', '🛤️', '🧑‍🤝‍🧑', '♿', '💡', '🪑', '🚪', '🏛️'];

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      illustration: 'assets/images/illustrated/08_spatial.png',
      sectionLabel: 'SPATIAL CONDITIONS',
      bottomButton: PrimaryActionButton(
        label: 'NEXT',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LudicPotentialPage(
              assessmentState: assessmentState,
            ),
          ),
        ),
      ),
      child: AnimatedBuilder(
        animation: assessmentState,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const ResearchProgress(stage: 2),
              const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('03 / SPATIAL', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                Text('Your perspective matters', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.6,
                minHeight: 6,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 32),
            Text('SPATIAL CONDITIONS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text('Look around. Which features can you notice in this place?', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            Row(children: [
              Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.primary, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('WHICH SPATIAL CONDITIONS ARE PRESENT HERE?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
            ]),
            const SizedBox(height: 10),
            Text('Select all that apply, or leave blank.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
            const SizedBox(height: 20),
            Text('\u2713 ${assessmentState.spatialConditions.length} of ${spatialOptions.length} selected', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            LayoutBuilder(builder: (context, constraints) {
              final columns = constraints.maxWidth < 340 ? 1 : 2;
              final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < spatialOptions.length; i++)
                    SizedBox(
                      width: width,
                      child: AnimatedResearchChoice(
                        label: spatialOptions[i],
                        emoji: _cardEmojis[i],
                        delay: i * 0.11,
                        selected: assessmentState.spatialConditions.contains(spatialOptions[i]),
                        onTap: () => assessmentState.toggleSpatialCondition(spatialOptions[i]),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

