import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/doa.dart';

class DoaRepository {
  final http.Client _client;
  DoaRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<DoaModel>> fetchDoaList() async {
    final url = Uri.parse('https://doa-doa-api-ahmadramadhan.fly.dev/api');
    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil daftar doa');
    }

    final decoded = json.decode(res.body);
    final list = decoded is List
        ? decoded
        : (decoded['data'] is List ? decoded['data'] as List : []);

    return list
        .map((e) => DoaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
