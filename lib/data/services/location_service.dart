import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:qibla_finder/data/models/location_data.dart';

/// Exception thrown when location services are disabled
class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException(this.message);

  @override
  String toString() => message;
}

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location
  /// IMPORTANT: Always requires GPS to be enabled for accurate Qibla direction
  /// Does NOT use cached location to prevent incorrect Qibla direction
  Future<LocationData> getCurrentLocation() async {
    // Check if location services are enabled
    final isEnabled = await isLocationServiceEnabled();
    if (!isEnabled) {
      throw LocationServiceDisabledException(
        'يجب تفعيل GPS للحصول على اتجاه دقيق للقبلة. الموقع المحفوظ قد يكون غير دقيق.',
      );
    }

    // Get current position - NO fallback to cached location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 15),
    );

    // Get address information
    String? city;
    String? country;

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        city = placemark.locality ?? placemark.administrativeArea;
        country = placemark.country;
      }
    } catch (e) {
      // Geocoding failed, continue without address
    }

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      accuracy: position.accuracy,
      city: city,
      country: country,
      timestamp: DateTime.now(),
    );
  }


  /// Get location stream for continuous updates
  /// Requires GPS to be enabled for accurate real-time updates
  Stream<LocationData> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).asyncMap((position) async {
      String? city;
      String? country;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          city = placemark.locality ?? placemark.administrativeArea;
          country = placemark.country;
        }
      } catch (e) {
        // Continue without address
      }

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        city: city,
        country: country,
        timestamp: DateTime.now(),
      );
    });
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
