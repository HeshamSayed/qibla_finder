import 'package:flutter/material.dart';
import 'package:qibla_finder/core/constants/arabic_strings.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.helpTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.help_outline, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          ArabicStrings.helpTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildHelpStep(
                      context,
                      '1',
                      ArabicStrings.helpStep1,
                      Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpStep(
                      context,
                      '2',
                      ArabicStrings.helpStep2,
                      Icons.phone_android,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpStep(
                      context,
                      '3',
                      ArabicStrings.helpStep3,
                      Icons.cached,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpStep(
                      context,
                      '4',
                      ArabicStrings.helpStep4,
                      Icons.arrow_upward,
                    ),
                    const SizedBox(height: 16),
                    _buildHelpStep(
                      context,
                      '5',
                      ArabicStrings.helpStep5,
                      Icons.check_circle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'نصائح مهمة',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTip(
                      context,
                      'تأكد من أن البوصلة بعيدة عن الأجهزة الإلكترونية والمعادن',
                      Icons.warning_amber,
                    ),
                    const SizedBox(height: 12),
                    _buildTip(
                      context,
                      'في حالة عدم دقة البوصلة، قم بمعايرتها',
                      Icons.tune,
                    ),
                    const SizedBox(height: 12),
                    _buildTip(
                      context,
                      'يعمل التطبيق في وضع عدم الاتصال باستخدام آخر موقع معروف',
                      Icons.signal_wifi_off,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpStep(
    BuildContext context,
    String number,
    String text,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTip(BuildContext context, String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }
}
