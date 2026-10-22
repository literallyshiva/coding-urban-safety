import 'package:flutter/material.dart';

/// Compact, accessible V2 journey header. Stage indices stay 0..4.
class ResearchProgress extends StatelessWidget {
  const ResearchProgress({super.key, required this.stage});
  final int stage;
  static const names = ['Safety', 'Experience', 'Spatial', 'Qualities', 'Design'];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final current = stage.clamp(0, names.length - 1);
    final progress = (current + 1) / names.length;
    return Semantics(
      label: 'Study section ${current + 1} of ${names.length}: ${names[current]}',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.primaryContainer.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.outlineVariant),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.explore_outlined, color: c.onPrimaryContainer),
            const SizedBox(width: 8),
            Expanded(child: Text('YOUR FIELD JOURNEY', style: TextStyle(
              color: c.onPrimaryContainer, fontSize: 12,
              fontWeight: FontWeight.w800, letterSpacing: 1.1))),
            Text('${(progress * 100).round()}%', style: TextStyle(
              color: c.onPrimaryContainer, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 14),
          ClipRRect(borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: progress, minHeight: 9,
              backgroundColor: c.surface,
              valueColor: AlwaysStoppedAnimation<Color>(c.primary))),
          const SizedBox(height: 12),
          Text('Section ${current + 1} of ${names.length}  •  ${names[current]}',
            style: TextStyle(color: c.onPrimaryContainer,
              fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}
