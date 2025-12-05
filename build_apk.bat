@echo off
echo ========================================
echo Сборка APK для Android
echo ========================================
echo.

echo Очистка проекта...
call flutter clean

echo.
echo Установка зависимостей...
call flutter pub get

echo.
echo Генерация иконок приложения...
call flutter pub run flutter_launcher_icons

echo.
echo Сборка APK (Release)...
call flutter build apk --release

echo.
echo ========================================
echo Сборка завершена!
echo APK находится в: build\app\outputs\flutter-apk\app-release.apk
echo ========================================
pause

