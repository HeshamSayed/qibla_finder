import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/data/models/location_data.dart';
import 'package:qibla_finder/data/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final currentLocationProvider = FutureProvider<LocationData>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.getCurrentLocation();
});

final locationStreamProvider = StreamProvider<LocationData>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.getLocationStream();
});
