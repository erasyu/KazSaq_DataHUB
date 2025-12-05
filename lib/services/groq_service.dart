import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  String? _apiKey;

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  Future<String> askQuestion(String question, {String? context}) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Groq API ключ не установлен');
    }

    try {
      final prompt = context != null
          ? 'Контекст: $context\n\nВопрос: $question\n\nОтветь кратко и по делу на русском языке:'
          : 'Вопрос: $question\n\nОтветь кратко и по делу на русском языке:';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Ты помощник для каталога университетов Казахстана. Помогай пользователям находить подходящие университеты и программы. Отвечай кратко, информативно и на русском языке.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception(
            'Ошибка API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка при обращении к Groq API: $e');
    }
  }

  Future<List<String>> searchUniversities(String query) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Groq API ключ не установлен');
    }

    try {
      final prompt =
          'Пользователь ищет университеты по запросу: "$query". Предложи 3-5 наиболее подходящих вариантов поиска или уточняющих вопросов. Ответь только списком, каждый пункт с новой строки.';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Ты помощник для поиска университетов. Предлагай конкретные варианты поиска.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.5,
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.trim().replaceAll(RegExp(r'^[-•]\s*'), ''))
            .toList();
      } else {
        throw Exception(
            'Ошибка API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка при поиске: $e');
    }
  }

  Future<String> compareUniversities(
      String university1, String university2) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('Groq API ключ не установлен');
    }

    try {
      final prompt =
          'Сравни два университета: "$university1" и "$university2". Укажи основные различия и сходства. Ответь кратко на русском языке.';

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Ты помощник для сравнения университетов. Предоставляй объективную информацию.',
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.6,
          'max_tokens': 400,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception(
            'Ошибка API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка при сравнении: $e');
    }
  }
}

