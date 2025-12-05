import 'package:flutter/material.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdmissionSection extends StatelessWidget {
  final University university;

  const AdmissionSection({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (university.admission.descriptionRu.isNotEmpty ||
              university.admission.description.isNotEmpty) ...[
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  university.admission.descriptionRu.isNotEmpty
                      ? university.admission.descriptionRu
                      : university.admission.description,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (university.admission.requirements.isNotEmpty) ...[
            Text(
              'Требования к поступлению',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            ...university.admission.requirements
                .asMap()
                .entries
                .map((entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: AppConstants.animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _RequirementCard(requirement: entry.value),
                        ),
                      ),
                    )),
            const SizedBox(height: 24),
          ],
          if (university.admission.procedures.isNotEmpty) ...[
            Text(
              'Процедуры подачи заявлений',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            ...university.admission.procedures
                .asMap()
                .entries
                .map((entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: AppConstants.animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _ProcedureCard(procedure: entry.value),
                        ),
                      ),
                    )),
            const SizedBox(height: 24),
          ],
          if (university.admission.deadlines.isNotEmpty) ...[
            Text(
              'Сроки подачи заявлений',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            ...university.admission.deadlines
                .asMap()
                .entries
                .map((entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: AppConstants.animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _DeadlineCard(deadline: entry.value),
                        ),
                      ),
                    )),
            const SizedBox(height: 24),
          ],
          if (university.admission.scholarships.isNotEmpty) ...[
            Text(
              'Стипендии',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            ...university.admission.scholarships
                .asMap()
                .entries
                .map((entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: AppConstants.animationDuration,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _ScholarshipCard(scholarship: entry.value),
                        ),
                      ),
                    )),
            const SizedBox(height: 24),
          ],
          if (university.admission.financialAid.options.isNotEmpty ||
              university.admission.financialAid.optionsRu.isNotEmpty) ...[
            Text(
              'Финансовая помощь',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (university.admission.financialAid.descriptionRu.isNotEmpty ||
                        university.admission.financialAid.description.isNotEmpty)
                      Text(
                        university.admission.financialAid.descriptionRu.isNotEmpty
                            ? university.admission.financialAid.descriptionRu
                            : university.admission.financialAid.description,
                        style: AppTextStyles.bodyLarge,
                      ),
                    if (university.admission.financialAid.optionsRu.isNotEmpty ||
                        university.admission.financialAid.options.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...(university.admission.financialAid.optionsRu.isNotEmpty
                              ? university.admission.financialAid.optionsRu
                              : university.admission.financialAid.options)
                          .map((option) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequirementCard extends StatelessWidget {
  final Requirement requirement;

  const _RequirementCard({required this.requirement});

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
                    Icons.checklist,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    requirement.titleRu.isNotEmpty
                        ? requirement.titleRu
                        : requirement.title,
                    style: AppTextStyles.h4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              requirement.descriptionRu.isNotEmpty
                  ? requirement.descriptionRu
                  : requirement.description,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcedureCard extends StatelessWidget {
  final ApplicationProcedure procedure;

  const _ProcedureCard({required this.procedure});

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${procedure.step}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procedure.titleRu.isNotEmpty
                        ? procedure.titleRu
                        : procedure.title,
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    procedure.descriptionRu.isNotEmpty
                        ? procedure.descriptionRu
                        : procedure.description,
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

class _DeadlineCard extends StatelessWidget {
  final Deadline deadline;

  const _DeadlineCard({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'ru');
    final isPast = deadline.deadline.isBefore(DateTime.now());

    return AnimatedCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: isPast ? AppColors.error.withValues(alpha: 0.3) : AppColors.divider,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isPast ? Icons.event_busy : Icons.event,
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
                    deadline.programRu.isNotEmpty
                        ? deadline.programRu
                        : deadline.program,
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(deadline.deadline),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isPast ? AppColors.error : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
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

class _ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;

  const _ScholarshipCard({required this.scholarship});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: scholarship.currency,
      decimalDigits: 0,
    );

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
                    Icons.monetization_on,
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
                        scholarship.nameRu.isNotEmpty
                            ? scholarship.nameRu
                            : scholarship.name,
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(scholarship.amount),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              scholarship.descriptionRu.isNotEmpty
                  ? scholarship.descriptionRu
                  : scholarship.description,
              style: AppTextStyles.bodyMedium,
            ),
            if (scholarship.coverageRu.isNotEmpty ||
                scholarship.coverage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Покрытие: ${scholarship.coverageRu.isNotEmpty ? scholarship.coverageRu : scholarship.coverage}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (scholarship.requirementsRu.isNotEmpty ||
                scholarship.requirements.isNotEmpty) ...[
              const SizedBox(height: 12),
              ExpandablePanel(
                header: Text(
                  'Требования',
                  style: AppTextStyles.bodyMedium,
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...(scholarship.requirementsRu.isNotEmpty
                            ? scholarship.requirementsRu
                            : scholarship.requirements)
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
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

