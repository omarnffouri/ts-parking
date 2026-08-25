import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class AccentCard extends StatelessWidget {
  final Color accentColor;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const AccentCard({
    super.key,
    required this.accentColor,
    required this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.only(bottom: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(padding: const EdgeInsets.only(left: 4), child: child),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: ColoredBox(color: accentColor),
          ),
        ],
      ),
    );
  }
}
