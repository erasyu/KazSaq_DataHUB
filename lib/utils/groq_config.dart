import 'groq_config_local.dart';

class GroqConfig {
  static String get apiKey {
    const envKey = String.fromEnvironment('GROQ_API_KEY');
    if (envKey.isNotEmpty) {
      return envKey;
    }
    
    return GroqConfigLocal.apiKey;
  }
}

