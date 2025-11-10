import 'dart:math' as math;
import 'package:qibla_finder/core/constants/app_constants.dart';

class QiblaCalculator {
  /// Calculate the Qibla direction from a given location
  /// Returns the angle in degrees from North (0-360)
  static double calculateQiblaDirection({
    required double userLatitude,
    required double userLongitude,
  }) {
    // Convert to radians
    final double lat1 = _toRadians(userLatitude);
    final double lon1 = _toRadians(userLongitude);
    final double lat2 = _toRadians(AppConstants.kaabaLatitude);
    final double lon2 = _toRadians(AppConstants.kaabaLongitude);

    // Calculate the difference in longitude
    final double dLon = lon2 - lon1;

    // Calculate qibla direction using the formula
    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    // Calculate bearing in radians
    double bearing = math.atan2(y, x);

    // Convert to degrees
    bearing = _toDegrees(bearing);

    // Normalize to 0-360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  /// Calculate distance to Kaaba in kilometers
  static double calculateDistanceToKaaba({
    required double userLatitude,
    required double userLongitude,
  }) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double lat1 = _toRadians(userLatitude);
    final double lon1 = _toRadians(userLongitude);
    final double lat2 = _toRadians(AppConstants.kaabaLatitude);
    final double lon2 = _toRadians(AppConstants.kaabaLongitude);

    final double dLat = lat2 - lat1;
    final double dLon = lon2 - lon1;

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Check if the user is facing Qibla (within tolerance)
  static bool isFacingQibla({
    required double qiblaDirection,
    required double currentHeading,
    double tolerance = 5.0, // 5 degrees tolerance
  }) {
    final double difference = (qiblaDirection - currentHeading).abs();
    return difference <= tolerance || difference >= (360 - tolerance);
  }

  /// Normalize angle to 0-360 range
  static double normalizeAngle(double angle) {
    return (angle % 360 + 360) % 360;
  }

  /// Get the relative angle between current heading and qibla direction
  static double getRelativeAngle({
    required double qiblaDirection,
    required double currentHeading,
  }) {
    double angle = qiblaDirection - currentHeading;

    // Normalize to -180 to 180 range
    if (angle > 180) {
      angle -= 360;
    } else if (angle < -180) {
      angle += 360;
    }

    return angle;
  }

  static double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  static double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }
}
