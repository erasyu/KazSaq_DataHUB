#!/bin/bash

echo "========================================"
echo "Сборка веб-версии"
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
echo "Сборка веб-версии (Release)..."
flutter build web --release

echo ""
echo "========================================"
echo "Сборка завершена!"
echo "Файлы находятся в: build/web/"
echo "========================================"
echo ""
echo "Для локального тестирования выполните:"
echo "cd build/web"
echo "python3 -m http.server 8000"
echo ""

