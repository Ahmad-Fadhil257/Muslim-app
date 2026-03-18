import 'package:flutter/foundation.dart';

/// Types of Dhikr available in the Tasbih feature
enum DhikrType {
  subhanallah, // سبحان الله (Glory be to Allah)
  alhmadulillah, // الحمد لله (Praise be to Allah)
  allahuAkbar, // الله أكبر (Allah is the Greatest)
}

/// Extension to get display properties for DhikrType
extension DhikrTypeExtension on DhikrType {
  String get arabicText {
    switch (this) {
      case DhikrType.subhanallah:
        return 'سبحان الله';
      case DhikrType.alhmadulillah:
        return 'الحمد لله';
      case DhikrType.allahuAkbar:
        return 'الله أكبر';
    }
  }

  String get transliteration {
    switch (this) {
      case DhikrType.subhanallah:
        return 'Subhanallah';
      case DhikrType.alhmadulillah:
        return 'Alhmadulillah';
      case DhikrType.allahuAkbar:
        return 'Allahu Akbar';
    }
  }
}

/// ViewModel for managing Tasbih (Dhikr) counter state
class TasbihViewModel extends ChangeNotifier {
  // Selected Dhikr type
  DhikrType _selectedDhikr = DhikrType.subhanallah;
  DhikrType get selectedDhikr => _selectedDhikr;

  // Current count
  int _count = 0;
  int get count => _count;

  // Limit: 33, 99, or null (unlimited/bebas)
  int? _limit = 33;
  int? get limit => _limit;

  /// Select a different dhikr type
  void selectDhikr(DhikrType type) {
    if (_selectedDhikr != type) {
      _selectedDhikr = type;
      _count = 0; // Reset count when changing dhikr
      notifyListeners();
    }
  }

  /// Increment the counter
  void increment() {
    if (_limit == null) {
      // Unlimited mode
      _count++;
    } else if (_count < _limit!) {
      // Limited mode - stop at limit
      _count++;
    }
    notifyListeners();
  }

  /// Set the counter limit
  void setLimit(int? limit) {
    _limit = limit;
    if (_count > (limit ?? 999)) {
      _count = 0;
    }
    notifyListeners();
  }

  /// Reset the counter to zero
  void reset() {
    _count = 0;
    notifyListeners();
  }

  /// Full reset - clears selection and limit
  void fullReset() {
    _selectedDhikr = DhikrType.subhanallah;
    _count = 0;
    _limit = 33;
    notifyListeners();
  }
}
