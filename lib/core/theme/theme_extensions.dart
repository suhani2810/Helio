import 'package:flutter/material.dart';

@immutable
class SkyTheme extends ThemeExtension<SkyTheme> {
  final Gradient? skyGradient;
  final Color? sunColor;
  final Color? moonColor;
  final Color? cloudColor;
  final Color? starColor;
  final Color? cardColor;
  final Color? accentColor;

  const SkyTheme({
    this.skyGradient,
    this.sunColor,
    this.moonColor,
    this.cloudColor,
    this.starColor,
    this.cardColor,
    this.accentColor,
  });

  @override
  SkyTheme copyWith({
    Gradient? skyGradient,
    Color? sunColor,
    Color? moonColor,
    Color? cloudColor,
    Color? starColor,
    Color? cardColor,
    Color? accentColor,
  }) {
    return SkyTheme(
      skyGradient: skyGradient ?? this.skyGradient,
      sunColor: sunColor ?? this.sunColor,
      moonColor: moonColor ?? this.moonColor,
      cloudColor: cloudColor ?? this.cloudColor,
      starColor: starColor ?? this.starColor,
      cardColor: cardColor ?? this.cardColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  SkyTheme lerp(ThemeExtension<SkyTheme>? other, double t) {
    if (other is! SkyTheme) return this;
    return SkyTheme(
      skyGradient: t < 0.5 ? skyGradient : other.skyGradient,
      sunColor: Color.lerp(sunColor, other.sunColor, t),
      moonColor: Color.lerp(moonColor, other.moonColor, t),
      cloudColor: Color.lerp(cloudColor, other.cloudColor, t),
      starColor: Color.lerp(starColor, other.starColor, t),
      cardColor: Color.lerp(cardColor, other.cardColor, t),
      accentColor: Color.lerp(accentColor, other.accentColor, t),
    );
  }
}
