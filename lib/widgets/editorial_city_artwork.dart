import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original vector artwork drawn locally by Flutter.
/// No external assets, fonts, API calls, or new packages.
class EditorialCityArtwork extends StatelessWidget {
  const EditorialCityArtwork({super.key, this.safety = false});
  final bool safety;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: safety
          ? 'Illustrated city crossing with a pedestrian, traffic light and street lamps'
          : 'Illustrated city neighborhood with colorful buildings, trees, paths and people',
      child: AspectRatio(
        aspectRatio: safety ? 2.1 : 1.65,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: CustomPaint(
            painter: _EditorialCityPainter(safety: safety),
            child: Stack(children: [
              Positioned(
                top: 14, left: 14,
                child: _Sticker(
                  text: safety ? 'LOOK • NOTICE • REFLECT' : 'A CITY FULL OF STORIES',
                  icon: safety ? Icons.visibility_rounded : Icons.location_city_rounded,
                ),
              ),
              Positioned(
                right: 14, bottom: 14,
                child: _Sticker(
                  text: safety ? 'YOUR VIEW MATTERS' : 'EXPLORE YOUR CITY',
                  icon: Icons.arrow_outward_rounded,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Sticker extends StatelessWidget {
  const _Sticker({required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9E9),
      border: Border.all(color: const Color(0xFF26314B), width: 1.4),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [BoxShadow(color: Color(0x4426314B), offset: Offset(3,3))],
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: const Color(0xFF26314B)),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(color: Color(0xFF26314B),
        fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: .5)),
    ]),
  );
}

class _EditorialCityPainter extends CustomPainter {
  const _EditorialCityPainter({required this.safety});
  final bool safety;
  static const navy = Color(0xFF26314B);
  static const cream = Color(0xFFFFEFD1);
  static const coral = Color(0xFFFF775F);
  static const teal = Color(0xFF48C4AD);
  static const yellow = Color(0xFFFFC84B);
  static const lilac = Color(0xFFAE9CF5);

  @override
  void paint(Canvas canvas, Size size) {
    final w=size.width, h=size.height;
    final s=math.min(w,h);
    void rect(double x,double y,double ww,double hh,Color color,{double r=0}) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x*w,y*h,ww*w,hh*h),
        Radius.circular(r*s)), Paint()..color=color);
    }
    void circ(double x,double y,double radius,Color color) {
      canvas.drawCircle(Offset(x*w,y*h),radius*s,Paint()..color=color);
    }
    void line(double x,double y,double xx,double yy,Color color,double stroke) {
      canvas.drawLine(Offset(x*w,y*h),Offset(xx*w,yy*h),
        Paint()..color=color..strokeWidth=stroke*s..strokeCap=StrokeCap.round);
    }
    rect(0,0,1,1,cream);
    circ(.82,.18,.15,yellow);
    circ(.12,.25,.10,lilac);
    // Hand-drawn street-grid motifs and dotted walking routes.
    for (var i=0;i<8;i++) {
      final x=.07+i*.12;
      circ(x,.12,.005,navy);
    }
    for (var i=0;i<7;i++) {
      final y=.22+i*.09;
      circ(.95,y,.004,navy);
    }
    // Skyline of deliberately varied, poster-like geometric blocks.
    rect(.06,.39,.18,.42,coral,r:.012);
    rect(.26,.27,.20,.54,teal,r:.013);
    rect(.49,.43,.17,.38,lilac,r:.013);
    rect(.68,.32,.21,.49,yellow,r:.013);
    for (final x in [.10,.17,.30,.38,.53,.60,.72,.81]) {
      for (final y in [.47,.58,.69]) {
        if ((x>.26 && x<.46 && y<.69) || y>=.47) {
          rect(x,y,.035,.055,navy,r:.006);
        }
      }
    }
    // Street, crossing, and winding route.
    rect(0,.81,1,.19,navy);
    rect(0,.81,1,.025,cream);
    for (var i=0;i<6;i++) {
      rect(.06+i*.16,.89,.095,.024,cream,r:.007);
    }
    // Trees and shrubs.
    for (final x in [.045,.47,.93]) {
      rect(x,.68,.014,.17,navy,r:.004);
      circ(x+.008,.65,.065,teal);
      circ(x-.027,.68,.04,yellow);
    }
    // Crossing sign / streetlight with strong recognizable silhouette.
    line(.59,.48,.59,.84,navy,.015);
    rect(.555,.46,.07,.17,navy,r:.018);
    circ(.59,.50,.015,coral);
    circ(.59,.55,.015,yellow);
    circ(.59,.60,.015,teal);
    // A friendly pedestrian made from vector primitives.
    circ(.39,.63,.033,navy);
    circ(.39,.63,.024,coral);
    line(.39,.68,.39,.79,navy,.023);
    line(.39,.70,.34,.75,navy,.015);
    line(.39,.70,.44,.75,navy,.015);
    line(.39,.79,.35,.87,navy,.017);
    line(.39,.79,.43,.87,navy,.017);
    if (safety) {
      // High-contrast editorial emphasis for safety scene.
      circ(.17,.20,.085,coral);
      line(.17,.15,.17,.22,navy,.014);
      circ(.17,.26,.009,navy);
    } else {
      // A little exploratory compass.
      circ(.16,.21,.055,teal);
      line(.16,.17,.16,.25,navy,.008);
      line(.12,.21,.20,.21,navy,.008);
    }
  }
  @override
  bool shouldRepaint(covariant _EditorialCityPainter old) => old.safety != safety;
}
