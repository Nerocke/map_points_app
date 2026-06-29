class MapPoint {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;

  const MapPoint({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
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

  @override
  String toString() => 'MapPoint(id: $id, name: $name, lat: $latitude, lng: $longitude)';
}
