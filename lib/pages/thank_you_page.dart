
import 'package:flutter/material.dart';

import '../state/assessment_state.dart';
import '../widgets/research_scaffold.dart';
import 'map_page.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({
    super.key,
    required this.assessmentState,
  });

  final AssessmentState assessmentState;

  void _assessAnotherPlace(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MapPage(
          assessmentState: assessmentState,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF183153);
    const teal = Color(0xFF087F8C);
    const coral = Color(0xFFF27B67);

    return ResearchScaffold(
      appBarTitle: 'THANK YOU',
      bottomButton: PrimaryActionButton(
        label: 'ASSESS ANOTHER PLACE',
        onPressed: () => _assessAnotherPlace(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25),

          // Colorful illustration
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F2),
              borderRadius: BorderRadius.circular(110),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 28,
                  left: 32,
                  child: Icon(
                    Icons.auto_awesome,
                    color: coral,
                    size: 28,
                  ),
                ),
                const Positioned(
                  top: 43,
                  right: 29,
                  child: Icon(
                    Icons.favorite,
                    color: coral,
                    size: 24,
                  ),
                ),
                const Positioned(
                  bottom: 34,
                  left: 35,
                  child: Icon(
                    Icons.park,
                    color: teal,
                    size: 35,
                  ),
                ),
                const Positioned(
                  bottom: 35,
                  right: 35,
                  child: Icon(
                    Icons.location_on,
                    color: coral,
                    size: 34,
                  ),
                ),
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: teal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 75,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'THANK YOU!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: navy,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Your perspective matters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: teal,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Your assessment has been submitted '
            'successfully. Thank you for helping us '
            'understand how people experience '
            'urban spaces.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: navy,
              fontSize: 16,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2ED),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFD8C9),
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: coral,
                  size: 32,
                ),
                SizedBox(height: 10),
                Text(
                  'Small observations. Bigger insights.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Every response contributes to '
                  'research on safer, more engaging '
                  'public spaces.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Have another place in mind?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
