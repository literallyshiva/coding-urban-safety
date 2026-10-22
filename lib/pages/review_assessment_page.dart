import 'package:flutter/material.dart';
import '../services/assessment_repository.dart';
import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'thank_you_page.dart';

class ReviewAssessmentPage extends StatefulWidget {
  const ReviewAssessmentPage({super.key, required this.assessmentState});
  final AssessmentState assessmentState;

  @override
  State<ReviewAssessmentPage> createState() => _ReviewAssessmentPageState();
}

class _ReviewAssessmentPageState extends State<ReviewAssessmentPage> {
  bool _submitting = false;

  Future<void> _confirm() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await AssessmentRepository().submit(widget.assessmentState);
      if (!mounted) return;
      widget.assessmentState.reset();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => ThankYouPage(
          assessmentState: widget.assessmentState)),
        (route) => route.isFirst,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Assessment was not saved: $error'),
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _line(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 13,
        fontWeight: FontWeight.w800, color: Color(0xFF647C77))),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(fontSize: 15)),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    final state = widget.assessmentState;
    String list(List<String> values) => values.isEmpty ? 'None selected' : values.join(', ');
    return ResearchScaffold(
      illustration: 'assets/images/illustrated/03_gender.png',
      sectionLabel: 'REVIEW YOUR ANSWERS',
      appBarTitle: 'REVIEW YOUR ANSWERS',
      bottomButton: PrimaryActionButton(
        label: 'CONFIRM & SUBMIT', loading: _submitting,
        onPressed: _submitting ? null : _confirm,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('ONE LAST LOOK', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        const Text('Review your answers before saving. Tap the back arrow to edit.'),
        const SizedBox(height: 22),
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            _line('Location', state.location == null ? 'Not selected'
                : '${state.location!.latitude.toStringAsFixed(5)}, '
                  '${state.location!.longitude.toStringAsFixed(5)}'),
            _line('Gender (optional)', state.gender ?? 'Not provided'),
            _line('Safety rating', state.safetyRating?.toString() ?? 'Not answered'),
            _line('Unsafe conditions', list(state.unsafeConditions)),
            _line('Experience', list(state.placeExperience)),
            _line('Spend more time?', state.spendMoreTime ?? 'Not answered'),
            _line('Spatial conditions', list(state.spatialConditions)),
            _line('Ludic qualities', list(state.ludicQualities)),
            _line('Ludic rating', state.ludicRating?.toString() ?? 'Not answered'),
            _line('Design responses', list(state.designResponses)),
            _line('Other suggestion', state.otherSuggestion.isEmpty
                ? 'None' : state.otherSuggestion),
          ],
        ))),
        const SizedBox(height: 20),
        OutlinedButton.icon(onPressed: _submitting ? null : () => Navigator.pop(context),
          icon: const Icon(Icons.edit_outlined), label: const Text('EDIT ANSWERS')),
        const SizedBox(height: 24),
      ]),
    );
  }
}
