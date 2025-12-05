import 'package:flutter/material.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class InternationalSection extends StatelessWidget {
  final University university;

  const InternationalSection({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (university.internationalCooperation.descriptionRu.isNotEmpty ||
              university.internationalCooperation.description.isNotEmpty) ...[
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  university.internationalCooperation.descriptionRu.isNotEmpty
                      ? university.internationalCooperation.descriptionRu
                      : university.internationalCooperation.description,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (university.internationalCooperation.exchangePrograms.isNotEmpty) ...[
            Text(
              'Программы обмена',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            ...university.internationalCooperation.exchangePrograms
                .asMap()
                .entries
                .map((entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: AppConstants.animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _ExchangeProgramCard(
                            program: entry.value,
                          ),
                        ),
                      ),
                    )),
            const SizedBox(height: 24),
          ],
          if (university.internationalCooperation.partnerUniversities.isNotEmpty) ...[
            Text(
              'Партнерские университеты',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            AnimationLimiter(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount:
                    university.internationalCooperation.partnerUniversities.length,
                itemBuilder: (context, index) {
                  final partner = university
                      .internationalCooperation.partnerUniversities[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: AppConstants.animationDuration,
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: _PartnerUniversityCard(partner: partner),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (university.internationalCooperation.opportunities.isNotEmpty) ...[
            Text(
              'Возможности для иностранных студентов',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            ...university.internationalCooperation.opportunities
                .asMap()
                .entries
                .map((entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: AppConstants.animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _OpportunityCard(opportunity: entry.value),
                        ),
                      ),
                    )),
          ],
        ],
      ),
    );
  }
}

class _ExchangeProgramCard extends StatelessWidget {
  final ExchangeProgram program;

  const _ExchangeProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flight,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
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
                        program.country,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              program.descriptionRu.isNotEmpty
                  ? program.descriptionRu
                  : program.description,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  icon: Icons.access_time,
                  label: program.duration,
                ),
              ],
            ),
            if (program.requirementsRu.isNotEmpty ||
                program.requirements.isNotEmpty) ...[
              const SizedBox(height: 8),
              ExpandablePanel(
                header: Text(
                  'Требования',
                  style: AppTextStyles.bodyMedium,
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Text(
                  program.requirementsRu.isNotEmpty
                      ? program.requirementsRu
                      : program.requirements,
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
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
}

class _PartnerUniversityCard extends StatelessWidget {
  final PartnerUniversity partner;

  const _PartnerUniversityCard({required this.partner});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: () async {
        if (partner.website.isNotEmpty) {
          final url = Uri.parse(partner.website);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (partner.logoUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: partner.logoUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.school,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              partner.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              partner.country,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;

  const _OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.stars,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opportunity.titleRu.isNotEmpty
                        ? opportunity.titleRu
                        : opportunity.title,
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opportunity.descriptionRu.isNotEmpty
                        ? opportunity.descriptionRu
                        : opportunity.description,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

