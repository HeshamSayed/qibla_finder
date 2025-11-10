import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/core/constants/arabic_strings.dart';
import 'package:qibla_finder/data/services/admob_service.dart';
import 'package:qibla_finder/presentation/providers/theme_provider.dart';
import 'package:qibla_finder/presentation/screens/privacy_policy_screen.dart';
import 'package:qibla_finder/presentation/screens/help_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final AdMobService _adMobService = AdMobService();
  bool _isAdFree = false;
  Duration? _adFreeTimeRemaining;

  @override
  void initState() {
    super.initState();
    _checkAdFreeStatus();
    _loadRewardedAd();
  }

  Future<void> _checkAdFreeStatus() async {
    final isAdFree = await _adMobService.isAdFree();
    final timeRemaining = await _adMobService.getRemainingAdFreeTime();

    setState(() {
      _isAdFree = isAdFree;
      _adFreeTimeRemaining = timeRemaining;
    });
  }

  Future<void> _loadRewardedAd() async {
    await _adMobService.loadRewardedAd(
      onAdLoaded: () {},
      onAdFailedToLoad: (error) {},
    );
  }

  void _showRewardedAd() {
    _adMobService.showRewardedAd(
      onUserEarnedReward: (ad, reward) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إزالة الإعلانات لمدة 24 ساعة!'),
            backgroundColor: Colors.green,
          ),
        );
        _checkAdFreeStatus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.settings),
      ),
      body: ListView(
        children: [
          // Theme Section
          const ListTile(
            title: Text(
              ArabicStrings.theme,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          RadioListTile<ThemeMode>(
            title: const Text(ArabicStrings.lightTheme),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeProvider.notifier).setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text(ArabicStrings.darkTheme),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeProvider.notifier).setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text(ArabicStrings.systemTheme),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeProvider.notifier).setThemeMode(value);
              }
            },
          ),

          const Divider(),

          // Ad-Free Section
          if (_isAdFree)
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('الوضع بدون إعلانات'),
              subtitle: Text(
                _adFreeTimeRemaining != null
                    ? 'متبقي ${_adFreeTimeRemaining!.inHours} ساعة'
                    : '',
              ),
            )
          else
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: const Text(ArabicStrings.removeAds),
              subtitle: const Text(ArabicStrings.watchAd),
              onTap: _showRewardedAd,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),

          const Divider(),

          // Help & Info
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text(ArabicStrings.help),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text(ArabicStrings.privacyPolicy),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(ArabicStrings.about),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: ArabicStrings.appName,
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.explore, size: 48),
                children: [
                  const Text(ArabicStrings.aboutContent),
                ],
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          const Divider(),

          // Share
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text(ArabicStrings.share),
            onTap: () {
              // Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(ArabicStrings.shareMessage),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          const SizedBox(height: 24),

          // Version Info
          Center(
            child: Text(
              'الإصدار 1.0.0',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _adMobService.dispose();
    super.dispose();
  }
}
