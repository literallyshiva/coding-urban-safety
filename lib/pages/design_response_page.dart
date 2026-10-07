import 'package:flutter/material.dart';

import '../services/assessment_repository.dart';
import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'map_page.dart';

class DesignResponsePage extends StatefulWidget {
  const DesignResponsePage({super.key, required this.assessmentState});

  final AssessmentState assessmentState;

  @override
  State<DesignResponsePage> createState() => _DesignResponsePageState();
}

class _DesignResponsePageState extends State<DesignResponsePage> {
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

  late final TextEditingController _otherController;
  final AssessmentRepository _repository = AssessmentRepository();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _otherController = TextEditingController(
      text: widget.assessmentState.otherSuggestion,
    );
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    widget.assessmentState.setOtherSuggestion(_otherController.text);

    setState(() => _submitting = true);
    try {
      await _repository.submit(widget.assessmentState);
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Assessment submitted successfully.'),
          content: const Text(
            'Your place assessment has been saved as a new research record.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('ASSESS ANOTHER PLACE'),
            ),
          ],
        ),
      );

      widget.assessmentState.reset();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MapPage(assessmentState: widget.assessmentState),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit assessment: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.assessmentState;
    return ResearchScaffold(
      bottomButton: PrimaryActionButton(
        label: 'SUBMIT ASSESSMENT',
        loading: _submitting,
        onPressed: _submit,
      ),
      child: AnimatedBuilder(
        animation: state,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WHAT COULD MAKE THIS PLACE FEEL SAFER AND MORE ENGAGING?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 28),
            ChipWrap(
              options: responses,
              isSelected: state.designResponses.contains,
              onSelected: state.toggleDesignResponse,
            ),
            const SizedBox(height: 38),
            const SectionQuestion('OTHER SUGGESTION'),
            TextField(
              controller: _otherController,
              minLines: 4,
              maxLines: 7,
              textCapitalization: TextCapitalization.sentences,
              onChanged: state.setOtherSuggestion,
              decoration: const InputDecoration(
                hintText: 'Describe what you would change in this place...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
