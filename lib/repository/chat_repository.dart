import 'package:muslim_app/service/gemini_service.dart';

class ChatRepository {
  final GeminiService _service;

  ChatRepository(this._service);

  Future<String> sendMessage(String message) async {
    return await _service.generateResponse(message);
  }
}