import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/gen/assets.gen.dart';

class TruckArrivalWidget extends StatelessWidget {
  const TruckArrivalWidget({required this.useTopView, super.key});

  final bool useTopView;

  @override
  Widget build(BuildContext context) {
    if (!useTopView) {
      return Assets.images.truck.image(fit: BoxFit.contain);
    }

    return Assets.images.horizontalViewTruck.image(
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
