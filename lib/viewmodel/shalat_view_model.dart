import 'package:flutter/foundation.dart';

import '../model/shalat_schedule_response.dart';
import '../repository/shalat_repository.dart';

class ShalatViewModel extends ChangeNotifier {
  final ShalatRepository _repo;
  ShalatViewModel(this._repo);

  bool _isLoading = false;
  String? _error;
  List<ShalatDaySchedule> _schedules = [];
  ShalatDaySchedule? _todaySchedule;

  // Current city ID (default: Jakarta = 1206)
  int _currentCityId = 1206;
  String _currentCityName = 'Jakarta';

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ShalatDaySchedule> get schedules => _schedules;
  ShalatDaySchedule? get todaySchedule => _todaySchedule;
  int get currentCityId => _currentCityId;
  String get currentCityName => _currentCityName;

  /// Set the current city
  void setCity(int cityId, String cityName) {
    _currentCityId = cityId;
    _currentCityName = cityName;
    notifyListeners();
    // Refetch today's schedule with new city
    fetchTodaySchedule();
  }

  /// Fetch today's prayer schedule
  Future<void> fetchTodaySchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todaySchedule = await _repo.getTodaySchedule(cityId: _currentCityId);
    } catch (e) {
      _error = e.toString();
      _todaySchedule = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMonthlySchedule({
    required int cityId,
    required int year,
    required int month,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _repo.getMonthlySchedule(
        cityId: cityId,
        year: year,
        month: month,
      );
      _schedules = res.schedules;
    } catch (e) {
      _error = e.toString();
      _schedules = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
