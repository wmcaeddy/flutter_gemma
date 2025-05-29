import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final ValueChanged<String> handleSubmitted;

  const ChatInputField({super.key, required this.handleSubmitted});

  @override
  ChatInputFieldState createState() => ChatInputFieldState();
}

class ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty || _isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    widget.handleSubmitted(text.trim());
    _textController.clear();
    
    // Reset processing state after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).hoverColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isProcessing ? Colors.green.withValues(alpha: 0.5) : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 96.0, // Double the typical height (48 * 2)
                ),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  enabled: !_isProcessing, // Disable during processing
                  decoration: InputDecoration.collapsed(
                    hintText: _isProcessing ? 'Processing...' : 'Send a message',
                    hintStyle: TextStyle(
                      color: _isProcessing ? Colors.orange : null,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _handleSubmitted(_textController.text),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
