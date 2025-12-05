// Groq API конфигурация
// Для использования API ключа:
// 1. Установите переменную окружения GROQ_API_KEY при запуске
// 2. Или создайте файл groq_config_local.dart с классом GroqConfigLocal
//    (см. groq_config.example.dart)

class GroqConfig {
  // Получение API ключа из переменной окружения
  static String get apiKey {
    const envKey = String.fromEnvironment('GROQ_API_KEY');
    if (envKey.isNotEmpty) {
      return envKey;
    }
    
    // Попытка получить из локального файла (если существует)
    // В продакшене используйте переменные окружения
    return '';
  }
}

