import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kazsaq_datahub/firebase_options.dart';
import 'package:kazsaq_datahub/providers/university_provider.dart';
import 'package:kazsaq_datahub/providers/comparison_provider.dart';
import 'package:kazsaq_datahub/providers/ai_provider.dart';
import 'package:kazsaq_datahub/providers/news_provider.dart';
import 'package:kazsaq_datahub/utils/groq_config.dart';
import 'package:kazsaq_datahub/screens/main_navigation_screen.dart';
import 'package:kazsaq_datahub/screens/splash_screen.dart';
import 'package:kazsaq_datahub/services/data_import_service.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';
import 'package:kazsaq_datahub/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Показываем splash screen сразу
  runApp(const MyApp());
  
  // Инициализируем Firebase асинхронно
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    initializeDateFormatting('ru', null);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UniversityProvider()),
        ChangeNotifierProvider(create: (_) => ComparisonProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = AiProvider();
            // API ключ устанавливается пользователем через UI
            // или через переменную окружения GROQ_API_KEY
            final apiKey = GroqConfig.apiKey;
            if (apiKey.isNotEmpty) {
              provider.setApiKey(apiKey);
            }
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'DataHub ВУЗ-ов РК',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: AppTextStyles.h3.copyWith(color: Colors.white),
          ),
          cardTheme: CardTheme(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            color: AppColors.surface,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
        ),
        home: const SplashWrapper(),
      ),
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Ждем инициализации Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initializeDateFormatting('ru', null);
    
    // Автоматически обновляем данные университетов, если их меньше 20
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('universities')
          .limit(21)
          .get();
      
      if (snapshot.docs.length < 20) {
        // Импортируем данные в фоне
        final importService = DataImportService();
        importService.addUniversities().catchError((e) {
          debugPrint('Ошибка автоматического импорта: $e');
        });
      }
    } catch (e) {
      debugPrint('Ошибка проверки данных: $e');
    }
    
    // Небольшая задержка для плавности
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SplashScreen();
    }
    return const MainNavigationScreen();
  }
}
