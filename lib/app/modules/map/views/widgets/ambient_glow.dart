import 'package:flutter/material.dart';

class AmbientBackdrop extends StatelessWidget {
  const AmbientBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: AmbientGlow(
              size: 240,
              colors: [
                const Color(0x5579A15A),
                const Color(0x2279A15A),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            top: 160,
            right: -60,
            child: AmbientGlow(
              size: 220,
              colors: [
                const Color(0x3374A85E),
                const Color(0x1274A85E),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: -20,
            child: AmbientGlow(
              size: 200,
              colors: [
                const Color(0x2E6E9151),
                const Color(0x126E9151),
                Colors.transparent,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AmbientGlow extends StatelessWidget {
  const AmbientGlow({super.key, required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}
