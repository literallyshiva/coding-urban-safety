import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Gently looping, accessible animated emoji with no external dependencies.
class AnimatedResearchEmoji extends StatefulWidget {
  const AnimatedResearchEmoji({
    super.key, required this.emoji, this.size = 32,
    this.active = true, this.delay = 0,
  });

  final String emoji;
  final double size;
  final bool active;
  final double delay;

  @override
  State<AnimatedResearchEmoji> createState() => _AnimatedResearchEmojiState();
}

class _AnimatedResearchEmojiState extends State<AnimatedResearchEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (reduceMotion || !widget.active) return child!;
        final t = (_controller.value + widget.delay) * 2 * math.pi;
        return Transform.translate(
          offset: Offset(0, -3.5 * math.sin(t)),
          child: Transform.rotate(
            angle: 0.055 * math.sin(t + 0.7),
            child: Transform.scale(
              scale: 1 + 0.045 * math.sin(t + 1.2),
              child: child,
            ),
          ),
        );
      },
      child: Text(widget.emoji, textAlign: TextAlign.center,
        style: TextStyle(fontSize: widget.size, height: 1.25)),
    );
  }
}
