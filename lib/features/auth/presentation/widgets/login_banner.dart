import '../../../../core/theme/app_colors.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/assets/app_images.dart';
import '../../../../core/theme/app_dimens.dart';

/// How big the login banner is on a given screen: as wide as asked, as tall as
/// its artwork needs, but never taller than [maxHeight]. When it would be
/// taller (a short or landscape screen) the bottom of the picture is cut off
/// and faded into the page.
class BannerFit {
  BannerFit({required this.width, required double maxHeight})
    : artHeight =
          width /
          AppImages.loginBackgroundAspect *
          AppImages.loginBackgroundArtHeight,
      height = math.min(
        width /
            AppImages.loginBackgroundAspect *
            AppImages.loginBackgroundArtHeight,
        math.max(maxHeight, 120),
      );

  final double width;

  /// Height of the whole artwork at this width.
  final double artHeight;

  /// Height actually shown.
  final double height;

  bool get cropped => height < artHeight;

  /// Where the form may start, measured from the top of the banner: inside
  /// the faded wave when the whole artwork is shown, right at the edge when
  /// it was cut and faded.
  double get contentTop => cropped ? height : height * 0.93;
}

/// The illustrated school banner. [rounded] makes it a card with rounded
/// corners, for screens wider than the picture.
class LoginBanner extends StatelessWidget {
  const LoginBanner({super.key, required this.fit, this.rounded = false});

  final BannerFit fit;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final fullHeight = fit.width / AppImages.loginBackgroundAspect;
    final picture = SizedBox(
      width: fit.width,
      height: fit.height,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            OverflowBox(
              alignment: Alignment.topCenter,
              minWidth: fit.width,
              maxWidth: fit.width,
              minHeight: fullHeight,
              maxHeight: fullHeight,
              child: Image.asset(
                AppImages.loginBackground,
                fit: BoxFit.fill,
                excludeFromSemantics: true,
              ),
            ),
            if (fit.cropped)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: math.max(56, fit.height * 0.2),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.background.withValues(alpha: 0),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return rounded
        ? ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sheet + 8),
            child: picture,
          )
        : picture;
  }
}
