import 'package:flutter/material.dart';
import '../services/app_preferences.dart';

class ResearchScaffold extends StatelessWidget {
  const ResearchScaffold({
    super.key,
    required this.child,
    this.bottomButton,
    this.appBarTitle = 'CODING URBAN SAFETY',
    this.showFieldNote = true,
  });

  final Widget child;
  final Widget? bottomButton;
  final String appBarTitle;
  final bool showFieldNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), actions: const [AppSettingsButton()]),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: showFieldNote ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 44, height: 2,
                          color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 20),
                        child,
                      ],
                    ) : child,
                  ),
                ),
              ),
            ),
            if (bottomButton != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
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
            borderRadius: BorderRadius.circular(8),
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

class AppSettingsButton extends StatelessWidget {
  const AppSettingsButton({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppPreferences.instance,
    builder: (context, _) => PopupMenuButton<String>(
      tooltip: 'Theme and language / തീമും ഭാഷയും',
      icon: const Icon(Icons.settings_outlined),
      onSelected: (value) {
        if (value.startsWith('theme:')) {
          AppPreferences.instance.setSelectedTheme(value.substring(6));
        } else if (value == 'en' || value == 'ml') {
          AppPreferences.instance.setLanguage(value);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(enabled: false, child: Text('LIGHT THEMES')),
        PopupMenuItem(value: 'theme:beige', child: Text('🏖 Beige & ivory (default)')),
        PopupMenuItem(value: 'theme:sage', child: Text('🌿 Sage & cream')),
        PopupMenuItem(value: 'theme:ocean', child: Text('🌊 Ocean & sky')),
        PopupMenuItem(value: 'theme:sunset', child: Text('🌅 Sunset & sand')),
        PopupMenuItem(value: 'theme:lavender', child: Text('💜 Lavender & pearl')),
        PopupMenuItem(value: 'theme:forest', child: Text('🌲 Forest & mint')),
        PopupMenuDivider(),
        PopupMenuItem(enabled: false, child: Text('DARK THEMES')),
        PopupMenuItem(value: 'theme:dark-beige', child: Text('🌙 Dark beige & bronze')),
        PopupMenuItem(value: 'theme:dark-sage', child: Text('🌙 Dark sage')),
        PopupMenuItem(value: 'theme:dark-ocean', child: Text('🌙 Dark ocean')),
        PopupMenuItem(value: 'theme:dark-sunset', child: Text('🌙 Dark sunset')),
        PopupMenuItem(value: 'theme:dark-lavender', child: Text('🌙 Dark lavender')),
        PopupMenuItem(value: 'theme:dark-forest', child: Text('🌙 Dark forest')),
        PopupMenuDivider(),
        PopupMenuItem(value: 'en', child: Text('English')),
        PopupMenuItem(value: 'ml', child: Text('മലയാളം')),
      ],
    ),
  );
}
