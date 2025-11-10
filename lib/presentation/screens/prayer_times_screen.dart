import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qibla_finder/core/constants/arabic_strings.dart';
import 'package:qibla_finder/presentation/providers/prayer_times_provider.dart';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prayerTimesAsync = ref.watch(prayerTimesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.prayerTimes),
      ),
      body: prayerTimesAsync.when(
        data: (prayerTimes) {
          final nextPrayer = prayerTimes.getNextPrayer();
          final allTimes = prayerTimes.getAllPrayerTimes();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Next Prayer Card
                  Card(
                    elevation: 4,
                    color: theme.colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'الصلاة القادمة',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            nextPrayer['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            prayerTimes.getFormattedTime(
                                nextPrayer['time'] as DateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Date
                  Text(
                    DateFormat('EEEE، d MMMM yyyy', 'ar')
                        .format(prayerTimes.date),
                    style: theme.textTheme.titleMedium,
                  ),

                  const SizedBox(height: 16),

                  // All Prayer Times
                  ...allTimes.entries.map((entry) {
                    final isNext = entry.key == nextPrayer['name'];

                    return Card(
                      elevation: isNext ? 2 : 1,
                      color: isNext
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : null,
                      child: ListTile(
                        leading: Icon(
                          _getPrayerIcon(entry.key),
                          color: isNext
                              ? theme.colorScheme.primary
                              : theme.iconTheme.color,
                        ),
                        title: Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: isNext ? FontWeight.bold : null,
                            color: isNext ? theme.colorScheme.primary : null,
                          ),
                        ),
                        trailing: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: isNext ? FontWeight.bold : null,
                            color: isNext ? theme.colorScheme.primary : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                ArabicStrings.error,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return Icons.wb_twilight;
      case 'الشروق':
        return Icons.wb_sunny;
      case 'الظهر':
        return Icons.wb_sunny_outlined;
      case 'العصر':
        return Icons.brightness_5;
      case 'المغرب':
        return Icons.brightness_4;
      case 'العشاء':
        return Icons.brightness_2;
      default:
        return Icons.access_time;
    }
  }
}
