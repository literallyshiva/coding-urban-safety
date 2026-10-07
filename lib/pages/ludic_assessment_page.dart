import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'spatial_assessment_page.dart';

class LudicAssessmentPage extends StatefulWidget {
  const LudicAssessmentPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  State<LudicAssessmentPage> createState() => _LudicAssessmentPageState();
}

class _LudicAssessmentPageState extends State<LudicAssessmentPage> {
  static const experienceOptions = [
    'Move through',
    'Stay / spend time',
    'Interact with people',
    'Choose different routes',
    'Explore the area',
    'Discover something new',
  ];

  void _next() {
    if (widget.assessmentState.spendMoreTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer whether you would spend more time here.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpatialAssessmentPage(
          assessmentState: widget.assessmentState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.assessmentState;
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(label: 'NEXT', onPressed: _next),
      child: AnimatedBuilder(
        animation: state,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXPERIENCE OF PLACE', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 28),
            const SectionQuestion('WHAT DOES THIS PLACE ENCOURAGE YOU TO DO?'),
            ChipWrap(
              options: experienceOptions,
              isSelected: state.placeExperience.contains,
              onSelected: state.togglePlaceExperience,
            ),
            const SizedBox(height: 36),
            const SectionQuestion('WOULD YOU LIKE TO SPEND MORE TIME HERE?'),
            ChipWrap(
              options: const ['YES', 'MAYBE', 'NO'],
              isSelected: (value) => state.spendMoreTime == value,
              onSelected: state.setSpendMoreTime,
            ),
          ],
        ),
      ),
    );
  }
}
