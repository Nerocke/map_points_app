// modele pour un point sur la carte
class MapPoint {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;

  MapPoint({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // pour sauvegarder dans sqlite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory MapPoint.fromMap(Map<String, dynamic> map) {
    return MapPoint(
      id: map['id'] as int?,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  MapPoint copyWith({int? id, String? name, double? latitude, double? longitude}) {
    return MapPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
