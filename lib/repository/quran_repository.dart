import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/surah.dart';

class QuranRepository {
  final http.Client _client;
  QuranRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Surah>> fetchSurahList() async {
    final url = Uri.parse('https://equran.id/api/v2/surat');
    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil daftar surat');
    }

    final decoded = json.decode(res.body);

    // API bisa mengembalikan object { data: [...] } atau langsung list
    final list = (decoded is Map && decoded['data'] != null)
        ? decoded['data'] as List
        : (decoded is List ? decoded : []);

    return list.map((e) => Surah.fromJson(e as Map<String, dynamic>)).toList();
  }
}
