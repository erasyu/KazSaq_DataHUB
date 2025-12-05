import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kazsaq_datahub/models/news.dart';

class NewsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<News> _news = [];
  bool _isLoading = false;
  String? _error;

  List<News> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNews({int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('news')
          .orderBy('publishedAt', descending: true)
          .limit(limit)
          .get();

      _news = snapshot.docs
          .map((doc) => News.fromMap(doc.id, doc.data()))
          .toList();
      _error = null;
    } catch (e) {
      // Если коллекция не существует или нет данных, просто возвращаем пустой список
      _error = null;
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNewsByUniversity(String universityId, {int limit = 5}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('news')
          .where('universityId', isEqualTo: universityId)
          .orderBy('publishedAt', descending: true)
          .limit(limit)
          .get();

      _news = snapshot.docs
          .map((doc) => News.fromMap(doc.id, doc.data()))
          .toList();
      _error = null;
    } catch (e) {
      // Если коллекция не существует или нет данных, просто возвращаем пустой список
      _error = null;
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

