import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  const GlassContainer({super.key, required this.child, this.padding, this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      // blur: 3,
      settings: LiquidGlassSettings(
        blur: 3,
        ambientStrength: 0.5,
        lightAngle: -0.2 * math.pi,
        glassColor: Colors.white12,
      ),
      // shape: LiquidRoundedSuperellipse(
      //   borderRadius: const Radius.circular(10),
      // ),
      // glassContainsChild: false,
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
