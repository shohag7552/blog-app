import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const GlassContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      // blur: 3,
      settings: LiquidGlassSettings(
        blur: 3,
        ambientStrength: 0.5,
        lightAngle: -0.2 * math.pi,
        glassColor: Colors.white12,
      ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: const Radius.circular(10),
      ),
      glassContainsChild: false,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
