import 'dart:async';

import 'package:chargestation/design.dart';
import 'package:flutter/foundation.dart';

class VerificationCodeRef with ChangeNotifier, DiagnosticableTreeMixin {
  int _countDown = -1;
  Timer? _timer;
  bool _loading = false;

  int get countDown => _countDown;

  bool get loading => _loading;

  set loading(bool value) {
    if (_loading != value) {
      _loading = value;
      notifyListeners();
    }
  }

  void startTimeCount() {
    _timer?.cancel();
    _countDown = 60;
    notifyListeners();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (--_countDown <= 0) {
        _timer?.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  void stopTimeCount() {
    _timer?.cancel();
    _timer = null;
  }
}
