import 'package:flutter/material.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AboutSection extends StatelessWidget {
  final University university;

  const AboutSection({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMissionSection(),
          const SizedBox(height: 24),
          _buildHistorySection(),
          const SizedBox(height: 24),
          _buildLeadershipSection(),
          const SizedBox(height: 24),
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return AnimatedCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Миссия и видение',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              university.mission.textRu.isNotEmpty
                  ? university.mission.textRu
                  : university.mission.text,
              style: AppTextStyles.bodyLarge,
            ),
            if (university.mission.visionRu.isNotEmpty ||
                university.mission.vision.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Видение:',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              Text(
                university.mission.visionRu.isNotEmpty
                    ? university.mission.visionRu
                    : university.mission.vision,
                style: AppTextStyles.bodyLarge,
              ),
            ],
            if (university.mission.valuesRu.isNotEmpty ||
                university.mission.values.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Ценности:',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              ...(university.mission.valuesRu.isNotEmpty
                      ? university.mission.valuesRu
                      : university.mission.values)
                  .map((value) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                value,
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
    );
  }

  Widget _buildHistorySection() {
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
                    Icons.history,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'История',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              university.history.textRu.isNotEmpty
                  ? university.history.textRu
                  : university.history.text,
              style: AppTextStyles.bodyLarge,
            ),
            if (university.history.events.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...university.history.events.map((event) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${event.year}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            event.descriptionRu.isNotEmpty
                                ? event.descriptionRu
                                : event.description,
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
    );
  }

  Widget _buildLeadershipSection() {
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
                    Icons.person,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Руководство',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (university.leadership.rectorNameRu.isNotEmpty ||
                university.leadership.rectorName.isNotEmpty)
              _buildLeaderCard(
                name: university.leadership.rectorNameRu.isNotEmpty
                    ? university.leadership.rectorNameRu
                    : university.leadership.rectorName,
                position: 'Ректор',
                bio: university.leadership.rectorBioRu.isNotEmpty
                    ? university.leadership.rectorBioRu
                    : university.leadership.rectorBio,
                photoUrl: university.leadership.rectorPhotoUrl,
              ),
            if (university.leadership.leaders.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...university.leadership.leaders.map((leader) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLeaderCard(
                      name: leader.nameRu.isNotEmpty
                          ? leader.nameRu
                          : leader.name,
                      position: leader.positionRu.isNotEmpty
                          ? leader.positionRu
                          : leader.position,
                      bio: leader.bioRu.isNotEmpty ? leader.bioRu : leader.bio,
                      photoUrl: leader.photoUrl,
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderCard({
    required String name,
    required String position,
    required String bio,
    required String photoUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                color: AppColors.surfaceDark,
                child: const Icon(Icons.person),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: AppColors.surfaceDark,
                child: const Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                if (bio.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    style: AppTextStyles.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    if (university.achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
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
                Icons.emoji_events,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Достижения',
              style: AppTextStyles.h3,
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimationLimiter(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: university.achievements.length,
            itemBuilder: (context, index) {
              final achievement = university.achievements[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: AppConstants.animationDuration,
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: AnimatedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: achievement.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.surfaceDark,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.surfaceDark,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  achievement.titleRu.isNotEmpty
                                      ? achievement.titleRu
                                      : achievement.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  achievement.descriptionRu.isNotEmpty
                                      ? achievement.descriptionRu
                                      : achievement.description,
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

