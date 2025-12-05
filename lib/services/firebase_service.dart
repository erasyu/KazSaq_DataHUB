import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kazsaq_datahub/models/university.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<University>> getUniversities() async {
    try {
      final snapshot = await _firestore
          .collection('universities')
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => University.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка загрузки университетов: $e');
    }
  }

  Future<University?> getUniversityById(String id) async {
    try {
      final doc = await _firestore.collection('universities').doc(id).get();
      if (doc.exists) {
        return University.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Ошибка загрузки университета: $e');
    }
  }

  Future<List<University>> searchUniversities(String query) async {
    try {
      final snapshot = await _firestore
          .collection('universities')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => University.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка поиска: $e');
    }
  }

  Future<List<University>> getUniversitiesByCity(String city) async {
    try {
      final snapshot = await _firestore
          .collection('universities')
          .where('city', isEqualTo: city)
          .get();

      return snapshot.docs
          .map((doc) => University.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка фильтрации по городу: $e');
    }
  }

  Future<String> getImageUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      throw Exception('Ошибка загрузки изображения: $e');
    }
  }
}

