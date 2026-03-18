class DoaModel {
  final int id;
  final String doa;
  final String ayat;
  final String latin;
  final String arti;

  DoaModel({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.arti,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      doa: json['doa'] ?? json['title'] ?? '',
      ayat: json['ayat'] ?? '',
      latin: json['latin'] ?? '',
      arti: json['artinya'] ?? json['translation'] ?? '',
    );
  }
}
