import 'package:flutter/foundation.dart';

enum ViewState { idle, busy, error }

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _error;

  ViewState get state => _state;
  String? get errorMessage => _error;

  void setBusy() {
    _state = ViewState.busy;
    _error = null;
    notifyListeners();
  }

  void setIdle() {
    _state = ViewState.idle;
    notifyListeners();
  }

  void setError(String message) {
    _state = ViewState.error;
    _error = message;
    notifyListeners();
  }
}
