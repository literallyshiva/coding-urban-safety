import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'review_assessment_page.dart';

class DesignResponsePage extends StatefulWidget {
  const DesignResponsePage({super.key, required this.assessmentState});
  final AssessmentState assessmentState;

  @override
  State<DesignResponsePage> createState() => _DesignResponsePageState();
}

class _DesignResponsePageState extends State<DesignResponsePage> {
  static const navy = Color(0xFF202A30);
  static const teal = Color(0xFF647C77);

  static const responses = [
    'Improve lighting',
    'Improve visibility / sightlines',
    'Activate blank edges / frontages',
    'Improve pedestrian paths',
    'Create safer crossings',
    'Add places to sit and stay',
    'Introduce more activities',
    'Create opportunities for interaction',
    'Provide alternative routes / choices',
    'Add playful or interactive elements',
    'Improve maintenance and cleanliness',
    'Add landscape / shade / comfort',
  ];

  static const responseIcons = [
    Icons.lightbulb_outline,
    Icons.visibility_outlined,
    Icons.storefront_outlined,
    Icons.directions_walk,
    Icons.traffic_outlined,
    Icons.chair_outlined,
    Icons.local_activity_outlined,
    Icons.people_outline,
    Icons.alt_route,
    Icons.auto_awesome,
    Icons.cleaning_services_outlined,
    Icons.park_outlined,
  ];

  late final TextEditingController _otherController;

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController(text: widget.assessmentState.otherSuggestion);
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _review() {
    FocusScope.of(context).unfocus();
    widget.assessmentState.setOtherSuggestion(_otherController.text);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReviewAssessmentPage(
        assessmentState: widget.assessmentState,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.assessmentState;
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: 'REVIEW & SUBMIT',
        onPressed: _review,
      ),
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('05 / DESIGN', style: TextStyle(color: teal, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Final step', style: TextStyle(color: Color(0xFF82908A), fontSize: 12)),
            ]),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 1.0,
                minHeight: 6,
                backgroundColor: Color(0xFFE3E5DF),
                valueColor: AlwaysStoppedAnimation<Color>(teal),
              ),
            ),
            const SizedBox(height: 32),
            Text('DESIGN RESPONSES', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: navy, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text('Imagine a better version of this place. What would you change?', style: TextStyle(color: Color(0xFF667570), fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            const Row(children: [
              Icon(Icons.tips_and_updates_outlined, color: teal, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('WHAT COULD MAKE THIS PLACE FEEL SAFER AND MORE ENGAGING?', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
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
                  for (var i = 0; i < responses.length; i++)
                    SizedBox(
                      width: width,
                      child: _DesignCard(
                        label: responses[i],
                        icon: responseIcons[i],
                        selected: state.designResponses.contains(responses[i]),
                        onTap: () => state.toggleDesignResponse(responses[i]),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 36),
            const Divider(color: Color(0xFFDCDDD6)),
            const SizedBox(height: 24),
            const Row(children: [
              Icon(Icons.edit_note_outlined, color: teal, size: 26),
              SizedBox(width: 10),
              Text('OTHER SUGGESTION', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 10),
            const Text('Optional — tell us something we may have missed.', style: TextStyle(color: Color(0xFF667570), fontSize: 14)),
            const SizedBox(height: 16),
            TextField(
              controller: _otherController,
              minLines: 4,
              maxLines: 7,
              maxLength: 1000,
              textCapitalization: TextCapitalization.sentences,
              onChanged: state.setOtherSuggestion,
              decoration: InputDecoration(
                hintText: 'Describe what you would change in this place...',
                filled: true,
                fillColor: const Color(0xFFF6F4EF),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _DesignCard extends StatelessWidget {
  const _DesignCard({required this.label, required this.icon, required this.selected, required this.onTap});
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(icon, color: teal, size: 27),
              if (selected) const Icon(Icons.check_circle, color: teal, size: 21),
            ]),
            const SizedBox(height: 14),
            Text(label, style: const TextStyle(color: Color(0xFF202A30), fontSize: 14, fontWeight: FontWeight.w700, height: 1.3)),
          ]),
        ),
      ),
    );
  }
}
