import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kazsaq_datahub/providers/university_provider.dart';
import 'package:kazsaq_datahub/screens/university_detail_screen.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/university_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class UniversitiesListScreen extends StatefulWidget {
  const UniversitiesListScreen({super.key});

  @override
  State<UniversitiesListScreen> createState() => _UniversitiesListScreenState();
}

class _UniversitiesListScreenState extends State<UniversitiesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Университеты',
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: Consumer<UniversityProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return _buildLoadingState();
                }

                if (provider.error != null) {
                  return _buildErrorState(provider.error!);
                }

                if (provider.universities.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildUniversitiesList(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              context.read<UniversityProvider>().searchUniversities(value);
            },
            decoration: InputDecoration(
              hintText: 'Поиск...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.primary),
                      onPressed: () {
                        _searchController.clear();
                        context.read<UniversityProvider>().searchUniversities('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Consumer<UniversityProvider>(
            builder: (context, provider, child) {
              final cities = provider.getCities();
              if (cities.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cities.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = provider.selectedCity == null;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('Все'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              provider.filterByCity(null);
                            }
                          },
                          selectedColor: AppColors.primaryLight,
                          checkmarkColor: Colors.white,
                        ),
                      );
                    }

                    final city = cities[index - 1];
                    final isSelected = provider.selectedCity == city;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(city),
                        selected: isSelected,
                        onSelected: (selected) {
                          provider.filterByCity(selected ? city : null);
                        },
                        selectedColor: AppColors.primaryLight,
                        checkmarkColor: Colors.white,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceDark,
          highlightColor: AppColors.surface,
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка загрузки',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<UniversityProvider>().loadUniversities();
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить параметры поиска',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversitiesList(UniversityProvider provider) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: provider.universities.length,
        itemBuilder: (context, index) {
          final university = provider.universities[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppConstants.longAnimationDuration,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: UniversityCard(
                  university: university,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UniversityDetailScreen(universityId: university.id),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

