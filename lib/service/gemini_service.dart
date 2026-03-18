import 'package:google_generative_ai/google_generative_ai.dart';

/// Gemini Service for Islamic AI Chat
/// Uses the provided API key: AIzaSyD8OpL2TVa7ZObNiG_OxQXs4wV7HprDZMo
class GeminiService {
  final GenerativeModel _model;

  // System prompt to guide AI behavior for Islamic topics
  static const String _systemPrompt = '''
Anda adalah asisten AI yang khusus membantu pengguna dalam urusan agama Islam.
Anda harus:
1. Memberikan jawaban yang sesuai dengan Al-Quran dan Hadits yang shahih
2. Menggunakan bahasa Indonesia yang baik dan benar
3. Bersikap sopan dan empati
4. Jika tidak yakin dengan jawaban, sampaikan bahwa perlu konsultasi dengan ustadz/ulama
5. Jawab dengan singkat dan jelas

Jika ada pertanyaan di luar konteks agama Islam, cukup jawab secara umum tanpa menambahkan konteks agama.
''';

  GeminiService({required String apiKey})
    : _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
        systemInstruction: Content.text(_systemPrompt),
      );

  /// Generate response from AI
  /// This method is used by the ChatRepository
  Future<String> generateResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'Maaf, saya tidak bisa menjawab itu.';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  /// Get response from AI (alias for generateResponse)
  /// This method is used by the ChatViewModel
  Future<String> getResponse(String prompt) async {
    return await generateResponse(prompt);
  }
}
