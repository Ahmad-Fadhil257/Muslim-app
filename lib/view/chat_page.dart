import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../viewmodel/chat_view_model.dart';
import '../service/gemini_service.dart';

/// ChatPage - AI Islamic Q&A Feature
/// Uses Gemini AI with system prompt for Islamic context
class ChatPage extends StatefulWidget {
  static const routeName = '/chat';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatViewModel _chatViewModel;

  @override
  void initState() {
    super.initState();
    // Initialize ChatViewModel with Gemini Service
    _chatViewModel = ChatViewModel(
      GeminiService(apiKey: 'AIzaSyD8OpL2TVa7ZObNiG_OxQXs4wV7HprDZMo'),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatViewModel.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await _chatViewModel.sendMessage(text);

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatViewModel,
      child: Scaffold(
        backgroundColor: AppColors.cardBackground,

        // App Bar
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.secondaryWhite,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.accentGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AI Islam',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _chatViewModel.clearMessages();
              },
            ),
          ],
        ),

        // Chat Messages
        body: Column(
          children: [
            // Welcome Message (shown when no messages)
            Expanded(
              child: Consumer<ChatViewModel>(
                builder: (context, chatVM, child) {
                  if (chatVM.messages.isEmpty) {
                    return _buildWelcomeMessage();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatVM.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatVM.messages[index];
                      return _ChatBubble(
                        message: message.text,
                        isUser: message.isUser,
                      );
                    },
                  );
                },
              ),
            ),

            // Loading Indicator
            Consumer<ChatViewModel>(
              builder: (context, chatVM, child) {
                if (chatVM.isLoading) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Menjawab...',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Input Area
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                12 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Tanyakan tentang Islam...',
                          hintStyle: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.inter(fontSize: 14),
                        maxLines: 3,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.secondaryWhite,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mosque,
                color: AppColors.primaryGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Assalamu\'alaikum',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tanyakan apapun tentang agama Islam,\nInsya Allah saya akan membantu.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Suggestion Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SuggestionChip(
                  label: 'Cara niat puasa Ramadhan',
                  onTap: () {
                    _messageController.text = 'Cara niat puasa Ramadhan';
                    _sendMessage();
                  },
                ),
                _SuggestionChip(
                  label: 'Doa berbuka puasa',
                  onTap: () {
                    _messageController.text = 'Doa berbuka puasa';
                    _sendMessage();
                  },
                ),
                _SuggestionChip(
                  label: 'Bacaan Al-Fatihah',
                  onTap: () {
                    _messageController.text = 'Bacaan Al-Fatihah';
                    _sendMessage();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Chat Bubble Widget
class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const _ChatBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mosque,
                color: AppColors.primaryGreen,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primaryGreen
                    : AppColors.secondaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: isUser
                      ? AppColors.secondaryWhite
                      : AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.accentGold,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Suggestion Chip Widget
class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.primaryGreen,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
