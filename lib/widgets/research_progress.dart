import 'package:flutter/material.dart';

/// High-visibility questionnaire journey. This is a presentation-only widget;
/// the existing validation, answers and navigation remain unchanged.
class ResearchProgress extends StatelessWidget {
  const ResearchProgress({super.key, required this.stage});
  final int stage;
  static const names = ['Safety', 'Experience', 'Spatial', 'Qualities', 'Design'];
  static const icons = ['🛡️', '🚶', '🏙️', '✨', '💡'];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final current = stage.clamp(0, names.length - 1);
    return Semantics(
      label: 'Study section ${current + 1} of ${names.length}: ${names[current]}',
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            c.primaryContainer.withValues(alpha: .7),
            c.tertiaryContainer.withValues(alpha: .6),
          ]),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c.outlineVariant),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.route_rounded, color: c.onPrimaryContainer, size: 19),
            const SizedBox(width: 8),
            Expanded(child: Text('YOUR CITY EXPLORATION',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11,
                letterSpacing: 1, color: c.onPrimaryContainer))),
            Text('${(current + 1) * 20}%',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17,
                color: c.onPrimaryContainer)),
          ]),
          const SizedBox(height: 16),
          Row(children: [for (var i = 0; i < names.length; i++)
            Expanded(child: Tooltip(message: names[i], child: Column(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: i == current ? 48 : 37,
                height: i == current ? 48 : 37,
                decoration: BoxDecoration(
                  color: i == current ? c.primary :
                    i < current ? c.secondaryContainer : c.surface.withValues(alpha: .85),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: i == current ? c.primary : c.outlineVariant,
                    width: i == current ? 2 : 1),
                ),
                child: Center(child: Text(icons[i], style: TextStyle(
                  fontSize: i == current ? 24 : 18))),
              ),
              const SizedBox(height: 5),
              Text(names[i], maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 9, fontWeight: i == current
                  ? FontWeight.w800 : FontWeight.w500,
                  color: c.onPrimaryContainer)),
            ]))),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (current + 1) / names.length),
              duration: const Duration(milliseconds: 700),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value, minHeight: 9, backgroundColor: c.surface,
                valueColor: AlwaysStoppedAnimation<Color>(c.primary)),
            )),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.cloud_done_outlined, size: 16, color: c.onPrimaryContainer),
            const SizedBox(width: 6),
            Expanded(child: Text('Draft saved on this device',
              style: TextStyle(fontSize: 11, color: c.onPrimaryContainer))),
            Text('STEP ${current + 1} OF 5',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                color: c.onPrimaryContainer)),
          ]),
        ]),
      ),
    );
  }
}
