import 'package:flutter/material.dart';

class YearProvider extends ChangeNotifier {
  List<String> _years = [];
  String? _selectedYear;

  YearProvider() {
    _loadYears();
  }

  List<String> get years => _years;
  String? get selectedYear => _selectedYear;

  void _loadYears() {
    final currentYear = DateTime.now().year;
    _years = List.generate(1, (index) => (currentYear - index).toString());
    _selectedYear = _years.first; // Por defecto, selecciona el año actual
  }

  void setYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }
}
