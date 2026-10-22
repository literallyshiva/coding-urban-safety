import 'package:flutter/material.dart';
import '../services/app_preferences.dart';

class ResearchScaffold extends StatelessWidget {
  const ResearchScaffold({
    super.key,
    required this.child,
    this.bottomButton,
    this.appBarTitle = 'CODING URBAN SAFETY',
    this.showFieldNote = true,
    this.illustration,
    this.sectionLabel,
  });

  final Widget child;
  final Widget? bottomButton;
  final String appBarTitle;
  final bool showFieldNote;
  final String? illustration;
  final String? sectionLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final illustrated = illustration != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(appBarTitle, style: const TextStyle(
          fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: .8)),
        actions: const [AppSettingsButton()],
      ),
      body: SafeArea(child: Column(children: [
        Expanded(child: SingleChildScrollView(
          child: Column(children: [
            if (illustrated)
              _IllustratedBanner(asset: illustration!, section: sectionLabel),
            Padding(
              padding: EdgeInsets.fromLTRB(16, illustrated ? 0 : 24, 16, 32),
              child: Center(child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: illustrated
                  ? Transform.translate(
                      offset: const Offset(0, -26),
                      child: _EditorialPaper(child: child),
                    )
                  : child,
              )),
            ),
          ]),
        )),
        if (bottomButton != null)
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.outlineVariant)),
              boxShadow: [BoxShadow(
                color: colors.shadow.withValues(alpha: .08),
                blurRadius: 18, offset: const Offset(0, -5))],
            ),
            child: SafeArea(top: false, child: bottomButton!),
          ),
      ])),
    );
  }
}

class _IllustratedBanner extends StatelessWidget {
  const _IllustratedBanner({required this.asset, this.section});
  final String asset;
  final String? section;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final height = screenWidth < 600 ? 310.0 : 360.0;
    return Semantics(
      label: 'Illustrated urban public space',
      image: true,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.center),
          DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, colors.surface.withValues(alpha: .06),
              colors.surface.withValues(alpha: .82)],
            stops: const [0, .68, 1],
          ))),
          if (section != null)
            Positioned(left: 20, top: 20, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: colors.surface.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(30)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.location_on_outlined, color: colors.primary, size: 17),
                const SizedBox(width: 6),
                Text(section!, style: TextStyle(fontSize: 11, letterSpacing: 1,
                  fontWeight: FontWeight.w900, color: colors.onSurface)),
              ]),
            )),
        ]),
      ),
    );
  }
}

class _EditorialPaper extends StatelessWidget {
  const _EditorialPaper({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 27),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .65)),
        boxShadow: [BoxShadow(color: colors.shadow.withValues(alpha: .1),
          blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: child,
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
            borderRadius: BorderRadius.circular(19),
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
