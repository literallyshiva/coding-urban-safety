
import 'package:flutter/material.dart';
import 'animated_research_emoji.dart';

/// Colourful, accessible, theme-aware selection card.
/// Animation is visual only; the parent owns the original assessment values.
class AnimatedResearchChoice extends StatelessWidget {
  const AnimatedResearchChoice({
    super.key,
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
    this.minHeight = 116,
    this.delay = 0,
  });

  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  final double minHeight;
  final double delay;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: selected
                ? [c.primaryContainer, c.tertiaryContainer.withValues(alpha: .75)]
                : [c.surfaceContainerLow, c.secondaryContainer.withValues(alpha: .55)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? c.primary : c.outlineVariant,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected ? [
              BoxShadow(
                color: c.primary.withValues(alpha: .12),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ] : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                AnimatedResearchEmoji(emoji: emoji, size: 30, delay: delay),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: c.primary, size: 23),
              ]),
              const SizedBox(height: 16),
              Text(label, style: TextStyle(
                color: selected ? c.onPrimaryContainer : c.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.35,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

/// All five rating options use identical backgrounds; no choice is
/// visually promoted until the participant selects it.
class AnimatedResearchRating extends StatelessWidget {
  const AnimatedResearchRating({
    super.key,
    required this.rating,
    required this.selected,
    required this.onTap,
  });

  final int rating;
  final bool selected;
  final VoidCallback onTap;

  static const faces = ['😟', '🙁', '😐', '🙂', '😄'];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Semantics(
          button: true,
          selected: selected,
          label: 'Rating $rating out of 5',
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              constraints: const BoxConstraints(minHeight: 116),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selected
                    ? [c.primaryContainer, c.tertiaryContainer]
                    : [c.surfaceContainerLow, c.secondaryContainer.withValues(alpha: .45)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? c.primary : c.outlineVariant,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                AnimatedResearchEmoji(
                  emoji: faces[rating - 1],
                  size: 28,
                  delay: rating * .15,
                ),
                const SizedBox(height: 8),
                Text('$rating', style: TextStyle(
                  color: selected ? c.onPrimaryContainer : c.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
