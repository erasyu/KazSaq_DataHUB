import 'package:flutter/foundation.dart';
import 'package:kazsaq_datahub/models/comparison.dart';
import 'package:kazsaq_datahub/utils/constants.dart';

class ComparisonProvider with ChangeNotifier {
  final List<ComparisonItem> _items = [];

  List<ComparisonItem> get items => _items;
  int get itemCount => _items.length;
  bool get canAddMore => _items.length < AppConstants.maxComparisonItems;
  bool get isEmpty => _items.isEmpty;

  void addUniversity(String universityId) {
    if (!canAddMore) {
      debugPrint('Нельзя добавить больше элементов. Максимум: ${AppConstants.maxComparisonItems}');
      return;
    }
    if (_items.any((item) => item.universityId == universityId)) {
      debugPrint('Университет уже добавлен в сравнение: $universityId');
      return;
    }

    _items.add(ComparisonItem(universityId: universityId));
    debugPrint('Университет добавлен в сравнение: $universityId. Всего элементов: ${_items.length}');
    notifyListeners();
  }

  void addProgram(String universityId, String programId) {
    if (!canAddMore) return;
    if (_items.any((item) =>
        item.universityId == universityId && item.programId == programId)) {
      return;
    }

    _items.add(ComparisonItem(
      universityId: universityId,
      programId: programId,
    ));
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void removeItemByUniversityId(String universityId) {
    _items.removeWhere((item) => item.universityId == universityId);
    notifyListeners();
  }

  int findItemIndex(String universityId, [String? programId]) {
    if (programId != null) {
      return _items.indexWhere((item) => 
        item.universityId == universityId && item.programId == programId);
    }
    return _items.indexWhere((item) => item.universityId == universityId);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void updateItemUniversity(int index, dynamic university) {
    if (index >= 0 && index < _items.length) {
      final oldItem = _items[index];
      _items[index] = ComparisonItem(
        universityId: oldItem.universityId,
        programId: oldItem.programId,
        university: university,
        program: oldItem.program,
      );
      debugPrint('Обновлен элемент по индексу $index: ${oldItem.universityId} -> ${university.id}');
      notifyListeners();
    } else {
      debugPrint('ОШИБКА: Неверный индекс $index (длина списка: ${_items.length})');
    }
  }

  void updateItemUniversityById(String universityId, dynamic university) {
    final index = findItemIndex(universityId);
    debugPrint('Обновление университета $universityId по индексу $index (всего элементов: ${_items.length})');
    if (index >= 0) {
      updateItemUniversity(index, university);
      debugPrint('Университет обновлен. Всего элементов: ${_items.length}, загружено: ${_items.where((item) => item.university != null).length}');
    } else {
      debugPrint('ОШИБКА: Не найден индекс для университета $universityId');
    }
  }

  void updateItemProgram(int index, dynamic program) {
    if (index >= 0 && index < _items.length) {
      _items[index] = ComparisonItem(
        universityId: _items[index].universityId,
        programId: _items[index].programId,
        university: _items[index].university,
        program: program,
      );
      notifyListeners();
    }
  }

  void updateItemProgramById(String universityId, String programId, dynamic program) {
    final index = findItemIndex(universityId, programId);
    if (index >= 0) {
      updateItemProgram(index, program);
    }
  }
}

