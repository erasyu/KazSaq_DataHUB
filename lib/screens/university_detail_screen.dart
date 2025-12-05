import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kazsaq_datahub/providers/university_provider.dart';
import 'package:kazsaq_datahub/providers/comparison_provider.dart';
import 'package:kazsaq_datahub/screens/comparison_screen.dart';
import 'package:kazsaq_datahub/services/asset_image_service.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/about_section.dart';
import 'package:kazsaq_datahub/widgets/programs_section.dart';
import 'package:kazsaq_datahub/widgets/international_section.dart';
import 'package:kazsaq_datahub/widgets/admission_section.dart';
import 'package:kazsaq_datahub/widgets/tour_3d_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UniversityDetailScreen extends StatefulWidget {
  final String universityId;

  const UniversityDetailScreen({
    super.key,
    required this.universityId,
  });

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UniversityProvider>().loadUniversityById(widget.universityId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UniversityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null || provider.selectedUniversity == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    provider.error ?? 'Университет не найден',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Назад'),
                  ),
                ],
              ),
            );
          }

          final university = provider.selectedUniversity!;
          return CustomScrollView(
            slivers: [
              _buildAppBar(university),
              SliverToBoxAdapter(
                child: _buildHeader(university),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(text: 'О вузе'),
                      Tab(text: 'Программы'),
                      Tab(text: 'Сотрудничество'),
                      Tab(text: 'Поступление'),
                      Tab(text: '3D-тур'),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AboutSection(university: university),
                    ProgramsSection(university: university),
                    InternationalSection(university: university),
                    AdmissionSection(university: university),
                    Tour3DSection(university: university),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoverImage(University university) {
    final assetImage = AssetImageService.getUniversityCoverImage(university.id);
    
    if (assetImage != null) {
      return Image.asset(
        assetImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.surfaceDark,
          child: const Center(
            child: Icon(Icons.image_not_supported, size: 48, color: AppColors.textHint),
          ),
        ),
      );
    }
    
    if (university.coverImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: university.coverImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.surfaceDark,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.surfaceDark,
          child: const Icon(Icons.image_not_supported, size: 48, color: AppColors.textHint),
        ),
      );
    }
    
    return Container(
      color: AppColors.surfaceDark,
      child: const Center(
        child: Icon(Icons.school, size: 48, color: AppColors.textHint),
      ),
    );
  }

  Widget _buildAppBar(University university) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildCoverImage(university),
        title: Text(
          university.nameRu,
          style: AppTextStyles.h3.copyWith(
            color: Colors.white,
            shadows: [
              const Shadow(
                color: Colors.black54,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Consumer<ComparisonProvider>(
          builder: (context, comparisonProvider, child) {
            final isInComparison = comparisonProvider.items
                .any((item) => item.universityId == university.id);
            return IconButton(
              icon: Icon(
                isInComparison ? Icons.compare_arrows : Icons.add,
                color: isInComparison ? AppColors.primary : Colors.white,
              ),
              onPressed: () {
                if (isInComparison) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComparisonScreen(),
                    ),
                  );
                } else {
                  if (comparisonProvider.canAddMore) {
                    comparisonProvider.addUniversity(university.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Университет добавлен в сравнение (${comparisonProvider.itemCount}/${AppConstants.maxComparisonItems})'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Максимум ${AppConstants.maxComparisonItems} элементов в сравнении'),
                        backgroundColor: AppColors.error,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () async {
            final url = Uri.parse(university.website);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
      ],
    );
  }

  Widget _buildHeader(University university) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: university.logoUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.school,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBarIndicator(
                      rating: university.rating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: AppColors.primary,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          university.location,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            university.descriptionRu.isNotEmpty
                ? university.descriptionRu
                : university.description,
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(
                icon: Icons.people,
                label: '${university.studentCount} студентов',
              ),
              _buildInfoChip(
                icon: Icons.calendar_today,
                label: 'Основан в ${university.foundedDate.year}',
              ),
              _buildInfoChip(
                icon: Icons.language,
                label: university.website,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

