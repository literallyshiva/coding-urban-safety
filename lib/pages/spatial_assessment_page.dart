import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
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

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('03 / SPATIAL', style: TextStyle(color: _teal, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                Text('Your perspective matters', style: TextStyle(color: Color(0xFF82908A), fontSize: 12)),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.6,
                minHeight: 6,
                backgroundColor: Color(0xFFE3E5DF),
                valueColor: AlwaysStoppedAnimation<Color>(_teal),
              ),
            ),
            const SizedBox(height: 32),
            Text('SPATIAL CONDITIONS', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: _navy, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('Look around. Which features can you notice in this place?', style: TextStyle(color: Color(0xFF667570), fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            const Row(children: [
              Icon(Icons.map_outlined, color: _teal, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('WHICH SPATIAL CONDITIONS ARE PRESENT HERE?', style: TextStyle(color: _navy, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
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
                  for (var i = 0; i < spatialOptions.length; i++)
                    SizedBox(
                      width: width,
                      child: _SpatialCard(
                        label: spatialOptions[i],
                        icon: _icons[i],
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

class _SpatialCard extends StatelessWidget {
  const _SpatialCard({required this.label, required this.icon, required this.selected, required this.onTap});
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
          constraints: const BoxConstraints(minHeight: 116),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFECEFEA) : const Color(0xFFF6F4EF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? teal : const Color(0xFFDCDDD6), width: selected ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Icon(icon, color: teal, size: 27),
                if (selected) const Icon(Icons.check_circle, color: teal, size: 21),
              ]),
              const SizedBox(height: 14),
              Text(label, style: const TextStyle(color: Color(0xFF202A30), fontSize: 14, fontWeight: FontWeight.w700, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}
