import 'package:flutter/material.dart';
import 'package:muslim_app/model/chat_message_model.dart';
import 'package:muslim_app/service/gemini_service.dart';

class ChatViewModel extends ChangeNotifier {
  final GeminiService _geminiService;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  ChatViewModel(this._geminiService);

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    notifyListeners();

    // Get response from AI
    final response = await _geminiService.getResponse(text);

    // Add AI message
    _messages.add(ChatMessage(text: response, isUser: false));
    _isLoading = false;
    notifyListeners();
  }

  /// Clear all chat messages
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
