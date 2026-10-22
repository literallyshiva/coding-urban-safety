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
    this.immersiveSafety = false,
  });

  final Widget child;
  final Widget? bottomButton;
  final String appBarTitle;
  final bool showFieldNote;
  final String? illustration;
  final String? sectionLabel;
  final bool immersiveSafety;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasArt = illustration != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(appBarTitle, style: const TextStyle(
          fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: .8)),
        actions: const [AppSettingsButton()],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, bounds) {
          final desktop = hasArt && bounds.maxWidth >= 1000;
          if (immersiveSafety && hasArt) {
            return _ImmersiveSafetyLayout(
              illustration: illustration!,
              child: child,
              bottomButton: bottomButton,
            );
          }
          if (!hasArt) {
            return Column(children: [
              Expanded(child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                child: Center(child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: child,
                )),
              )),
              if (bottomButton != null) _BottomAction(child: bottomButton!),
            ]);
          }
          if (desktop) {
            return Row(children: [
              Expanded(flex: 46, child: _IllustratedScene(
                asset: illustration!, section: sectionLabel,
                showLabel: true,
              )),
              Expanded(flex: 54, child: Column(children: [
                Expanded(child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(40, 34, 40, 40),
                  child: Center(child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: _ResearchPanel(child: child),
                  )),
                )),
                if (bottomButton != null) _BottomAction(
                  child: Center(child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: bottomButton!,
                  )),
                ),
              ])),
            ]);
          }
          // Mobile: full-bleed illustrated scene behind the actual form.
          // The picture remains visible above and around the questionnaire,
          // rather than being cropped into a fixed-height horizontal banner.
          return Stack(children: [
            Positioned.fill(child: _IllustratedScene(
              asset: illustration!, section: sectionLabel, showLabel: false,
            )),
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  colors.surface.withValues(alpha: .10),
                  colors.surface.withValues(alpha: .52),
                ],
                stops: const [0, .35, 1],
              ),
            ))),
            Column(children: [
              Expanded(child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: bounds.maxHeight < 650 ? 130 : 195),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 28),
                    child: _ResearchPanel(child: child),
                  ),
                ]),
              )),
              if (bottomButton != null) _BottomAction(child: bottomButton!),
            ]),
            if (sectionLabel != null)
              Positioned(top: 14, left: 14, child: _SceneLabel(sectionLabel!)),
          ]);
        }),
      ),
    );
  }
}


/// Artwork is a real full-bleed background, not a banner or a split pane.
/// The form has its own scroll area; the action bar stays accessible.
class _ImmersiveSafetyLayout extends StatelessWidget {
  const _ImmersiveSafetyLayout({required this.illustration,
    required this.child, this.bottomButton});
  final String illustration;
  final Widget child;
  final Widget? bottomButton;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, size) {
    final desktop = size.maxWidth >= 900;
    final colors = Theme.of(context).colorScheme;
    return Stack(children: [
      Positioned.fill(child: Image.asset(
        illustration.endsWith('safety_street_desktop.webp') && !desktop
          ? 'assets/images/illustrated/safety_street_mobile.webp'
          : illustration,
        fit: BoxFit.cover,
        alignment: desktop ? Alignment.centerLeft : Alignment.topCenter,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      )),
      Positioned.fill(child: ColoredBox(color: Colors.black.withValues(alpha: .06))),
      if (desktop)
        Align(alignment: Alignment.centerRight, child: FractionallySizedBox(
          widthFactor: size.maxWidth > 1450 ? .45 : .53,
          heightFactor: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 30, 24),
            child: _SafetySurface(child: child, bottomButton: bottomButton),
          ),
        ))
      else
        Column(children: [
          SizedBox(height: size.maxHeight < 680 ? 150 : 210,
            child: Align(alignment: Alignment.topLeft, child: Padding(
              padding: const EdgeInsets.all(18),
              child: DecoratedBox(
                decoration: BoxDecoration(color: colors.surface.withValues(alpha: .92),
                  borderRadius: BorderRadius.circular(30)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                  child: Text('01 / 05   •   SAFETY', style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
                ),
              ),
            )),
          ),
          Expanded(child: _SafetySurface(child: child, bottomButton: bottomButton)),
        ]),
    ]);
  });
}

class _SafetySurface extends StatelessWidget {
  const _SafetySurface({required this.child, this.bottomButton});
  final Widget child;
  final Widget? bottomButton;
  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF007D78);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x330B2C35),
          blurRadius: 35, offset: Offset(0, 12))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 16),
          child: Theme(data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: teal, surface: const Color(0xFFFFFCF7),
              onSurface: const Color(0xFF0E3041),
              onSurfaceVariant: const Color(0xFF54646B),
              outlineVariant: const Color(0xFFE2E8E5),
              primaryContainer: const Color(0xFFDEF4ED),
              onPrimaryContainer: const Color(0xFF07544F),
            )), child: child),
        )),
        if (bottomButton != null) Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
          decoration: const BoxDecoration(color: Color(0xFFFFFCF7),
            border: Border(top: BorderSide(color: Color(0xFFE2E8E5)))),
          child: Theme(data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: teal)),
            child: bottomButton!),
        ),
      ]),
    );
  }
}

class _IllustratedScene extends StatelessWidget {
  const _IllustratedScene({
    required this.asset, this.section, required this.showLabel,
  });
  final String asset;
  final String? section;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Illustration of an urban public space',
      image: true,
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(asset, fit: BoxFit.cover, alignment: Alignment.center),
        if (showLabel && section != null)
          Positioned(top: 24, left: 24, child: _SceneLabel(section!)),
      ]),
    );
  }
}

class _SceneLabel extends StatelessWidget {
  const _SceneLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.place_outlined, size: 15,
            color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
        ]),
      ),
    );
  }
}

class _ResearchPanel extends StatelessWidget {
  const _ResearchPanel({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .97),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .6)),
        boxShadow: [BoxShadow(
          color: colors.shadow.withValues(alpha: .12),
          blurRadius: 28, offset: const Offset(0, 10),
        )],
      ),
      child: child,
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .97),
        border: Border(top: BorderSide(color: colors.outlineVariant)),
        boxShadow: [BoxShadow(
          color: colors.shadow.withValues(alpha: .09),
          blurRadius: 16, offset: const Offset(0, -4),
        )],
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
