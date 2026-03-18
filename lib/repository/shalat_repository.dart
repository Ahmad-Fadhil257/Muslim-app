import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/shalat_schedule_response.dart';

class ShalatRepository {
  final http.Client _client;
  ShalatRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Get today's prayer schedule for a specific city
  Future<ShalatDaySchedule?> getTodaySchedule({required int cityId}) async {
    final now = DateTime.now();
    final url = Uri.parse(
      'https://api.myquran.com/v2/sholat/jadwal/$cityId/${now.year}/${now.month.toString().padLeft(2, '0')}',
    );

    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data');
    }

    final Map<String, dynamic> jsonMap = json.decode(res.body);
    final parsed = ShalatScheduleResponse.fromJson(jsonMap);

    if (!parsed.status) {
      throw Exception(parsed.message ?? 'API status = false');
    }

    // Find today's schedule from the list
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    try {
      return parsed.schedules.firstWhere((s) => s.tanggal.startsWith(todayStr));
    } catch (e) {
      // If exact match not found, return first schedule
      return parsed.schedules.isNotEmpty ? parsed.schedules.first : null;
    }
  }

  Future<ShalatScheduleResponse> getMonthlySchedule({
    required int cityId,
    required int year,
    required int month,
  }) async {
    final url = Uri.parse(
      'https://api.myquran.com/v2/sholat/jadwal/$cityId/$year/$month',
    );

    final res = await _client.get(url);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: gagal ambil data');
    }

    final Map<String, dynamic> jsonMap = json.decode(res.body);
    final parsed = ShalatScheduleResponse.fromJson(jsonMap);

    if (!parsed.status) {
      throw Exception(parsed.message ?? 'API status = false');
    }

    return parsed;
  }
}
