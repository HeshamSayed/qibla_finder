class QiblaData {
  final double direction; // Direction in degrees (0-360)
  final double distance; // Distance to Kaaba in kilometers
  final double currentHeading; // Current compass heading
  final bool isFacingQibla; // Whether user is currently facing Qibla

  QiblaData({
    required this.direction,
    required this.distance,
    required this.currentHeading,
    required this.isFacingQibla,
  });

  QiblaData copyWith({
    double? direction,
    double? distance,
    double? currentHeading,
    bool? isFacingQibla,
  }) {
    return QiblaData(
      direction: direction ?? this.direction,
      distance: distance ?? this.distance,
      currentHeading: currentHeading ?? this.currentHeading,
      isFacingQibla: isFacingQibla ?? this.isFacingQibla,
    );
  }

  /// Get the relative angle to rotate the compass
  double get relativeAngle => direction - currentHeading;
}
