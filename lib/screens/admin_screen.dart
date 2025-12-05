import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:kazsaq_datahub/services/data_import_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isImporting = false;
  String? _importMessage;
  bool _importSuccess = false;

  Future<void> _importUniversities() async {
    setState(() {
      _isImporting = true;
      _importMessage = null;
      _importSuccess = false;
    });

    try {
      final importService = DataImportService();
      await importService.addUniversities();
      
      setState(() {
        _isImporting = false;
        _importMessage = 'Успешно! Все 20 университетов обновлены в базе данных.';
        _importSuccess = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Данные успешно обновлены!'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _importMessage = 'Ошибка: $e';
        _importSuccess = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка импорта: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Админ панель',
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.analytics,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Статистика',
                          style: AppTextStyles.h2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('universities')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Ошибка: ${snapshot.error}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final count = snapshot.data?.docs.length ?? 0;
                        final universities = snapshot.data?.docs ?? [];

                        // Подсчет городов
                        final cities = <String>{};
                        for (var doc in universities) {
                          final city = doc.data() as Map<String, dynamic>;
                          if (city['city'] != null) {
                            cities.add(city['city'] as String);
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatCard(
                              icon: Icons.school,
                              label: 'Университетов в базе',
                              value: count.toString(),
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              icon: Icons.location_city,
                              label: 'Городов',
                              value: cities.length.toString(),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.divider,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Все университеты уже добавлены в базу данных',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.cloud_upload,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Импорт данных',
                                style: AppTextStyles.h2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Обновить все 20 университетов в базе данных',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_importMessage != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _importSuccess
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _importSuccess
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _importSuccess ? Icons.check_circle : Icons.error_outline,
                              color: _importSuccess ? AppColors.primary : AppColors.error,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _importMessage!,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: _importSuccess ? AppColors.primary : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isImporting ? null : _importUniversities,
                        icon: _isImporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.cloud_upload),
                        label: Text(
                          _isImporting ? 'Импорт...' : 'Обновить данные университетов',
                          style: AppTextStyles.button,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.divider,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Что будет обновлено:',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem('• 20 университетов с полными данными'),
                          _buildInfoItem('• Координаты для Google Maps 3D'),
                          _buildInfoItem('• Типы ВУЗов (технический, медицинский и т.д.)'),
                          _buildInfoItem('• Категории программ обучения'),
                          _buildInfoItem('• Расширенный список программ'),
                        ],
                      ),
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

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

