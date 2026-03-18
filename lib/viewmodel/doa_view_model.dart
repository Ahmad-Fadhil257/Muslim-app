import 'package:flutter/foundation.dart';

import '../model/doa.dart';
import '../repository/doa_repository.dart';

class DoaViewModel extends ChangeNotifier {
  final DoaRepository _repo;
  DoaViewModel(this._repo);

  bool _isLoading = false;
  String? _error;
  List<DoaModel> _list = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DoaModel> get list => _list;

  Future<void> fetchDoaList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _list = await _repo.fetchDoaList();
    } catch (e) {
      _error = e.toString();
      _list = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
