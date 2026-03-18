class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'] ?? json['number'] ?? 0,
      nama: json['nama'] ?? json['name'] ?? '',
      namaLatin: json['nama_latin'] ?? json['latin'] ?? json['namaLatin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? json['ayat'] ??json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? json['type'] ?? json['tempatTurun'] ?? '',
      arti: json['arti'] ?? json['translation'] ?? '',
      deskripsi: json['deskripsi'] ?? json['description'] ?? '',
    );
  }
}
