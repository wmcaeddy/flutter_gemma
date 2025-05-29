import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:gemira/chat_input_field.dart';
import 'package:gemira/chat_message.dart';
import 'package:gemira/gemma_input_field.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({
    required this.messages,
    required this.gemmaHandler,
    required this.humanHandler,
    required this.errorHandler,
    this.chat,
    super.key,
  });

  final InferenceChat? chat;
  final List<Message> messages;
  final ValueChanged<Message> gemmaHandler;
  final ValueChanged<String> humanHandler;
  final ValueChanged<String> errorHandler;

  @override
  Widget build(BuildContext context) {
    // Pre-calculate reversed messages to avoid doing it on every build
    final reversedMessages = messages.reversed.toList();
    final itemCount = messages.length + 2;
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      reverse: true,
      itemCount: itemCount,
      // Enhanced performance optimizations
      cacheExtent: 1000.0,
      physics: const ClampingScrollPhysics(), // Better scroll physics for chat
      addAutomaticKeepAlives: true, // Keep messages alive for better performance
      addRepaintBoundaries: true, // Reduce repaints
      itemBuilder: (context, index) {
        // Input field at the top (index 0 when reversed)
        if (index == 0) {
          if (messages.isNotEmpty && messages.last.isUser) {
            return GemmaInputField(
              key: const ValueKey('gemma_input'),
              chat: chat,
              messages: messages,
              streamHandler: gemmaHandler,
              errorHandler: errorHandler,
            );
          }
          if (messages.isEmpty || !messages.last.isUser) {
            return ChatInputField(
              key: const ValueKey('chat_input'),
              handleSubmitted: humanHandler,
            );
          }
        } 
        // Divider
        else if (index == 1) {
          return const Divider(
            key: ValueKey('divider'),
            height: 1.0,
          );
        } 
        // Chat messages
        else {
          final messageIndex = index - 2;
          if (messageIndex < reversedMessages.length) {
            final message = reversedMessages[messageIndex];
            return ChatMessageWidget(
              key: ValueKey('message_${messages.length - messageIndex - 1}'),
              message: message,
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
