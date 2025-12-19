import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tangsugar/model/products.dart';

// StateNotifier to manage the list of history products
class HistoryNotifier extends StateNotifier<List<Products>> {
  HistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyJsonList = prefs.getStringList('history') ?? [];
    state = historyJsonList
        .map((json) => Products.fromJson(jsonDecode(json), id: ''))
        .toList();
  }

  Future<void> addToHistory(Products product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJsonList = prefs.getStringList('history') ?? [];

    // Add to local list
    historyJsonList.add(jsonEncode(product.toJson()));

    // Save to SharedPreferences
    await prefs.setStringList('history', historyJsonList);

    // Update state
    state = [...state, product];
  }

  Future<void> removeFromHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyJsonList = prefs.getStringList('history') ?? [];

    if (index >= 0 && index < historyJsonList.length) {
      historyJsonList.removeAt(index);
      await prefs.setStringList('history', historyJsonList);

      // Update state
      final newState = [...state];
      newState.removeAt(index);
      state = newState;
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    state = [];
  }

  double get totalSugar {
    return state.fold(0, (sum, item) => sum + item.sugar);
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<Products>>((ref) {
  return HistoryNotifier();
});
