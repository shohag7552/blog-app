import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
class GlassTextFieldContainer extends StatelessWidget {
  final Widget child;
  const GlassTextFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      settings: LiquidGlassSettings(
        ambientStrength: 2,
        lightAngle: 0.4 * math.pi,
        glassColor: Colors.black12,
        thickness: 30,
        blur: 4,
      ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: const Radius.circular(40),
      ),
      glassContainsChild: false,
      child: child,
    );
  }
}
