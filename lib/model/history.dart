import 'package:flutter/material.dart';

class History extends ChangeNotifier {
  double _totalSugar = 0;

  double get totalSugar => _totalSugar;

  get exceedLimit => null;

  void setTotalSugar(double totalSugar) {
    _totalSugar = totalSugar;
    notifyListeners();
  }
}
