import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:kazsaq_datahub/providers/comparison_provider.dart';
import 'package:kazsaq_datahub/services/firebase_service.dart';
import 'package:kazsaq_datahub/services/asset_image_service.dart';
import 'package:kazsaq_datahub/models/comparison.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  Future<void>? _loadFuture;

  Future<void> _loadComparisonData() async {
    final comparisonProvider = context.read<ComparisonProvider>();
    final firebaseService = FirebaseService();

    // Загружаем все университеты параллельно
    final futures = <Future<void>>[];
    
    // Используем копию списка, чтобы избежать проблем с изменяющимися индексами
    final itemsToLoad = List<ComparisonItem>.from(comparisonProvider.items);
    
    debugPrint('Начинаем загрузку ${itemsToLoad.length} элементов сравнения');
    
    for (final item in itemsToLoad) {
      final universityId = item.universityId;
      final programId = item.programId;
      
      if (item.university == null) {
        futures.add((() async {
          try {
            debugPrint('Загружаем университет: $universityId');
            final university = await firebaseService.getUniversityById(universityId);
            if (university != null && mounted) {
              debugPrint('Университет загружен: $universityId');
              // Используем universityId для поиска, а не индекс
              comparisonProvider.updateItemUniversityById(universityId, university);
              
              // Загружаем программу, если есть programId
              if (programId != null) {
                try {
                  final program = university.academicPrograms.firstWhere(
                    (p) => p.id == programId,
                    orElse: () => university.academicPrograms.isNotEmpty
                        ? university.academicPrograms.first
                        : throw StateError('No programs available'),
                  );
                  if (mounted) {
                    comparisonProvider.updateItemProgramById(universityId, programId, program);
                  }
                } catch (e) {
                  debugPrint('Ошибка загрузки программы $programId для $universityId: $e');
                }
              }
            } else {
              debugPrint('Университет не найден или виджет не смонтирован: $universityId');
            }
          } catch (e) {
            debugPrint('Ошибка загрузки университета $universityId: $e');
          }
        })());
      } else if (programId != null && item.program == null) {
        // Если университет уже загружен, но программа нет
        futures.add((() async {
          try {
            final program = item.university!.academicPrograms.firstWhere(
              (p) => p.id == programId,
              orElse: () => item.university!.academicPrograms.isNotEmpty
                  ? item.university!.academicPrograms.first
                  : throw StateError('No programs available'),
            );
            if (mounted) {
              comparisonProvider.updateItemProgramById(universityId, programId, program);
            }
          } catch (e) {
            debugPrint('Ошибка загрузки программы $programId: $e');
          }
        })());
      }
    }

    // Ждем завершения всех загрузок параллельно
    await Future.wait(futures);
    debugPrint('Загрузка завершена. Всего элементов: ${comparisonProvider.items.length}, загружено: ${comparisonProvider.items.where((item) => item.university != null).length}');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(ComparisonScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Перезагружаем данные при изменении списка сравнения
    final comparisonProvider = context.read<ComparisonProvider>();
    if (comparisonProvider.items.isNotEmpty && _loadFuture == null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _loadFuture = _loadComparisonData();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Сравнение',
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Consumer<ComparisonProvider>(
            builder: (context, provider, child) {
              if (provider.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.clear_all),
                tooltip: 'Очистить сравнение',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Очистить сравнение?'),
                      content: const Text('Вы уверены, что хотите удалить все элементы из сравнения?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Отмена'),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.clear();
                            Navigator.pop(context);
                            setState(() {
                              _loadFuture = null;
                            });
                          },
                          child: const Text('Очистить'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ComparisonProvider>(
        builder: (context, comparisonProvider, child) {
          if (comparisonProvider.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.compare_arrows,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Нет элементов для сравнения',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Добавьте университеты или программы для сравнения',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Если данные еще не загружаются и есть элементы, начинаем загрузку
          if (_loadFuture == null && comparisonProvider.items.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _loadFuture = _loadComparisonData();
                });
              }
            });
            return const Center(child: CircularProgressIndicator());
          }

          if (_loadFuture == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return FutureBuilder<void>(
            future: _loadFuture,
            builder: (context, snapshot) {
              // Проверяем снова после завершения загрузки
              final stillHasUnloadedItems = comparisonProvider.items.any((item) => 
                item.university == null || (item.programId != null && item.program == null));
              
              // Если загрузка завершена, но есть новые незагруженные элементы, перезагружаем
              if (snapshot.connectionState == ConnectionState.done && stillHasUnloadedItems) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _loadFuture = _loadComparisonData();
                    });
                  }
                });
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          'Ошибка загрузки данных',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
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
                    _buildComparisonTable(comparisonProvider),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildComparisonTable(ComparisonProvider provider) {
    final items = provider.items;
    final hasPrograms = items.any((item) => item.programId != null);

    if (hasPrograms) {
      return _buildProgramComparison(items);
    } else {
      return _buildUniversityComparison(items);
    }
  }

  Widget _buildUniversityComparison(List<ComparisonItem> items) {
    debugPrint('Построение таблицы сравнения университетов. Всего элементов: ${items.length}');
    final validItems = items.where((item) => item.university != null).toList();
    final loadingItems = items.where((item) => item.university == null).toList();
    
    debugPrint('Загружено: ${validItems.length}, загружается: ${loadingItems.length}');
    debugPrint('ID загруженных: ${validItems.map((item) => item.universityId).join(", ")}');
    debugPrint('ID загружающихся: ${loadingItems.map((item) => item.universityId).join(", ")}');
    
    if (validItems.isEmpty && loadingItems.isNotEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (validItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Нет данных для отображения'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColors.surfaceDark),
          headingRowHeight: 90,
          dataRowMinHeight: 50,
          dataRowMaxHeight: 80,
          columnSpacing: 12,
          columns: [
            const DataColumn(
              label: SizedBox(
                width: 150,
                child: Text(
                  'Параметр',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...validItems.map((item) {
              return DataColumn(
                label: SizedBox(
                  width: 200,
                  height: 90,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: _buildUniversityLogo(item.university!),
                      ),
                      const SizedBox(height: 3),
                      Flexible(
                        child: Text(
                          item.university!.nameRu,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 14),
                        color: AppColors.error,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        tooltip: 'Удалить из сравнения',
                        onPressed: () {
                          final provider = context.read<ComparisonProvider>();
                          final itemIndex = provider.findItemIndex(item.universityId, item.programId);
                          if (itemIndex >= 0) {
                            provider.removeItem(itemIndex);
                            setState(() {
                              _loadFuture = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        rows: [
          _buildComparisonRow('Рейтинг', validItems.map((item) {
            return item.university!.rating.toStringAsFixed(1);
          }).toList()),
          _buildComparisonRow('Город', validItems.map((item) {
            return item.university!.city.isNotEmpty ? item.university!.city : 'Не указан';
          }).toList()),
          _buildComparisonRow('Студентов', validItems.map((item) {
            return item.university!.studentCount > 0 
                ? item.university!.studentCount.toString() 
                : 'Не указано';
          }).toList()),
          _buildComparisonRow('Год основания', validItems.map((item) {
            return item.university!.foundedDate.year.toString();
          }).toList()),
          _buildComparisonRow('Сайт', validItems.map((item) {
            return item.university!.website.isNotEmpty 
                ? item.university!.website 
                : 'Не указан';
          }).toList()),
          _buildComparisonRow('Телефон', validItems.map((item) {
            return item.university!.phone.isNotEmpty 
                ? item.university!.phone 
                : 'Не указан';
          }).toList()),
          _buildComparisonRow('Email', validItems.map((item) {
            return item.university!.email.isNotEmpty 
                ? item.university!.email 
                : 'Не указан';
          }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramComparison(List<ComparisonItem> items) {
    final validItems = items.where((item) => item.program != null && item.university != null).toList();
    final loadingItems = items.where((item) => item.program == null || item.university == null).toList();
    
    if (validItems.isEmpty && loadingItems.isNotEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (validItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Нет данных для отображения'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColors.surfaceDark),
          headingRowHeight: 100,
          dataRowMinHeight: 50,
          dataRowMaxHeight: 80,
          columnSpacing: 12,
          columns: [
            const DataColumn(
              label: SizedBox(
                width: 150,
                child: Text(
                  'Параметр',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...validItems.map((item) {
              return DataColumn(
                label: SizedBox(
                  width: 200,
                  height: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: _buildUniversityLogo(item.university!),
                      ),
                      const SizedBox(height: 2),
                      Flexible(
                        child: Text(
                          item.program!.nameRu.isNotEmpty
                              ? item.program!.nameRu
                              : item.program!.name,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        item.university!.nameRu,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 12),
                        color: AppColors.error,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        tooltip: 'Удалить из сравнения',
                        onPressed: () {
                          final provider = context.read<ComparisonProvider>();
                          final itemIndex = provider.findItemIndex(item.universityId, item.programId);
                          if (itemIndex >= 0) {
                            provider.removeItem(itemIndex);
                            setState(() {
                              _loadFuture = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        rows: [
          _buildComparisonRow('Степень', validItems.map((item) {
            return item.program!.degreeRu.isNotEmpty
                ? item.program!.degreeRu
                : (item.program!.degree.isNotEmpty ? item.program!.degree : 'Не указана');
          }).toList()),
          _buildComparisonRow('Факультет', validItems.map((item) {
            return item.program!.facultyRu.isNotEmpty
                ? item.program!.facultyRu
                : (item.program!.faculty.isNotEmpty ? item.program!.faculty : 'Не указан');
          }).toList()),
          _buildComparisonRow('Длительность', validItems.map((item) {
            return item.program!.duration > 0 
                ? '${item.program!.duration} ${_getYearWord(item.program!.duration)}'
                : 'Не указана';
          }).toList()),
          _buildComparisonRow('Язык', validItems.map((item) {
            return item.program!.languageRu.isNotEmpty
                ? item.program!.languageRu
                : (item.program!.language.isNotEmpty ? item.program!.language : 'Не указан');
          }).toList()),
          _buildComparisonRow('Стоимость', validItems.map((item) {
            if (item.program!.tuitionFee > 0) {
              final format = NumberFormat.currency(
                symbol: item.program!.currency.isNotEmpty ? item.program!.currency : 'KZT',
                decimalDigits: 0,
              );
              return format.format(item.program!.tuitionFee);
            }
            return 'Не указана';
          }).toList()),
          ],
        ),
      ),
    );
  }

  String _getYearWord(int years) {
    if (years % 10 == 1 && years % 100 != 11) return 'год';
    if (years % 10 >= 2 && years % 10 <= 4 && (years % 100 < 10 || years % 100 >= 20)) return 'года';
    return 'лет';
  }

  DataRow _buildComparisonRow(String label, List<String> values) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...values.map((value) => DataCell(
              Text(
                value,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ],
    );
  }

  Widget _buildUniversityLogo(dynamic university) {
    // Сначала проверяем локальные assets
    final assetImage = AssetImageService.getUniversityCoverImage(university.id);
    
    // Определяем размеры в зависимости от контекста
    final double logoSize = 35;
    final double iconSize = 20;
    
    if (assetImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          assetImage,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.school,
              size: iconSize,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    
    // Если нет локального изображения, используем logoUrl
    if (university.logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: university.logoUrl,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 1.5)),
          ),
          errorWidget: (context, url, error) => Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.school,
              size: iconSize,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    
    // Placeholder если нет изображения
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.school,
        size: iconSize,
        color: AppColors.textSecondary,
      ),
    );
  }
}

