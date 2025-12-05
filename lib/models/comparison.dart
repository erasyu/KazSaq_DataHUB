import 'package:kazsaq_datahub/models/university.dart';

class ComparisonItem {
  final String universityId;
  final String? programId;
  final University? university;
  final AcademicProgram? program;

  ComparisonItem({
    required this.universityId,
    this.programId,
    this.university,
    this.program,
  });
}

class ComparisonResult {
  final List<ComparisonItem> items;
  final Map<String, dynamic> comparisonData;

  ComparisonResult({
    required this.items,
    required this.comparisonData,
  });
}

