import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemira/chat_message.dart';
import 'package:gemira/services/gemma_service.dart';

class GemmaInputField extends StatefulWidget {
  const GemmaInputField({
    super.key,
    required this.messages,
    required this.streamHandler,
    required this.errorHandler,
    this.chat,
  });

  final InferenceChat? chat;
  final List<Message> messages;
  final ValueChanged<Message> streamHandler;
  final ValueChanged<String> errorHandler;

  @override
  GemmaInputFieldState createState() => GemmaInputFieldState();
}

class GemmaInputFieldState extends State<GemmaInputField> {
  GemmaLocalService? _gemma;
  StreamSubscription<String?>? _subscription;
  var _message = const Message(text: '');
  
  // Optimization: Buffer tokens and update UI less frequently but still responsive
  Timer? _updateTimer;
  String _tokenBuffer = '';
  static const Duration _updateInterval = Duration(milliseconds: 30); // Reduced from 50ms to 30ms for better responsiveness
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    _gemma = GemmaLocalService(widget.chat!);
    _processMessages();
  }

  void _processMessages() {
    setState(() {
      _isStreaming = true; // Show immediate feedback that processing started
    });
    
    _subscription = _gemma?.processMessageAsync(widget.messages.last).listen(
      (String token) {
        if (!mounted) return;
        
        // Buffer tokens instead of immediate setState
        _tokenBuffer += token;
        
        // For very first token, show immediately for instant feedback
        if (_message.text.isEmpty && _tokenBuffer.isNotEmpty) {
          setState(() {
            _message = Message(text: _tokenBuffer);
            _isStreaming = true;
          });
          _tokenBuffer = '';
          return;
        }
        
        // Debounce UI updates to reduce rebuilds while maintaining responsiveness
        _updateTimer?.cancel();
        _updateTimer = Timer(_updateInterval, () {
          if (!mounted) return;
          setState(() {
            _message = Message(text: '${_message.text}$_tokenBuffer');
          });
          _tokenBuffer = '';
        });
      },
      onDone: () {
        if (!mounted) return;
        
        // Cancel any pending timer and do final update
        _updateTimer?.cancel();
        
        // Add any remaining buffered tokens
        if (_tokenBuffer.isNotEmpty) {
          setState(() {
            _message = Message(text: '${_message.text}$_tokenBuffer');
            _isStreaming = false;
          });
          _tokenBuffer = '';
        } else {
          setState(() {
            _isStreaming = false;
          });
        }
        
        if (_message.text.isEmpty) {
          _message = const Message(text: '...');
        }
        widget.streamHandler(_message);
        _subscription?.cancel();
      },
      onError: (error) {
        if (!mounted) return;
        
        _updateTimer?.cancel();
        
        debugPrint('Error: $error');
        setState(() {
          _isStreaming = false;
        });
        
        if (_message.text.isEmpty) {
          _message = const Message(text: '...');
        }
        widget.streamHandler(_message);
        widget.errorHandler(error.toString());
        _subscription?.cancel();
      },
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OptimizedChatMessage(message: _message, isStreaming: _isStreaming);
  }
}

// Optimized chat message widget for streaming content
class OptimizedChatMessage extends StatelessWidget {
  const OptimizedChatMessage({super.key, required this.message, this.isStreaming = false});

  final Message message;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // AI Avatar with streaming indicator
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent, 
                foregroundImage: const AssetImage('assets/gemira.png'),
                radius: 16,
              ),
              if (isStreaming)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0x80757575),
                borderRadius: BorderRadius.circular(8.0),
                border: isStreaming ? Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text.isNotEmpty)
                    _buildOptimizedText(message.text)
                  else
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (isStreaming && message.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade300),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Thinking...',
                            style: TextStyle(
                              color: Colors.green.shade300,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildOptimizedText(String text) {
    // For better performance during streaming, use Text widget for short messages
    // and MarkdownBody only for longer, complete messages
    if (text.length < 500 && !text.contains('\n') && !text.contains('**') && !text.contains('*')) {
      return Text(
        text,
        style: const TextStyle(color: Colors.white),
      );
    } else {
      // Use MarkdownBody for rich formatting
      return MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: Colors.white, fontSize: 14),
          h1: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          h2: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          h3: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          code: const TextStyle(
            backgroundColor: Colors.black26,
            color: Colors.lightBlue,
            fontFamily: 'monospace',
          ),
          codeblockDecoration: const BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      );
    }
  }
}
