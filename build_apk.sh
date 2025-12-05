#!/bin/bash

echo "========================================"
echo "Сборка APK для Android"
echo "========================================"
echo ""

echo "Очистка проекта..."
flutter clean

echo ""
echo "Установка зависимостей..."
flutter pub get

echo ""
echo "Генерация иконок приложения..."
flutter pub run flutter_launcher_icons

echo ""
echo "Сборка APK (Release)..."
flutter build apk --release

echo ""
echo "========================================"
echo "Сборка завершена!"
echo "APK находится в: build/app/outputs/flutter-apk/app-release.apk"
echo "========================================"

