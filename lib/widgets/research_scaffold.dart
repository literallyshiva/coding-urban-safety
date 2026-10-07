import 'package:flutter/material.dart';

class ResearchScaffold extends StatelessWidget {
  const ResearchScaffold({
    super.key,
    required this.child,
    this.bottomButton,
    this.appBarTitle = 'CODING URBAN SAFETY',
  });

  final Widget child;
  final Widget? bottomButton;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: child,
                  ),
                ),
              ),
            ),
            if (bottomButton != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE9E7EF)),
                  ),
                ),
                child: SafeArea(top: false, child: bottomButton!),
              ),
          ],
        ),
      ),
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              )
            : Text(label),
      ),
    );
  }
}

class SectionQuestion extends StatelessWidget {
  const SectionQuestion(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 17,
              height: 1.3,
              letterSpacing: 0.3,
            ),
      ),
    );
  }
}

class ChipWrap extends StatelessWidget {
  const ChipWrap({
    super.key,
    required this.options,
    required this.isSelected,
    required this.onSelected,
  });

  final List<String> options;
  final bool Function(String option) isSelected;
  final void Function(String option) onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 10,
      children: options
          .map(
            (option) => ChoiceChip(
              label: Text(option),
              selected: isSelected(option),
              onSelected: (_) => onSelected(option),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            ),
          )
          .toList(),
    );
  }
}
