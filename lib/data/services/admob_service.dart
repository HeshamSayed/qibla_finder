import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qibla_finder/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdMobService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  /// Initialize AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Load banner ad
  Future<void> loadBannerAd({
    required Function(BannerAd) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) async {
    if (await _isAdFree()) return;

    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? AppConstants.androidBannerId
          : AppConstants.iosBannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdLoaded = false;
          ad.dispose();
          onAdFailedToLoad(ad, error);
        },
      ),
    );

    await _bannerAd!.load();
  }

  /// Load interstitial ad
  Future<void> loadInterstitialAd({
    required Function() onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (await _isAdFree()) return;

    await InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? AppConstants.androidInterstitialId
          : AppConstants.iosInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;

          // Set muted video ads
          _interstitialAd!.setImmersiveMode(true);

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdLoaded = false;
              // Preload next ad
              loadInterstitialAd(
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad,
              );
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialAdLoaded = false;
            },
          );

          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdLoaded = false;
          onAdFailedToLoad(error);
        },
      ),
    );
  }

  /// Load rewarded ad
  Future<void> loadRewardedAd({
    required Function() onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    await RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? AppConstants.androidRewardedId
          : AppConstants.iosRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdLoaded = false;
              // Preload next ad
              loadRewardedAd(
                onAdLoaded: onAdLoaded,
                onAdFailedToLoad: onAdFailedToLoad,
              );
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedAdLoaded = false;
            },
          );

          onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdLoaded = false;
          onAdFailedToLoad(error);
        },
      ),
    );
  }

  /// Show interstitial ad (with frequency control)
  Future<bool> showInterstitialAd() async {
    if (await _isAdFree()) return false;
    if (!await _shouldShowInterstitialAd()) return false;
    if (!_isInterstitialAdLoaded || _interstitialAd == null) return false;

    await _interstitialAd!.show();
    await _incrementUsageCount();
    await _updateLastAdShownTime();
    return true;
  }

  /// Show rewarded ad
  Future<void> showRewardedAd({
    required Function(RewardedAd, RewardItem) onUserEarnedReward,
  }) async {
    if (!_isRewardedAdLoaded || _rewardedAd == null) return;

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) async {
        await _grantAdFreeReward();
        onUserEarnedReward(ad, reward);
      },
    );
  }

  /// Check if should show interstitial ad based on frequency
  Future<bool> _shouldShowInterstitialAd() async {
    final prefs = await SharedPreferences.getInstance();
    final usageCount = prefs.getInt(AppConstants.keyAppUsageCount) ?? 0;
    return usageCount % AppConstants.interstitialAdFrequency == 0;
  }

  /// Increment app usage count
  Future<void> _incrementUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(AppConstants.keyAppUsageCount) ?? 0;
    await prefs.setInt(AppConstants.keyAppUsageCount, currentCount + 1);
  }

  /// Update last ad shown time
  Future<void> _updateLastAdShownTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppConstants.keyLastAdShownTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Grant ad-free reward for 24 hours
  Future<void> _grantAdFreeReward() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeUntil = DateTime.now()
        .add(const Duration(hours: AppConstants.adFreeRewardDurationHours))
        .millisecondsSinceEpoch;
    await prefs.setInt(AppConstants.keyAdFreeUntil, adFreeUntil);
  }

  /// Check if user has ad-free status
  Future<bool> _isAdFree() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeUntil = prefs.getInt(AppConstants.keyAdFreeUntil);

    if (adFreeUntil == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    return now < adFreeUntil;
  }

  /// Check if user is currently ad-free
  Future<bool> isAdFree() async {
    return await _isAdFree();
  }

  /// Get remaining ad-free time
  Future<Duration?> getRemainingAdFreeTime() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeUntil = prefs.getInt(AppConstants.keyAdFreeUntil);

    if (adFreeUntil == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (now >= adFreeUntil) return null;

    return Duration(milliseconds: adFreeUntil - now);
  }

  /// Dispose ads
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  // Getters
  BannerAd? get bannerAd => _bannerAd;
  bool get isBannerAdLoaded => _isBannerAdLoaded;
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;
  bool get isRewardedAdLoaded => _isRewardedAdLoaded;
}
