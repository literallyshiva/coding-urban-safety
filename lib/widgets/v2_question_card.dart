import 'package:flutter/material.dart';

/// Presentation-only V2 question container. It never changes assessment data.
class V2QuestionCard extends StatelessWidget {
  const V2QuestionCard({super.key, required this.number, required this.title,
    required this.child, this.description, this.icon = Icons.edit_note_rounded,
    this.optional = false});

  final String number;
  final String title;
  final String? description;
  final Widget child;
  final IconData icon;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.outlineVariant),
        boxShadow: [BoxShadow(color: c.shadow.withValues(alpha: .045),
          blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(backgroundColor: c.primaryContainer,
            foregroundColor: c.onPrimaryContainer, child: Icon(icon)),
          const SizedBox(width: 10),
          Text('QUESTION $number', style: theme.textTheme.labelMedium?.copyWith(
            color: c.primary, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          const Spacer(),
          if (optional) Text('OPTIONAL', style: theme.textTheme.labelSmall?.copyWith(
            color: c.onSurfaceVariant)),
        ]),
        const SizedBox(height: 16),
        Text(title, style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800, height: 1.18)),
        if (description != null) ...[
          const SizedBox(height: 10),
          Text(description!, style: theme.textTheme.bodyMedium?.copyWith(
            color: c.onSurfaceVariant, height: 1.5)),
        ],
        const SizedBox(height: 24),
        child,
      ]),
    );
  }
}
