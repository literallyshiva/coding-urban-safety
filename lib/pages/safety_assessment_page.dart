import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'ludic_assessment_page.dart';

class SafetyAssessmentPage extends StatefulWidget {
  const SafetyAssessmentPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  State<SafetyAssessmentPage> createState() => _SafetyAssessmentPageState();
}

class _SafetyAssessmentPageState extends State<SafetyAssessmentPage> {
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

  void _next() {
    if (widget.assessmentState.safetyRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a safety rating.')),
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
            Text(
              'HOW SAFE DO YOU FEEL HERE?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 22),
            ChipWrap(
              options: const ['1', '2', '3', '4', '5'],
              isSelected: (value) => state.safetyRating == int.parse(value),
              onSelected: (value) => state.setSafetyRating(int.parse(value)),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Very Unsafe'),
                Text('Very Safe'),
              ],
            ),
            const SizedBox(height: 36),
            const SectionQuestion('WHAT MAKES THIS PLACE FEEL UNSAFE?'),
            ChipWrap(
              options: unsafeOptions,
              isSelected: state.unsafeConditions.contains,
              onSelected: state.toggleUnsafeCondition,
            ),
          ],
        ),
      ),
    );
  }
}
