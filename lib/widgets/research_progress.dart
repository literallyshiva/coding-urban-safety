import 'package:flutter/material.dart';

/// Visual navigation context, not a change to the research flow.
class ResearchProgress extends StatelessWidget {
  const ResearchProgress({super.key, required this.stage});
  final int stage;
  static const names = ['Safety', 'Experience', 'Spatial', 'Qualities', 'Design'];
  static const emojis = ['🛡️', '🚶', '🏙️', '✨', '💡'];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Study section ${stage + 1} of ${names.length}: ${names[stage]}',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.auto_awesome, size: 17, color: c.primary),
          const SizedBox(width: 7),
          Expanded(child: Text('YOUR RESEARCH JOURNEY',
            style: TextStyle(color: c.onSurface, fontSize: 11,
              fontWeight: FontWeight.w800, letterSpacing: 1.2))),
          Text('${stage + 1}/${names.length}',
            style: TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
        ]),
        const SizedBox(height: 10),
        Row(children: [for (var i = 0; i < names.length; i++)
          Expanded(child: Padding(
            padding: EdgeInsets.only(right: i == names.length - 1 ? 0 : 5),
            child: Tooltip(message: names[i], child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: 8,
              decoration: BoxDecoration(
                color: i <= stage ? c.primary : c.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(9)),
            )),
          )),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Text('${emojis[stage]}  ${names[stage]}  •  ${(stage + 1) * 20}% of sections',
            style: TextStyle(fontSize: 12, color: c.onSurfaceVariant))),
          Tooltip(message: 'Draft answers are automatically saved on this device.',
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.save_outlined, size: 13, color: c.primary),
              const SizedBox(width: 4),
              Text('Auto-save on', style: TextStyle(fontSize: 10, color: c.onSurfaceVariant)),
            ])),
        ]),
      ]),
    );
  }
}
