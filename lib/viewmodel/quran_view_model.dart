import 'package:flutter/foundation.dart';

import '../model/surah.dart';
import '../repository/quran_repository.dart';

class QuranViewModel extends ChangeNotifier {
  final QuranRepository _repo;
  QuranViewModel(this._repo);

  bool _isLoading = false;
  String? _error;
  List<Surah> _surahList = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Surah> get surahList => _surahList;

  Future<void> fetchSurahList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _surahList = await _repo.fetchSurahList();
    } catch (e) {
      _error = e.toString();
      _surahList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
