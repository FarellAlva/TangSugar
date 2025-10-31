import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tangsugar/model/brands.dart';
import 'package:tangsugar/model/products.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference<Map<String, dynamic>> _brandRef;

  DatabaseService() {
    _brandRef = _firestore.collection('brand');
  }

  Stream<List<Brands>> getBrands() {
    return _brandRef.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Brands.fromJson(doc.data(), id: doc.id);
      }).toList();
    });
  }

  Stream<List<Products>> getProductsForBrand(String brandId) {
    return _brandRef
        .doc(brandId)
        .collection('foods')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Products.fromJson(doc.data(), id: doc.id);
      }).toList();
    });
  }
}
