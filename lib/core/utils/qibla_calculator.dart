import 'dart:math' as math;
import 'package:qibla_finder/core/constants/app_constants.dart';

class QiblaCalculator {
  /// Calculate the Qibla direction from a given location
  /// Returns the angle in degrees from True North (0-360)
  ///
  /// This uses the Great Circle bearing formula for maximum accuracy:
  /// bearing = atan2(sin(Δλ) * cos(φ2), cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ))
  ///
  /// Where:
  /// - φ1, λ1 = User's latitude and longitude
  /// - φ2, λ2 = Kaaba's latitude (21.4225°N) and longitude (39.8262°E)
  /// - Δλ = Difference in longitude
  static double calculateQiblaDirection({
    required double userLatitude,
    required double userLongitude,
  }) {
    // Validate inputs
    if (userLatitude < -90 || userLatitude > 90) {
      throw ArgumentError('Invalid latitude: $userLatitude. Must be between -90 and 90.');
    }
    if (userLongitude < -180 || userLongitude > 180) {
      throw ArgumentError('Invalid longitude: $userLongitude. Must be between -180 and 180.');
    }

    // Convert to radians for trigonometric calculations
    final double lat1 = _toRadians(userLatitude);
    final double lon1 = _toRadians(userLongitude);
    final double lat2 = _toRadians(AppConstants.kaabaLatitude);
    final double lon2 = _toRadians(AppConstants.kaabaLongitude);

    // Calculate the difference in longitude
    final double dLon = lon2 - lon1;

    // Calculate qibla direction using the Great Circle bearing formula
    // This is the most accurate method for calculating bearing on a sphere
    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    // Calculate bearing in radians using atan2 for correct quadrant
    double bearing = math.atan2(y, x);

    // Convert from radians to degrees
    bearing = _toDegrees(bearing);

    // Normalize to 0-360 range (compass bearing)
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
