import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';

class CompassService {
  Stream<double>? _compassStream;

  /// Get compass heading stream
  Stream<double> getCompassStream() {
    _compassStream ??= FlutterCompass.events!
        .map((event) => event.heading ?? 0.0)
        .distinct()
        .handleError((error) {
      // Handle compass errors
      return 0.0;
    });

    return _compassStream!;
  }

  /// Check if compass is available on device
  static Future<bool> isCompassAvailable() async {
    try {
      final compassEvents = FlutterCompass.events;
      return compassEvents != null;
    } catch (e) {
      return false;
    }
  }

  /// Normalize compass heading to 0-360 range
  static double normalizeHeading(double heading) {
    return (heading % 360 + 360) % 360;
  }
}
