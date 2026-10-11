
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'spatial_assessment_page.dart';

class LudicAssessmentPage extends StatefulWidget {
  const LudicAssessmentPage({
    super.key,
    required this.assessmentState,
  });

  final AssessmentState assessmentState;

  @override
  State<LudicAssessmentPage> createState() =>
      _LudicAssessmentPageState();
}

class _LudicAssessmentPageState extends State<LudicAssessmentPage> {
  static const navy = Color(0xFF202A30);
  static const teal = Color(0xFF647C77);

  static const experienceOptions = [
    'Move through',
    'Stay / spend time',
    'Interact with people',
    'Choose different routes',
    'Explore the area',
    'Discover something new',
  ];

  static const experienceIcons = [
    Icons.directions_walk,
    Icons.chair_outlined,
    Icons.people_outline,
    Icons.alt_route,
    Icons.explore_outlined,
    Icons.auto_awesome,
  ];

  static const spendOptions = ['YES', 'MAYBE', 'NO'];

  static const spendIcons = [
    Icons.favorite_outline,
    Icons.help_outline,
    Icons.arrow_forward,
  ];

  void _next() {
    if (widget.assessmentState.spendMoreTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please answer whether you would spend more time here.',
          ),
        ),
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

  Widget _experienceCard(
    AssessmentState state,
    int index,
  ) {
    final option = experienceOptions[index];
    final selected = state.placeExperience.contains(option);

    return InkWell(
      onTap: () => state.togglePlaceExperience(option),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(minHeight: 112),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFECEFEA)
              : const Color(0xFFF6F4EF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? teal
                : const Color(0xFFDCDDD6),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  experienceIcons[index],
                  color: teal,
                  size: 27,
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: teal,
                    size: 21,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              option,
              style: const TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _spendCard(
    AssessmentState state,
    int index,
  ) {
    final option = spendOptions[index];
    final selected = state.spendMoreTime == option;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: () => state.setSpendMoreTime(option),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFECEFEA)
                  : const Color(0xFFF6F4EF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? teal
                    : const Color(0xFFDCDDD6),
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  spendIcons[index],
                  color: selected
                      ? teal
                      : const Color(0xFF82908A),
                  size: 28,
                ),
                const SizedBox(height: 10),
                Text(
                  option,
                  style: TextStyle(
                    color: selected ? teal : navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.assessmentState;

    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: 'NEXT',
        onPressed: _next,
      ),
      child: AnimatedBuilder(
        animation: state,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '02 / EXPERIENCE',
                  style: TextStyle(
                    color: teal,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Your perspective matters',
                  style: TextStyle(
                    color: Color(0xFF82908A),
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.4,
                minHeight: 6,
                backgroundColor: Color(0xFFE3E5DF),
                valueColor:
                    AlwaysStoppedAnimation<Color>(teal),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'EXPERIENCE OF PLACE',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    color: navy,
                    fontWeight: FontWeight.w900,
                  ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tell us how this space invites you to '
              'move, explore and connect.',
              style: TextStyle(
                color: Color(0xFF667570),
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            const Row(
              children: [
                Icon(
                  Icons.explore_outlined,
                  color: teal,
                  size: 26,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'WHAT DOES THIS PLACE ENCOURAGE YOU TO DO?',
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Select all that apply.',
              style: TextStyle(
                color: Color(0xFF667570),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (context, constraints) {
                final spacing = 12.0;
                final cardWidth =
                    (constraints.maxWidth - spacing) / 2;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (int i = 0;
                        i < experienceOptions.length;
                        i++)
                      SizedBox(
                        width: cardWidth,
                        child: _experienceCard(state, i),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 36),

            const Divider(
              color: Color(0xFFDCDDD6),
            ),

            const SizedBox(height: 24),

            const Row(
              children: [
                Icon(
                  Icons.favorite_border,
                  color: teal,
                  size: 26,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'WOULD YOU LIKE TO SPEND MORE TIME HERE?',
                    style: TextStyle(
                      color: navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                for (int i = 0; i < spendOptions.length; i++)
                  _spendCard(state, i),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
