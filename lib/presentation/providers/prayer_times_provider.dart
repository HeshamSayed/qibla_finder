import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/data/models/prayer_time_data.dart';
import 'package:qibla_finder/data/services/prayer_times_service.dart';
import 'package:qibla_finder/presentation/providers/location_provider.dart';

final prayerTimesServiceProvider = Provider<PrayerTimesService>((ref) {
  return PrayerTimesService();
});

final prayerTimesProvider = FutureProvider<PrayerTimeData>((ref) async {
  final locationAsync = ref.watch(currentLocationProvider);
  final location = await locationAsync.future;

  final prayerService = ref.watch(prayerTimesServiceProvider);

  return prayerService.calculatePrayerTimes(
    latitude: location.latitude,
    longitude: location.longitude,
  );
});
