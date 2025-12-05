import 'package:flutter/material.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:kazsaq_datahub/widgets/animated_card.dart';
import 'package:kazsaq_datahub/widgets/google_maps_3d_section.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Tour3DSection extends StatefulWidget {
  final University university;

  const Tour3DSection({super.key, required this.university});

  @override
  State<Tour3DSection> createState() => _Tour3DSectionState();
}

class _Tour3DSectionState extends State<Tour3DSection> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Определяем количество доступных вкладок
    int tabCount = 0;
    if (widget.university.tour3dUrl != null && widget.university.tour3dUrl!.isNotEmpty) {
      tabCount++;
    }
    if (widget.university.latitude != null && widget.university.longitude != null) {
      tabCount++;
    }
    // Если нет ни тура, ни карты, показываем только одно сообщение
    if (tabCount == 0) {
      tabCount = 1;
    }
    _tabController = TabController(length: tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTour = widget.university.tour3dUrl != null && 
                    widget.university.tour3dUrl!.isNotEmpty;
    final hasMap = widget.university.latitude != null && 
                   widget.university.longitude != null;

    // Если нет ни тура, ни карты
    if (!hasTour && !hasMap) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: AnimatedCard(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.view_in_ar,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '3D-вид недоступен',
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Для этого университета пока нет виртуального тура или карты',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Если есть только карта
    if (!hasTour && hasMap) {
      return GoogleMaps3DSection(university: widget.university);
    }

    // Если есть только тур
    if (hasTour && !hasMap) {
      return _buildTourView();
    }

    // Если есть и тур, и карта - показываем табы
    return _buildTabsView();
  }

  Widget _buildTabsView() {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            AnimatedCard(
              child: Container(
                height: kIsWeb 
                    ? MediaQuery.of(context).size.height * 0.75
                    : MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.view_in_ar,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '3D-вид кампуса',
                            style: AppTextStyles.h2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        if (widget.university.tour3dUrl != null && 
                            widget.university.tour3dUrl!.isNotEmpty)
                          const Tab(
                            icon: Icon(Icons.view_in_ar),
                            text: '3D-тур',
                          ),
                        if (widget.university.latitude != null && 
                            widget.university.longitude != null)
                          const Tab(
                            icon: Icon(Icons.map),
                            text: 'Google Maps',
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          if (widget.university.tour3dUrl != null && 
                              widget.university.tour3dUrl!.isNotEmpty)
                            _buildTourContent(),
                          if (widget.university.latitude != null && 
                              widget.university.longitude != null)
                            GoogleMaps3DSection(university: widget.university),
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

  Widget _buildTourView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            AnimatedCard(
              child: Container(
                height: kIsWeb 
                    ? MediaQuery.of(context).size.height * 0.75
                    : MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.view_in_ar,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '3D-тур кампуса',
                            style: AppTextStyles.h2,
                          ),
                        ),
                        if (kIsWeb)
                          IconButton(
                            icon: const Icon(Icons.open_in_new),
                            tooltip: 'Открыть в новом окне',
                            onPressed: () async {
                              try {
                                final url = Uri.parse(widget.university.tour3dUrl!);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Ошибка: $e'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildTourContent(),
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

  Widget _buildTourContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppConstants.defaultBorderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.divider,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            AppConstants.defaultBorderRadius,
          ),
        ),
        child: kIsWeb ? _buildWebIframe() : _buildMobileWebView(),
      ),
    );
  }

  Widget _buildMobileWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка загрузки: ${error.description}'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.university.tour3dUrl!));

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (_isLoading)
          Container(
            color: AppColors.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Загрузка 3D-тура...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWebIframe() {
    if (kIsWeb) {
      // Для веб используем WebView, который работает и на веб-платформе
      return _buildWebWebView();
    }
    
    // Fallback для не-веб платформ
    return _buildMobileWebView();
  }

  Widget _buildWebWebView() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.surface)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ошибка загрузки: ${error.description}'),
                  backgroundColor: AppColors.error,
                  action: SnackBarAction(
                    label: 'Открыть в новом окне',
                    onPressed: () async {
                      try {
                        final url = Uri.parse(widget.university.tour3dUrl!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      } catch (e) {
                        // Игнорируем ошибки
                      }
                    },
                  ),
                ),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.university.tour3dUrl!));

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (_isLoading)
          Container(
            color: AppColors.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Загрузка 3D-тура...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

