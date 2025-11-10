import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/data/services/compass_service.dart';

final compassServiceProvider = Provider<CompassService>((ref) {
  return CompassService();
});

final compassStreamProvider = StreamProvider<double>((ref) {
  final compassService = ref.watch(compassServiceProvider);
  return compassService.getCompassStream();
});
