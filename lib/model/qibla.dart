class Qibla {
  final double latitude;
  final double longitude;
  final double direction; // derajat dari utara (clockwise)

  Qibla({
    required this.latitude,
    required this.longitude,
    required this.direction,
  });

  factory Qibla.fromJson(Map<String, dynamic> json) {
    final d = json['data'] ?? json;
    return Qibla(
      latitude: (d['latitude'] as num).toDouble(),
      longitude: (d['longitude'] as num).toDouble(),
      direction: (d['direction'] as num).toDouble(),
    );
  }
}
