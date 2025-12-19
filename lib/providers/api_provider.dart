import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tangsugar/services/api_service.dart';
import 'package:tangsugar/services/notification_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final fetchDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final notificationService = NotificationService();

  try {
    final data = await apiService.fetchData();
    // Trigger notification on success
    await notificationService.showNotification(
      'Data Fetched Successfully!',
      'Message: ${data['message']}',
    );
    return data;
  } catch (e) {
    // Optionally trigger notification on failure too
    await notificationService.showNotification(
      'Fetch Failed',
      'Error: $e',
    );
    rethrow;
  }
});
