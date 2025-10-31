class Brands {
  String name;
  int totalproduct;
  String logoUrl;
  String id; 

  // Konstruktor
  Brands({
    required this.id, 
    required this.name,
    required this.logoUrl,
    required this.totalproduct,
  });

  // Metode untuk mengonversi dokumen Firestore menjadi objek Brands
  factory Brands.fromJson(Map<String, dynamic> json, {required String id}) {
    return Brands(
      id: id, 
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      totalproduct: json['totalproduct'] ?? 0,
    );
  }

}
