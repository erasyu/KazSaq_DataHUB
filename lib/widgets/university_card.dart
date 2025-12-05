import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/services/asset_image_service.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onTap;

  const UniversityCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLogo(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              university.nameRu,
                              style: AppTextStyles.h4,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  university.city,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            _buildUniversityTypeChip(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  RatingBarIndicator(
                    rating: university.rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: AppColors.primary,
                    ),
                    itemCount: 5,
                    itemSize: 16,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    university.descriptionRu.isNotEmpty
                        ? university.descriptionRu
                        : university.description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.people,
                        label: '${university.studentCount}',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.calendar_today,
                        label: university.foundedDate.year.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    // Сначала проверяем локальные assets
    final assetImage = AssetImageService.getUniversityCoverImage(university.id);
    
    // Если нет локального изображения, пробуем использовать coverImageUrl
    String? imageUrl = university.coverImageUrl.isNotEmpty 
        ? university.coverImageUrl 
        : null;
    
    // Если нет изображения обложки, пробуем использовать первое изображение из списка
    if (imageUrl == null && university.images.isNotEmpty) {
      imageUrl = university.images.first;
    }
    
    // Если все еще нет изображения, используем логотип
    if (imageUrl == null && university.logoUrl.isNotEmpty) {
      imageUrl = university.logoUrl;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppConstants.defaultBorderRadius),
        topRight: Radius.circular(AppConstants.defaultBorderRadius),
      ),
      child: assetImage != null
          ? Image.asset(
              assetImage,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
            )
          : (imageUrl != null && imageUrl.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 180,
          color: AppColors.surfaceDark,
          child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
                  errorWidget: (context, url, error) => _buildPlaceholderImage(),
                )
              : _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
          height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.surfaceDark,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            university.nameRu,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
          ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
        ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: university.logoUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.school,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityTypeChip() {
    String typeLabel = _getUniversityTypeLabel(university.universityType);
    IconData typeIcon = _getUniversityTypeIcon(university.universityType);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(typeIcon, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            typeLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _getUniversityTypeLabel(String type) {
    switch (type) {
      case 'technical':
        return 'Технический';
      case 'medical':
        return 'Медицинский';
      case 'pedagogical':
        return 'Педагогический';
      case 'economic':
        return 'Экономический';
      case 'humanitarian':
        return 'Гуманитарный';
      case 'agricultural':
        return 'Аграрный';
      case 'arts':
        return 'Искусств';
      case 'military':
        return 'Военный';
      case 'comprehensive':
        return 'Комплексный';
      default:
        return 'Университет';
    }
  }

  IconData _getUniversityTypeIcon(String type) {
    switch (type) {
      case 'technical':
        return Icons.engineering;
      case 'medical':
        return Icons.medical_services;
      case 'pedagogical':
        return Icons.school;
      case 'economic':
        return Icons.account_balance;
      case 'humanitarian':
        return Icons.menu_book;
      case 'agricultural':
        return Icons.agriculture;
      case 'arts':
        return Icons.palette;
      case 'military':
        return Icons.security;
      case 'comprehensive':
        return Icons.business;
      default:
        return Icons.school;
    }
  }
}

