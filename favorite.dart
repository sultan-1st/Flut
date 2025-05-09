// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Favorite {
  final String lat;
  final String long;

  Favorite({
    required this.lat,
    required this.long,
  });

  Favorite copyWith({
    String? lat,
    String? long,
  }) {
    return Favorite(
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'long': long,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      lat: map['lat'] as String,
      long: map['long'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favorite.fromJson(String source) => Favorite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Favorite(lat: $lat, long: $long)';

  @override
  bool operator ==(covariant Favorite other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.long == long;
  }

  @override
  int get hashCode => lat.hashCode ^ long.hashCode;
}
