class Bin {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int fillLevel;
  final String address;
  final String type; // إضافة نوع السلة

  Bin({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.fillLevel,
    required this.address,
    required this.type,
  });

  // إضافة نسخة معدلة من السلة
  Bin copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    int? fillLevel,
    String? address,
    String? type,
  }) {
    return Bin(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fillLevel: fillLevel ?? this.fillLevel,
      address: address ?? this.address,
      type: type ?? this.type,
    );
  }
}
