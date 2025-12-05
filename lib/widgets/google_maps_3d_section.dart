import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class GoogleMaps3DSection extends StatelessWidget {
  final University university;

  const GoogleMaps3DSection({super.key, required this.university});

  String _buildGoogleMapsUrl() {
    if (university.latitude != null && university.longitude != null) {
      return 'https://www.google.com/maps/@${university.latitude},${university.longitude},18z?hl=ru';
    } else if (university.googleMapsPlaceId != null) {
      return 'https://www.google.com/maps/place/?q=place_id:${university.googleMapsPlaceId}';
    } else {
      final encodedLocation = Uri.encodeComponent(university.location);
      return 'https://www.google.com/maps/search/?api=1&query=$encodedLocation&hl=ru';
    }
  }


  Future<void> _openInGoogleMaps(BuildContext context) async {
    try {
      final url = Uri.parse(_buildGoogleMapsUrl());
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Не удалось открыть Google Maps'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (university.latitude == null && 
        university.longitude == null && 
        university.googleMapsPlaceId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: AnimatedCard(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Карта недоступна',
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Для этого университета нет данных о местоположении',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedCard(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: kIsWeb 
                        ? MediaQuery.of(context).size.height * 0.75
                        : MediaQuery.of(context).size.height * 0.7,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.map,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '3D вид кампуса',
                            style: AppTextStyles.h2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          tooltip: 'Открыть в Google Maps',
                          onPressed: () => _openInGoogleMaps(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.defaultBorderRadius,
                            ),
                          ),
                          child: _buildMapViewWithErrorHandling(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapViewWithErrorHandling() {
    if (kIsWeb) {
      return _buildWebMapViewWithFallback();
    } else {
      return _buildMobileMapView();
    }
  }

  Widget _buildWebMapViewWithFallback() {
    return _buildFallbackView();
  }

  Widget _buildFallbackView() {
    return Builder(
      builder: (context) => Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.map_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '3D вид кампуса',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Для просмотра 3D вида кампуса откройте карту в Google Maps',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _openInGoogleMaps(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Открыть в Google Maps'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _openInGoogleMaps(context),
              icon: const Icon(Icons.info_outline),
              label: const Text('Узнать больше о местоположении'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMapView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(_buildGoogleMapsUrl()));

    return WebViewWidget(controller: controller);
  }
}

