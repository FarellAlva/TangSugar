class Products {
  String id;
  String foodname;
  String deskripsi;
  double sugar;
  double weight;
  String pict;
  String code;

  Products({
    required this.id,
    required this.foodname,
    required this.deskripsi,
    required this.sugar,
    required this.weight,
    required this.pict,
    required this.code,
  });

  factory Products.fromJson(Map<String, dynamic> json, {required String id}) {
    return Products(
      id: id,
      foodname: json['foodname'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      sugar: (json['sugar'] ?? 0).toDouble(), 
      weight: (json['weight'] ?? 0).toDouble(), 
      pict: json['pict'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'foodname': foodname,
    'deskripsi': deskripsi,
    'sugar': sugar,
    'weight': weight,
    'pict': pict,
    'code': code,
  };
}
}
