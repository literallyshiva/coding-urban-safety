import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import '../widgets/animated_research_choices.dart';
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
  static const _cardEmojis = ['💡', '👁️', '🏪', '🚶', '🚦', '🪑', '🎟️', '🤝', '🛤️', '🎡', '🧹', '🌳'];

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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('05 / DESIGN', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Final step', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
            ]),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 1.0,
                minHeight: 6,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 32),
            Text('DESIGN RESPONSES', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text('Imagine a better version of this place. What would you change?', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            Row(children: [
              Icon(Icons.tips_and_updates_outlined, color: Theme.of(context).colorScheme.primary, size: 26),
              SizedBox(width: 10),
              Expanded(child: Text('WHAT COULD MAKE THIS PLACE FEEL SAFER AND MORE ENGAGING?', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w900, height: 1.3))),
            ]),
            const SizedBox(height: 10),
            Text('Select all that apply, or leave blank.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
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
                      child: AnimatedResearchChoice(
                        label: responses[i],
                        emoji: _cardEmojis[i],
                        delay: i * 0.11,
                        selected: state.designResponses.contains(responses[i]),
                        onTap: () => state.toggleDesignResponse(responses[i]),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 36),
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 24),
            Row(children: [
              Icon(Icons.edit_note_outlined, color: Theme.of(context).colorScheme.primary, size: 26),
              SizedBox(width: 10),
              Text('OTHER SUGGESTION', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 10),
            Text('Optional — tell us something we may have missed.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
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
                fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
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

