import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/vehicle.dart';

/// Single-colour vehicle illustration, tinted with [color].
class VehicleIcon extends StatelessWidget {
  const VehicleIcon(this.vehicle, {super.key, this.width = 48, this.color});

  final Vehicle vehicle;
  final double width;
  final Color? color;

  String get _asset => 'assets/icons/vehicles/${vehicle.name}.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _asset,
      width: width,
      colorFilter: ColorFilter.mode(
        color ?? IconTheme.of(context).color ?? Colors.black,
        BlendMode.srcIn,
      ),
      semanticsLabel: vehicle.name,
    );
  }
}
