class AppConstants {
  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  // AdMob IDs (Replace with your actual IDs)
  static const String androidBannerId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID
  static const String androidRewardedId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String iosRewardedId = 'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // App Settings
  static const int interstitialAdFrequency = 5; // Show ad every 5 uses
  static const int adFreeRewardDurationHours = 24;

  // Shared Preferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyAppUsageCount = 'app_usage_count';
  static const String keyLastAdShownTime = 'last_ad_shown_time';
  static const String keyAdFreeUntil = 'ad_free_until';
  static const String keyLastKnownLat = 'last_known_lat';
  static const String keyLastKnownLon = 'last_known_lon';
}
