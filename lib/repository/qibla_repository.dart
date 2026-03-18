import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/qibla.dart';

class QiblaRepository {
  final http.Client _client;
  QiblaRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<Qibla> fetchQibla(double lat, double lng) async {
    final url = Uri.parse('https://api.aladhan.com/v1/qibla/$lat/$lng');
    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data kiblat');
    }

    final decoded = json.decode(res.body) as Map<String, dynamic>;

    if (decoded['code'] != null && decoded['code'] != 200) {
      throw Exception('API error: ${decoded['status'] ?? "unknown"}');
    }

    return Qibla.fromJson(decoded);
  }
}
