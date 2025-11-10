class PrayerTimeData {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;

  PrayerTimeData({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  String getFormattedTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $period';
  }

  Map<String, String> getAllPrayerTimes() {
    return {
      'الفجر': getFormattedTime(fajr),
      'الشروق': getFormattedTime(sunrise),
      'الظهر': getFormattedTime(dhuhr),
      'العصر': getFormattedTime(asr),
      'المغرب': getFormattedTime(maghrib),
      'العشاء': getFormattedTime(isha),
    };
  }

  /// Get next prayer name and time
  Map<String, dynamic> getNextPrayer() {
    final now = DateTime.now();
    final prayers = [
      {'name': 'الفجر', 'time': fajr},
      {'name': 'الشروق', 'time': sunrise},
      {'name': 'الظهر', 'time': dhuhr},
      {'name': 'العصر', 'time': asr},
      {'name': 'المغرب', 'time': maghrib},
      {'name': 'العشاء', 'time': isha},
    ];

    for (var prayer in prayers) {
      if ((prayer['time'] as DateTime).isAfter(now)) {
        return prayer;
      }
    }

    // If all prayers have passed, return Fajr of tomorrow
    return {'name': 'الفجر', 'time': fajr.add(const Duration(days: 1))};
  }
}
