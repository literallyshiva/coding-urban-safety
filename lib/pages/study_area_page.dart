
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../services/app_preferences.dart';
import '../widgets/research_scaffold.dart';
import 'map_page.dart';

class StudyAreaPage extends StatelessWidget {
  const StudyAreaPage({
    super.key,
    required this.assessmentState,
  });

  final AssessmentState assessmentState;

  @override
  Widget build(BuildContext context) {
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: AppPreferences.instance.tr('START WALK', 'നടത്തം ആരംഭിക്കുക'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MapPage(
                assessmentState: assessmentState,
              ),
            ),
          );
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.grid_on_outlined, size: 17, color: Color(0xFF647C77)),
            SizedBox(width: 10),
            Text('FIELD NOTES  /  02  LOCATION', style: TextStyle(
              color: Color(0xFF647C77), fontSize: 12,
              fontWeight: FontWeight.w800, letterSpacing: 1.6)),
          ]),
          const SizedBox(height: 22),
          Text(
            AppPreferences.instance.tr('EXPLORE THE STUDY AREA', 'പഠന പ്രദേശം പര്യവേക്ഷണം ചെയ്യുക'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 14),

          Text(
            AppPreferences.instance.tr('Every street, park, and public space has a story. Take a moment to observe your surroundings and share how the space makes you feel.', 'ഓരോ തെരുവിനും പാർക്കിനും പൊതു ഇടത്തിനും ഒരു കഥയുണ്ട്. ചുറ്റുപാടുകൾ നിരീക്ഷിച്ച് നിങ്ങളുടെ അനുഭവം പങ്കുവെക്കൂ.'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 24),

          // Gender selection
          AnimatedBuilder(
            animation: assessmentState,
            builder: (context, _) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEFEA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFCDD8D0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: Color(0xFF647C77),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'ABOUT YOU',
                            style: TextStyle(
                              color: Color(0xFF202A30),
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'Gender (optional)',
                      style: TextStyle(
                        color: Color(0xFF202A30),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 13),

                    // Male, Female and Other options
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        _GenderChoice(
                          label: 'Male',
                          icon: Icons.male,
                          selected:
                              assessmentState.gender == 'Male',
                          onTap: () {
                            assessmentState.setGender('Male');
                          },
                        ),

                        _GenderChoice(
                          label: 'Female',
                          icon: Icons.female,
                          selected:
                              assessmentState.gender == 'Female',
                          onTap: () {
                            assessmentState.setGender('Female');
                          },
                        ),

                        _GenderChoice(
                          label: 'Other',
                          icon: Icons.person_outline,
                          selected:
                              assessmentState.gender == 'Other',
                          onTap: () {
                            assessmentState.setGender('Other');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: assessmentState.gender == null
                          ? null
                          : () {
                              assessmentState.setGender(null);
                            },
                      child: const Text('Clear selection'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 27),

          const _InstructionCard(
            number: '01',
            title: 'Walk',
            text: 'Move through the area at a comfortable pace.',
            icon: Icons.directions_walk,
          ),

          const _InstructionCard(
            number: '02',
            title: 'Observe',
            text: 'Notice safety, activity, routes, edges, '
                'and spatial character.',
            icon: Icons.visibility_outlined,
          ),

          const _InstructionCard(
            number: '03',
            title: 'Choose',
            text: 'Stop at a place that feels meaningful to assess.',
            icon: Icons.place_outlined,
          ),
        ],
      ),
    );
  }
}

// Gender selection chip
class _GenderChoice extends StatelessWidget {
  const _GenderChoice({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF647C77);

    return ChoiceChip(
      label: Text(label),
      avatar: Icon(
        icon,
        size: 20,
        color: selected ? Colors.white : teal,
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: teal,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : const Color(0xFF202A30),
        fontWeight: FontWeight.w700,
      ),
      side: BorderSide(
        color: selected
            ? teal
            : const Color(0xFFCDD8D0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      showCheckmark: false,
    );
  }
}

// Study area instruction card
class _InstructionCard extends StatelessWidget {
  const _InstructionCard({
    required this.number,
    required this.title,
    required this.text,
    required this.icon,
  });

  final String number;
  final String title;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E2ED),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF647C77),
            size: 24,
          ),
          const SizedBox(width: 14),

          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFFD2A27B),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
