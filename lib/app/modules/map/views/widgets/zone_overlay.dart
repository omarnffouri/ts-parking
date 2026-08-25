import 'package:flutter/material.dart';

class ZoneOverlay extends StatelessWidget {
  const ZoneOverlay({super.key, required this.isFocused});

  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isFocused ? 1 : 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0x225BC46C),
              const Color(0x085BC46C),
              Colors.transparent,
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x55D9F1CB), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x185BC46C),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
