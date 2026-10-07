import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'study_area_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      child: Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 34),
            Text('WELCOME', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              'Mapping Safety, Experience & Exploration',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.25,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'This urban design research application explores how people experience safety, spatial qualities, and opportunities for exploration and interaction in public spaces. Your observations will contribute structured place-based evidence for later analysis.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 34),
            PrimaryActionButton(
              label: 'START EXPLORING',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StudyAreaPage(
                      assessmentState: assessmentState,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
