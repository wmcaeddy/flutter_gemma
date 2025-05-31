import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:gemira/chat_widget.dart';
import 'package:gemira/loading_widget.dart';
import 'package:gemira/models/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gemira/model_selection_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemira/services/gemma_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.model = Model.qwen25_0_5BGpu});

  final Model model;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _gemma = FlutterGemmaPlugin.instance;
  InferenceChat? chat;
  final _messages = <Message>[];
  bool _isModelInitialized = false;
  bool _isAiTyping = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  @override
  void dispose() {
    super.dispose();
    _gemma.modelManager.deleteModel();
  }

  Future<void> _initializeModel() async {
    try {
      if (!await _gemma.modelManager.isModelInstalled) {
        final path = kIsWeb
            ? widget.model.url
            : '${(await getApplicationDocumentsDirectory()).path}/${widget.model.filename}';
        await _gemma.modelManager.setModelPath(path);
      }
      final model = await _gemma.createModel(
        modelType: super.widget.model.modelType,
        preferredBackend: super.widget.model.preferredBackend,
        maxTokens: 1024,
      );
      chat = await model.createChat(
        temperature: super.widget.model.temperature,
        randomSeed: 1,
        topK: super.widget.model.topK,
        topP: super.widget.model.topP,
        tokenBuffer: 256,
      );
      if (mounted) {
        setState(() {
          _isModelInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to initialize model: $e';
          _isModelInitialized = false;
        });
      }
    }
  }

  void _handleGemmaMessage(Message message) {
    if (mounted) {
      setState(() {
        _messages.add(message);
        _isAiTyping = false; // AI finished typing
      });
    }
  }

  void _handleHumanMessage(String text) {
    if (mounted) {
      setState(() {
        _error = null;
        _messages.add(Message(text: text, isUser: true));
        _isAiTyping = true; // AI will start typing
      });
    }
  }

  void _handleError(String error) {
    if (mounted) {
      setState(() {
        _error = error;
        _isAiTyping = false; // Stop typing indicator on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b2351),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background image
          Center(
            child: Opacity(
              opacity: 0.1, // Make background more subtle
              child: Image.asset(
                'assets/background.png',
                width: 200,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(); // Hide if image fails to load
                },
              ),
            ),
          ),
          // Main content
          _isModelInitialized
              ? Column(
                  children: [
                    // Error banner
                    if (_error != null) _buildErrorBanner(_error!),
                    // Chat content
                    Expanded(
                      child: ChatListWidget(
                        chat: chat,
                        gemmaHandler: _handleGemmaMessage,
                        humanHandler: _handleHumanMessage,
                        errorHandler: _handleError,
                        messages: _messages,
                      ),
                    ),
                  ],
                )
              : const LoadingWidget(message: 'Initializing the model'),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0b2351),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ModelSelectionScreen(),
            ),
            (route) => false,
          );
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gemira Chat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          Text(
            widget.model.displayName,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'New Session',
          onPressed: () => _showResetConfirmationDialog(),
        ),
      ],
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start New Session'),
          content: const Text(
            'This will clear all chat history and start a fresh conversation. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetSession();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0b2351),
              ),
              child: const Text('Start New Session'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetSession() async {
    try {
      // Show loading indicator
      setState(() {
        _isAiTyping = true;
        _error = null;
      });

      // Clear chat history and memory
      if (chat != null) {
        await chat!.clearHistory();
      }

      // Clear messages and reset state
      setState(() {
        _messages.clear();
        _error = null;
        _isAiTyping = false;
      });

      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New session started successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to reset session: $e';
        _isAiTyping = false;
      });
    }
  }

  Widget _buildErrorBanner(String errorMessage) {
    return Container(
      width: double.infinity,
      color: Colors.red,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () {
              setState(() {
                _error = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
