import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'map_page.dart';

class StudyAreaPage extends StatelessWidget {
  const StudyAreaPage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: 'START WALK',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MapPage(assessmentState: assessmentState),
            ),
          );
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPLORE THE STUDY AREA',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          Text(
            'Walk through the study area and observe the surroundings carefully. Notice how people move, where they pause, how visible and active the edges are, and how the space makes you feel. Select a place that you would like to assess.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 26),
          const _InstructionCard(
            number: '01',
            title: 'Walk',
            text: 'Move through the area at a comfortable pace.',
          ),
          const _InstructionCard(
            number: '02',
            title: 'Observe',
            text: 'Notice safety, activity, routes, edges and spatial character.',
          ),
          const _InstructionCard(
            number: '03',
            title: 'Choose',
            text: 'Stop at a place that feels meaningful to assess.',
          ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({
    required this.number,
    required this.title,
    required this.text,
  });

  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E2ED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(text, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
