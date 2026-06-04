import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Grey circular placeholder used for achievement thumbnails until real
/// imagery is wired in. Accepts an optional [child] (e.g. a future
/// `Image.network`) so callers don't need to rebuild the shape later.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.diameter,
    this.child,
    this.color = AppColors.placeholder,
  });

  final double diameter;
  final Widget? child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = diameter.w;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
