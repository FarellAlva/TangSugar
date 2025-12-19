import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tangsugar/model/brands.dart';
import 'package:tangsugar/model/products.dart';
import 'package:tangsugar/services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final brandsStreamProvider = StreamProvider<List<Brands>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return databaseService.getBrands();
});

final brandProductsProvider =
    StreamProvider.family<List<Products>, String>((ref, brandId) {
  final databaseService = ref.watch(databaseServiceProvider);
  return databaseService.getProductsForBrand(brandId);
});
