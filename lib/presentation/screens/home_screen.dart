import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qibla_finder/core/constants/arabic_strings.dart';
import 'package:qibla_finder/data/services/admob_service.dart';
import 'package:qibla_finder/presentation/providers/location_provider.dart';
import 'package:qibla_finder/presentation/providers/qibla_provider.dart';
import 'package:qibla_finder/presentation/widgets/qibla_compass.dart';
import 'package:qibla_finder/presentation/screens/settings_screen.dart';
import 'package:qibla_finder/presentation/screens/prayer_times_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final AdMobService _adMobService = AdMobService();
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.location.status;

    if (!status.isGranted) {
      final result = await Permission.location.request();

      if (!result.isGranted && mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(ArabicStrings.locationPermissionTitle),
        content: const Text(ArabicStrings.locationPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(ArabicStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text(ArabicStrings.openSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _loadBannerAd() async {
    await _adMobService.loadBannerAd(
      onAdLoaded: (ad) {
        setState(() {
          _bannerAd = ad;
          _isAdLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        setState(() {
          _isAdLoaded = false;
        });
      },
    );
  }

  Future<void> _loadInterstitialAd() async {
    await _adMobService.loadInterstitialAd(
      onAdLoaded: () {},
      onAdFailedToLoad: (error) {},
    );
  }

  void _showCalibrationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(ArabicStrings.calibrationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(ArabicStrings.calibrationInstruction),
            SizedBox(height: 16),
            Text(ArabicStrings.calibrationStep1),
            SizedBox(height: 8),
            Text(ArabicStrings.calibrationStep2),
            SizedBox(height: 8),
            Text(ArabicStrings.calibrationStep3),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(ArabicStrings.understood),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _adMobService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final qiblaAsync = ref.watch(qiblaDataProvider);
    final locationAsync = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrayerTimesScreen(),
                ),
              );
            },
            tooltip: ArabicStrings.prayerTimes,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            tooltip: ArabicStrings.settings,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Location Info
                    locationAsync.when(
                      data: (location) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(Icons.location_on, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                ArabicStrings.yourLocation,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${location.city ?? ''} ${location.country ?? ''}',
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      loading: () => const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stack) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 48,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                error.toString().contains('GPS') ||
                                error.toString().contains('location')
                                    ? ArabicStrings.gpsDisabled
                                    : ArabicStrings.locationError,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                ArabicStrings.gpsDisabledMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final locationService = ref.read(locationServiceProvider);
                                  await locationService.openLocationSettings();
                                },
                                icon: const Icon(Icons.settings),
                                label: const Text(ArabicStrings.enableGps),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Qibla Compass
                    qiblaAsync.when(
                      data: (qiblaData) {
                        // Vibrate when facing Qibla
                        if (qiblaData.isFacingQibla) {
                          HapticFeedback.lightImpact();
                        }

                        return Column(
                          children: [
                            QiblaCompass(qiblaData: qiblaData),
                            const SizedBox(height: 16),
                            if (qiblaData.isFacingQibla)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Text(
                                  ArabicStrings.facingQibla,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.explore),
                                        const SizedBox(height: 8),
                                        const Text(
                                          ArabicStrings.degreeToQibla,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${qiblaData.direction.toStringAsFixed(1)}°',
                                          style: theme.textTheme.titleLarge,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(Icons.place),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'المسافة',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${qiblaData.distance.toStringAsFixed(0)} كم',
                                          style: theme.textTheme.titleLarge,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ArabicStrings.compassError,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Calibration Button
                    OutlinedButton.icon(
                      onPressed: _showCalibrationDialog,
                      icon: const Icon(Icons.cached),
                      label: const Text(ArabicStrings.calibrateCompass),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Banner Ad
          if (_isAdLoaded && _bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }
}
