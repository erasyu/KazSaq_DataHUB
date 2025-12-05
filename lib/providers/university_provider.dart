import 'package:flutter/foundation.dart';
import 'package:kazsaq_datahub/models/university.dart';
import 'package:kazsaq_datahub/services/firebase_service.dart';

class UniversityProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<University> _universities = [];
  List<University> _filteredUniversities = [];
  University? _selectedUniversity;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCity;

  List<University> get universities => _filteredUniversities;
  University? get selectedUniversity => _selectedUniversity;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCity => _selectedCity;

  Future<void> loadUniversities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _universities = await _firebaseService.getUniversities();
      _filteredUniversities = _universities;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _universities = [];
      _filteredUniversities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUniversityById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedUniversity = await _firebaseService.getUniversityById(id);
      if (_selectedUniversity == null) {
        _error = 'Университет не найден';
      }
    } catch (e) {
      _error = e.toString();
      _selectedUniversity = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchUniversities(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCity(String? city) {
    _selectedCity = city;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredUniversities = _universities.where((university) {
      final matchesSearch = _searchQuery.isEmpty ||
          university.nameRu.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          university.nameKz.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          university.city.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCity =
          _selectedCity == null || university.city == _selectedCity;

      return matchesSearch && matchesCity;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCity = null;
    _filteredUniversities = _universities;
    notifyListeners();
  }

  List<String> getCities() {
    final cities = _universities.map((u) => u.city).toSet().toList();
    cities.sort();
    return cities;
  }
}

