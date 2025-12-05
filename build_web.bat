@echo off
echo ========================================
echo Сборка веб-версии
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
echo Сборка веб-версии (Release)...
call flutter build web --release

echo.
echo ========================================
echo Сборка завершена!
echo Файлы находятся в: build\web\
echo ========================================
echo.
echo Для локального тестирования выполните:
echo cd build\web
echo python -m http.server 8000
echo.
pause

