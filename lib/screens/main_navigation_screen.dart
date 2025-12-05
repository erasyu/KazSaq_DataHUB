import 'package:flutter/material.dart';
import 'package:kazsaq_datahub/screens/home_screen.dart';
import 'package:kazsaq_datahub/screens/universities_list_screen.dart';
import 'package:kazsaq_datahub/screens/comparison_screen.dart';
import 'package:kazsaq_datahub/screens/ai_assistant_screen.dart';
import 'package:kazsaq_datahub/utils/app_colors.dart';
import 'package:kazsaq_datahub/utils/app_text_styles.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const UniversitiesListScreen(),
    const ComparisonScreen(),
    const AiAssistantScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            selectedLabelStyle: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTextStyles.bodySmall,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'ВУЗ-ы',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.compare_arrows),
                label: 'Сравнение',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.smart_toy),
                label: 'ИИ Помощник',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

