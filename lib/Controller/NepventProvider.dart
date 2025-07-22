import 'package:flutter/cupertino.dart';

class NepventProvider extends ChangeNotifier {
  bool _isNeedRefresh = false;

  bool get isNeedRefresh => _isNeedRefresh;

  set isNeedRefresh(bool value) {
    if (_isNeedRefresh != value) {
      _isNeedRefresh = value;
      notifyListeners();
    }
  }
}
