import 'package:flutter/foundation.dart';
import 'package:kazsaq_datahub/services/groq_service.dart';

class AiProvider with ChangeNotifier {
  final GroqService _groqService = GroqService();

  bool _isLoading = false;
  String? _error;
  final List<AiMessage> _messages = [];
  String? _apiKey;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AiMessage> get messages => _messages;
  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
    _groqService.setApiKey(apiKey);
    notifyListeners();
  }

  Future<void> askQuestion(String question, {String? context}) async {
    if (!hasApiKey) {
      _error = 'API ключ не установлен';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _messages.add(
      AiMessage(text: question, isUser: true, timestamp: DateTime.now()),
    );
    notifyListeners();

    try {
      final answer = await _groqService.askQuestion(question, context: context);
      _messages.add(
        AiMessage(text: answer, isUser: false, timestamp: DateTime.now()),
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _messages.add(
        AiMessage(
          text: 'Ошибка: $e',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchUniversities(String query) async {
    if (!hasApiKey) {
      _error = 'API ключ не установлен';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _messages.add(
      AiMessage(text: 'Поиск: $query', isUser: true, timestamp: DateTime.now()),
    );
    notifyListeners();

    try {
      final suggestions = await _groqService.searchUniversities(query);
      _messages.add(
        AiMessage(
          text: 'Варианты поиска:\n${suggestions.join('\n')}',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _messages.add(
        AiMessage(
          text: 'Ошибка: $e',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }
}

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  AiMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}
