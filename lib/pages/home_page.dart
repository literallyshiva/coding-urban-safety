
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'study_area_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  static const Color navy = Color(0xFF183153);
  static const Color teal = Color(0xFF087F8C);
  static const Color coral = Color(0xFFF27B67);
  static const Color cream = Color(0xFFFFF7E8);

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: teal.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_city, color: teal, size: 19),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'AN URBAN EXPLORATION STUDY',
                      style: TextStyle(
                        color: teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Every place\nhas a story.',
              style: TextStyle(
                fontSize: 43,
                height: 1.12,
                fontWeight: FontWeight.w900,
                color: navy,
                letterSpacing: -1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Explore your city. Share your experience.',
              style: TextStyle(
                color: teal,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 25),

            const _UrbanIllustration(),

            const SizedBox(height: 25),
            const Text(
              'How does your city make you feel?',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Help us understand safety, comfort, movement, '
              'and opportunities for playful exploration in '
              'public spaces. Your observations will support '
              'urban design research.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                  ),
            ),
            const SizedBox(height: 20),

            const Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                _TopicChip(
                  icon: Icons.shield_outlined,
                  label: 'Safety',
                  color: teal,
                ),
                _TopicChip(
                  icon: Icons.park_outlined,
                  label: 'Public spaces',
                  color: Color(0xFF468D57),
                ),
                _TopicChip(
                  icon: Icons.explore_outlined,
                  label: 'Exploration',
                  color: coral,
                ),
              ],
            ),
            const SizedBox(height: 27),

            PrimaryActionButton(
              label: 'START EXPLORING  →',
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
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF1E4C9),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: navy,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Research privacy: Information submitted '
                      'through this study is intended solely for '
                      'research purposes. Please avoid including '
                      'names or other identifying details.',
                      style: TextStyle(
                        color: navy,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _UrbanIllustration extends StatelessWidget {
  const _UrbanIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 18,
            right: 22,
            child: Icon(
              Icons.wb_sunny_rounded,
              size: 55,
              color: const Color(0xFFFFC85A),
            ),
          ),
          Positioned(
            top: 20,
            left: 22,
            child: Icon(
              Icons.auto_awesome,
              size: 30,
              color: HomePage.coral,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 44,
              color: const Color(0xFFB5DDC9),
            ),
          ),
          const Positioned(
            bottom: 33,
            left: 14,
            child: Icon(
              Icons.apartment_rounded,
              size: 140,
              color: Color(0xFF82B5B7),
            ),
          ),
          const Positioned(
            bottom: 31,
            right: 8,
            child: Icon(
              Icons.location_city_rounded,
              size: 155,
              color: HomePage.navy,
            ),
          ),
          const Positioned(
            bottom: 25,
            left: 110,
            child: Icon(
              Icons.park_rounded,
              size: 90,
              color: Color(0xFF468D57),
            ),
          ),
          const Positioned(
            top: 34,
            left: 115,
            child: Icon(
              Icons.location_on_rounded,
              size: 53,
              color: HomePage.coral,
            ),
          ),
          const Positioned(
            bottom: 8,
            left: 25,
            child: Icon(
              Icons.directions_walk_rounded,
              size: 43,
              color: HomePage.navy,
            ),
          ),
        ],
      ),
    );
  }
}
