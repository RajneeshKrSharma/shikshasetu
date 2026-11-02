import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiksha_setu/core/theme/brand_colors.dart';

void main() {
  test('null means the black and white default', () {
    expect(BrandColors.fromValues(null, null), BrandColors.monochrome);
  });

  test('a seed becomes the primary color', () {
    final b = BrandColors.fromValues(0xFF1F4E79, null);
    expect(b.primary, const Color(0xFF1F4E79));
  });

  test('text on a dark color is white, on a light color is dark', () {
    expect(
      BrandColors.fromSeed(const Color(0xFF111111)).onPrimary,
      Colors.white,
    );
    expect(
      BrandColors.fromSeed(const Color(0xFFFFEB3B)).onPrimary,
      isNot(Colors.white),
    );
  });

  test('the accent follows the main color unless one is given', () {
    expect(
      BrandColors.fromValues(0xFF1F4E79, null).accent,
      const Color(0xFF1F4E79),
    );
    expect(
      BrandColors.fromValues(0xFF1F4E79, 0xFFD35400).accent,
      const Color(0xFFD35400),
    );
  });
}
