import 'package:flutter/foundation.dart';

import '../model/qibla.dart';
import '../repository/qibla_repository.dart';

class QiblaViewModel extends ChangeNotifier {
  final QiblaRepository _repo;
  QiblaViewModel(this._repo);

  bool _isLoading = false;
  String? _error;
  Qibla? _qibla;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Qibla? get qibla => _qibla;

  Future<void> fetchQibla(double lat, double lng) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _qibla = await _repo.fetchQibla(lat, lng);
    } catch (e) {
      _error = e.toString();
      _qibla = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
