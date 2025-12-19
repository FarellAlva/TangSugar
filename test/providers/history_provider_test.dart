import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tangsugar/model/products.dart';
import 'package:tangsugar/providers/history_provider.dart';

void main() {
  
  final product1 = Products(
    id: '1',
    foodname: 'Coke',
    deskripsi: 'Soda',
    sugar: 10.0,
    weight: 100.0,
    pict: 'url1',
    code: '123',
  );

  final product2 = Products(
    id: '2',
    foodname: 'Cake',
    deskripsi: 'Dessert',
    sugar: 20.0,
    weight: 100.0,
    pict: 'url2',
    code: '456',
  );

  test('HistoryNotifier starts with empty list', () async {
    // Setup Mock SharedPreferences before using the provider
    SharedPreferences.setMockInitialValues({});

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Initial read
    final history = container.read(historyProvider);
    expect(history, []);

    // Check total sugar
    final notifier = container.read(historyProvider.notifier);
    await Future.delayed(
        const Duration(milliseconds: 50)); // Wait for constructor load
    expect(notifier.totalSugar, 0.0);
  });

  test('HistoryNotifier adds item correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(historyProvider.notifier);
    await Future.delayed(
        const Duration(milliseconds: 50)); // Wait for constructor load

    // Add product
    await notifier.addToHistory(product1);

    // Verify state updated
    final history = container.read(historyProvider);
    expect(history.length, 1);
    expect(history.first.foodname, 'Coke');

    // Verify total sugar
    expect(notifier.totalSugar, 10.0);
  });

  test('HistoryNotifier accumulates total sugar correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(historyProvider.notifier);
    await Future.delayed(
        const Duration(milliseconds: 50)); // Wait for constructor load

    // Add two products
    await notifier.addToHistory(product1);
    await notifier.addToHistory(product2);

    // Verify total sugar (10 + 20)
    expect(notifier.totalSugar, 30.0);
  });

  test('HistoryNotifier removes item correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(historyProvider.notifier);
    await Future.delayed(
        const Duration(milliseconds: 50)); // Wait for constructor load

    // Add and then remove
    await notifier.addToHistory(product1);
    await notifier.removeFromHistory(0);

    final history = container.read(historyProvider);
    expect(history, []);
    expect(notifier.totalSugar, 0.0);
  });

  test('HistoryNotifier clears history correctly', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(historyProvider.notifier);
    await Future.delayed(
        const Duration(milliseconds: 50)); // Wait for constructor load

    await notifier.addToHistory(product1);
    await notifier.addToHistory(product2);

    await notifier.clearHistory();

    final history = container.read(historyProvider);
    expect(history, []);
  });
}
