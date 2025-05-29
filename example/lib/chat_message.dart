import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (!message.isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: 50,
              ),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? Colors.blue.withValues(alpha: 0.8)
                    : const Color(0x80757575),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: message.text.isNotEmpty
                  ? _buildMessageContent()
                  : const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 10),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (_shouldUseMarkdown(message.text)) {
      return MarkdownBody(
        data: message.text,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: Colors.white, fontSize: 14),
          code: TextStyle(
            backgroundColor: Colors.black26,
            color: Colors.lightBlue[300],
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    } else {
      return SelectableText(
        message.text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      );
    }
  }

  bool _shouldUseMarkdown(String text) {
    return text.contains('**') || 
           text.contains('*') || 
           text.contains('`') || 
           text.contains('#') ||
           text.contains('[') ||
           text.contains('```') ||
           text.contains('\n\n');
  }

  Widget _buildAvatar() {
    if (message.isUser) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      );
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/gemma.png',
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.android,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
