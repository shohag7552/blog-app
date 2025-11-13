import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Widget? prefixIcon;
  final String hintText;
  final Function(String)? onSubmitted;
  const CustomTextField({super.key, required this.searchController, this.prefixIcon, required this.hintText, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass.withOwnLayer(
      settings: LiquidGlassSettings(
        ambientStrength: 2,
        lightAngle: 0.4 * math.pi,
        glassColor: Colors.black12,
        thickness: 30,
        blur: 4,
      ),
      shape: LiquidRoundedSuperellipse(
        borderRadius: 40,
      ),
      glassContainsChild: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: TextField(
          controller: searchController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white60,
              fontSize: 15,
            ),
            prefixIcon: prefixIcon,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
