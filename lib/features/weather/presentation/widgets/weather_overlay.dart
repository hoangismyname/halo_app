import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/weather_state.dart';
import '../weather_provider.dart';

/// A compact weather chip displayed on the map overlay.
///
/// Shows temperature + condition icon. Taps open a detailed bottom sheet.
class WeatherOverlay extends ConsumerWidget {
  const WeatherOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);

    return switch (weatherState) {
      WeatherInitial() => const SizedBox.shrink(),
      WeatherLoading() => const _LoadingChip(),
      WeatherLoaded(:final weather) => GestureDetector(
          onTap: () => _showWeatherSheet(context, ref),
          child: _WeatherChip(
            temperature: '${weather.temperature?.celsius?.round() ?? '--'}°',
            condition: weather.weatherDescription ?? '',
            iconCode: weather.weatherIcon ?? '01d',
          ),
        ),
      WeatherError(:final message) => _ErrorChip(
          message: message,
          onRetry: () => ref.read(weatherProvider.notifier).refresh(),
        ),
    };
  }

  void _showWeatherSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Consumer(
        builder: (ctx, r, _) => _WeatherDetailSheet(
          weatherState: r.watch(weatherProvider),
          onRefresh: () => r.read(weatherProvider.notifier).refresh(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────── compact chip ──

class _WeatherChip extends StatelessWidget {
  const _WeatherChip({
    required this.temperature,
    required this.condition,
    required this.iconCode,
  });

  final String temperature;
  final String condition;
  final String iconCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://openweathermap.org/img/wn/$iconCode.png',
            width: 28,
            height: 28,
            errorBuilder: (ctx, err, stack) =>
                const Icon(Icons.cloud, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 6),
          Text(
            temperature,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (condition.isNotEmpty) ...[
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 90),
              child: Text(
                _capitalize(condition),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ─────────────────────────────────────────────── loading chip ──

class _LoadingChip extends StatelessWidget {
  const _LoadingChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────── error chip ──

class _ErrorChip extends StatelessWidget {
  const _ErrorChip({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 16, color: AppColors.error),
            SizedBox(width: 6),
            Text(
              'Thử lại',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────── detail bottom sheet ──

class _WeatherDetailSheet extends StatelessWidget {
  const _WeatherDetailSheet({
    required this.weatherState,
    required this.onRefresh,
  });

  final WeatherState weatherState;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                const Text(
                  'Thời tiết hiện tại',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // Body
          _buildBody(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (weatherState) {
      WeatherInitial() || WeatherLoading() => const Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      WeatherLoaded(:final weather) => _WeatherDetails(weather: weather),
      WeatherError(:final message) => _WeatherErrorBody(message: message),
    };
  }
}

// ──────────────────────────────────────── weather detail rows ──

class _WeatherDetails extends StatelessWidget {
  const _WeatherDetails({required this.weather});

  final dynamic weather; // weather.Weather

  @override
  Widget build(BuildContext context) {
    final tempC = weather.temperature?.celsius?.round();
    final feelsLike = weather.tempFeelsLike?.celsius?.round();
    final humidity = weather.humidity?.round();
    final windSpeed = weather.windSpeed;
    final description = weather.weatherDescription ?? '';
    final icon = weather.weatherIcon ?? '01d';
    final city = weather.areaName ?? weather.country ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Main hero row
          Row(
            children: [
              Image.network(
                'https://openweathermap.org/img/wn/$icon@2x.png',
                width: 72,
                height: 72,
                errorBuilder: (ctx, err, stack) => const Icon(
                  Icons.wb_cloudy,
                  color: AppColors.primary,
                  size: 56,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$tempC°C',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      _capitalize(description),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (city.isNotEmpty)
                    Text(
                      city,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats grid
          Row(
            children: [
              _StatCard(
                icon: Icons.thermostat_outlined,
                label: 'Cảm giác',
                value: feelsLike != null ? '$feelsLike°C' : '--',
              ),
              const SizedBox(width: 10),
              _StatCard(
                icon: Icons.water_drop_outlined,
                label: 'Độ ẩm',
                value: humidity != null ? '$humidity%' : '--',
              ),
              const SizedBox(width: 10),
              _StatCard(
                icon: Icons.air_outlined,
                label: 'Gió',
                value: windSpeed != null
                    ? '${windSpeed.toStringAsFixed(1)} m/s'
                    : '--',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherErrorBody extends StatelessWidget {
  const _WeatherErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, color: AppColors.error, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
