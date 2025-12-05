import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kazsaq_datahub/providers/university_provider.dart';
import 'package:kazsaq_datahub/providers/news_provider.dart';
import 'package:kazsaq_datahub/screens/universities_list_screen.dart';
import 'package:kazsaq_datahub/screens/admin_screen.dart';
import 'package:kazsaq_datahub/screens/university_detail_screen.dart';
import 'package:kazsaq_datahub/models/news.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/services/asset_image_service.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UniversityProvider>().loadUniversities();
      context.read<NewsProvider>().loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
        children: [
            Image.asset(
              'assets/LOGOphone.png',
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  AppConstants.appName,
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                );
              },
            ),
            const SizedBox(width: 12),
            Text(
              AppConstants.appName,
              style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: AppColors.background,
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<UniversityProvider>().loadUniversities();
            await context.read<NewsProvider>().loadNews();
          },
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickStats(),
                const SizedBox(height: 24),
                _buildNewsSection(),
                const SizedBox(height: 24),
                _buildPopularUniversities(),
                ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading && newsProvider.news.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Не показываем ошибку, если просто нет новостей
        if (newsProvider.news.isEmpty && !newsProvider.isLoading) {
          return const SizedBox.shrink();
        }

        if (newsProvider.news.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.article, size: 48, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'Новостей пока нет',
                    style: AppTextStyles.h3,
                  ),
                ],
              ),
            ),
          );
        }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
                    'Новости',
                    style: AppTextStyles.h2,
                  ),
                  TextButton(
                    onPressed: () {
                      // Можно добавить экран всех новостей
                    },
                    child: Text(
                      'Все',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                itemCount: newsProvider.news.length,
                itemBuilder: (context, index) {
                  final news = newsProvider.news[index];
                  return _buildNewsCard(news, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewsCard(News news, int index) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'ru');
    
    return Container(
      width: 280,
      margin: EdgeInsets.only(
        right: index == 0 ? 0 : 16,
      ),
      child: AnimatedCard(
        onTap: () {
          if (news.sourceUrl != null && news.sourceUrl!.isNotEmpty) {
            launchUrl(Uri.parse(news.sourceUrl!));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.defaultBorderRadius),
                  topRight: Radius.circular(AppConstants.defaultBorderRadius),
                ),
                child: CachedNetworkImage(
                  imageUrl: news.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 160,
                    color: AppColors.surfaceDark,
                    child: const Center(child: CircularProgressIndicator()),
          ),
                  errorWidget: (context, url, error) => Container(
                    height: 160,
                    color: AppColors.surfaceDark,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 160,
                color: AppColors.surfaceDark,
                child: const Icon(
                  Icons.article,
                  size: 48,
                  color: AppColors.textHint,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.titleRu.isNotEmpty ? news.titleRu : news.title,
                    style: AppTextStyles.h4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
        const SizedBox(height: 8),
        Text(
                    dateFormat.format(news.publishedAt),
                    style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
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

  Widget _buildPopularUniversities() {
    return Consumer<UniversityProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final universities = provider.universities.take(6).toList();

        if (universities.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Популярные ВУЗ-ы',
                    style: AppTextStyles.h2,
                  ),
                  TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UniversitiesListScreen(),
                ),
              );
            },
                    child: Text(
                      'Все',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
          ),
        ),
      ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
      ),
                itemCount: universities.length,
      itemBuilder: (context, index) {
                  final university = universities[index];
                  return _buildUniversityCard(university, index);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUniversityCard(University university, int index) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(
        right: index == 0 ? 0 : 16,
      ),
      child: AnimatedCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UniversityDetailScreen(
                universityId: university.id,
              ),
          ),
        );
      },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.defaultBorderRadius),
                topRight: Radius.circular(AppConstants.defaultBorderRadius),
              ),
              child: _buildUniversityCoverImage(university),
              ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
            Text(
                      university.nameRu,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
                      university.city,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildQuickStats() {
    return Consumer<UniversityProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final count = provider.universities.length;

        return AnimatedCard(
          child: Container(
                padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultBorderRadius,
                  ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.school,
                  value: count.toString(),
                  label: 'Университетов',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildStatItem(
                  icon: Icons.location_city,
                  value: provider.getCities().length.toString(),
                  label: 'Городов',
                ),
              ],
            ),
          ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.h2.copyWith(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildUniversityCoverImage(University university) {
    final assetImage = AssetImageService.getUniversityCoverImage(university.id);
    
    if (assetImage != null) {
      return Image.asset(
        assetImage,
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 110,
          color: AppColors.surfaceDark,
          child: const Icon(
            Icons.school,
            size: 40,
            color: AppColors.textHint,
          ),
        ),
      );
    }
    
    if (university.coverImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: university.coverImageUrl,
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 110,
          color: AppColors.surfaceDark,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 110,
          color: AppColors.surfaceDark,
          child: const Icon(
            Icons.school,
            size: 40,
            color: AppColors.textHint,
          ),
        ),
      );
    }
    
    return Container(
      height: 110,
      color: AppColors.surfaceDark,
      child: const Icon(
        Icons.school,
        size: 40,
        color: AppColors.textHint,
      ),
    );
  }
}
