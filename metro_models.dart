class MetroLine {
  final int lineId; // Added lineId for mapping stops
  final String? routeColor; // Nullable
  final String? nameEn; // Nullable
  final String? nameAr; // Nullable
  final List<List<double>>? coords; // Nullable

  MetroLine({
    required this.lineId,
    this.routeColor,
    this.nameEn,
    this.nameAr,
    this.coords,
  });

  factory MetroLine.fromJson(Map<String, dynamic> json) {
    return MetroLine(
      lineId: json['line_id'], // Extract line_id for matching stops
      routeColor: json['routeColor'],
      nameEn: json['lineName']?[0]['en'],
      nameAr: json['lineName']?[0]['ar'],
      coords: (json['coords'] as List?)
          ?.expand((segment) => segment)
          .map<List<double>>((point) => List<double>.from(point))
          .toList(),
    );
  }
}

class MetroStop {
  final int recordId;
  final String nameEn;
  final String nameAr;
  final double latitude;
  final double longitude;
  final int lineId; // Line ID for mapping with MetroLine

  MetroStop({
    required this.recordId,
    required this.nameEn,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
    required this.lineId,
  });

  factory MetroStop.fromJson(Map<String, dynamic> json) {
    return MetroStop(
      recordId: int.tryParse(json['record_id'].toString()) ?? 0, // Safely parse as int
      nameEn: json['stop'][0]['translation'],
      nameAr: json['stop'][1]['translation'],
      latitude: double.parse(json['stop_lat']),
      longitude: double.parse(json['stop_lon']),
      lineId: int.tryParse(json['line_id'].toString()) ?? -1, // Safely parse line_id
    );
  }
}
