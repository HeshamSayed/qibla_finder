import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/core/utils/qibla_calculator.dart';
import 'package:qibla_finder/data/models/qibla_data.dart';
import 'package:qibla_finder/presentation/providers/compass_provider.dart';
import 'package:qibla_finder/presentation/providers/location_provider.dart';

final qiblaDataProvider = StreamProvider<QiblaData>((ref) async* {
  final locationAsync = ref.watch(currentLocationProvider);
  final compassAsync = ref.watch(compassStreamProvider);

  await for (final heading in compassAsync.stream) {
    final location = await locationAsync.whenData((data) => data).value;

    if (location != null) {
      final qiblaDirection = QiblaCalculator.calculateQiblaDirection(
        userLatitude: location.latitude,
        userLongitude: location.longitude,
      );

      final distance = QiblaCalculator.calculateDistanceToKaaba(
        userLatitude: location.latitude,
        userLongitude: location.longitude,
      );

      final isFacing = QiblaCalculator.isFacingQibla(
        qiblaDirection: qiblaDirection,
        currentHeading: heading,
      );

      yield QiblaData(
        direction: qiblaDirection,
        distance: distance,
        currentHeading: heading,
        isFacingQibla: isFacing,
      );
    }
  }
});
