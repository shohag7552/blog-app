import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
class GlassText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const GlassText({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Glassify(
      settings: const LiquidGlassSettings(
        thickness: 5,
        blur: 3,
        glassColor: Color(0x33FFFFFF),
      ),
      child: Text(text, style: style),
    );
  }
}
