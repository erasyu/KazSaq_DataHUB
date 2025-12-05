import 'package:flutter/material.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:kazsaq_datahub/providers/comparison_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProgramsSection extends StatelessWidget {
  final University university;

  const ProgramsSection({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    if (university.academicPrograms.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book,
                size: 64,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 16),
              Text(
                'Программы не найдены',
                style: AppTextStyles.h3,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Академические программы',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: university.academicPrograms.length,
              itemBuilder: (context, index) {
                final program = university.academicPrograms[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: AppConstants.animationDuration,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _ProgramCard(
                        program: program,
                        universityId: university.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final AcademicProgram program;
  final String universityId;

  const _ProgramCard({
    required this.program,
    required this.universityId,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: program.currency,
      decimalDigits: 0,
    );

    return AnimatedCard(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (program.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.defaultBorderRadius),
                  topRight: Radius.circular(AppConstants.defaultBorderRadius),
                ),
                child: CachedNetworkImage(
                  imageUrl: program.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: AppColors.surfaceDark,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: AppColors.surfaceDark,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.nameRu.isNotEmpty
                                  ? program.nameRu
                                  : program.name,
                              style: AppTextStyles.h4,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              program.degreeRu.isNotEmpty
                                  ? program.degreeRu
                                  : program.degree,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildCategoryChip(),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.compare_arrows),
                        color: AppColors.primary,
                        onPressed: () {
                          context
                              .read<ComparisonProvider>()
                              .addProgram(universityId, program.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Программа добавлена в сравнение'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    program.descriptionRu.isNotEmpty
                        ? program.descriptionRu
                        : program.description,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.school,
                        label: program.facultyRu.isNotEmpty
                            ? program.facultyRu
                            : program.faculty,
                      ),
                      _buildInfoChip(
                        icon: Icons.access_time,
                        label: '${program.duration} лет',
                      ),
                      _buildInfoChip(
                        icon: Icons.language,
                        label: program.languageRu.isNotEmpty
                            ? program.languageRu
                            : program.language,
                      ),
                      _buildInfoChip(
                        icon: Icons.attach_money,
                        label: currencyFormat.format(program.tuitionFee),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ExpandablePanel(
                    header: Text(
                      'Требования',
                      style: AppTextStyles.h4,
                    ),
                    collapsed: const SizedBox.shrink(),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (program.requirementsRu.isNotEmpty
                              ? program.requirementsRu
                              : program.requirements)
                          .map((req) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        req,
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  if (program.careerOpportunities.isNotEmpty ||
                      program.careerOpportunitiesRu.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ExpandablePanel(
                      header: Text(
                        'Карьерные возможности',
                        style: AppTextStyles.h4,
                      ),
                      collapsed: const SizedBox.shrink(),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (program.careerOpportunitiesRu.isNotEmpty
                                ? program.careerOpportunitiesRu
                                : program.careerOpportunities)
                            .map((opp) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.work,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          opp,
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
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

  Widget _buildCategoryChip() {
    String categoryLabel = _getCategoryLabel(program.programCategory);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        categoryLabel,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'engineering':
        return 'Инженерия';
      case 'medicine':
        return 'Медицина';
      case 'business':
        return 'Бизнес';
      case 'law':
        return 'Право';
      case 'education':
        return 'Образование';
      case 'arts':
        return 'Искусство';
      case 'science':
        return 'Наука';
      case 'agriculture':
        return 'Сельское хозяйство';
      case 'humanitarian':
        return 'Гуманитарные';
      default:
        return 'Общее';
    }
  }
}

