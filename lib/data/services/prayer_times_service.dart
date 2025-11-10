import 'package:adhan/adhan.dart';
import 'package:qibla_finder/data/models/prayer_time_data.dart';

class PrayerTimesService {
  /// Calculate prayer times for given coordinates
  PrayerTimeData calculatePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);

    return PrayerTimeData(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      date: date ?? DateTime.now(),
    );
  }

  /// Get prayer times for a specific date
  PrayerTimeData getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final dateComponents = DateComponents(date.year, date.month, date.day);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    return PrayerTimeData(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      date: date,
    );
  }

  /// Get current prayer name
  String getCurrentPrayer({
    required double latitude,
    required double longitude,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);
    final currentPrayer = prayerTimes.currentPrayer();

    switch (currentPrayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return '';
    }
  }

  /// Get next prayer name and time
  Map<String, dynamic> getNextPrayer({
    required double latitude,
    required double longitude,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.umm_al_qura.getParameters();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes.today(coordinates, params);
    final nextPrayer = prayerTimes.nextPrayer();

    String prayerName = '';
    DateTime? prayerTime;

    switch (nextPrayer) {
      case Prayer.fajr:
        prayerName = 'الفجر';
        prayerTime = prayerTimes.fajr;
        break;
      case Prayer.sunrise:
        prayerName = 'الشروق';
        prayerTime = prayerTimes.sunrise;
        break;
      case Prayer.dhuhr:
        prayerName = 'الظهر';
        prayerTime = prayerTimes.dhuhr;
        break;
      case Prayer.asr:
        prayerName = 'العصر';
        prayerTime = prayerTimes.asr;
        break;
      case Prayer.maghrib:
        prayerName = 'المغرب';
        prayerTime = prayerTimes.maghrib;
        break;
      case Prayer.isha:
        prayerName = 'العشاء';
        prayerTime = prayerTimes.isha;
        break;
      default:
        prayerName = '';
        prayerTime = null;
    }

    return {
      'name': prayerName,
      'time': prayerTime,
    };
  }
}
