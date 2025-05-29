import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/downloaded_models_service.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _downloadedModelsService = DownloadedModelsService();
  List<DownloadedModelInfo> _downloadedModels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloadedModels();
  }

  Future<void> _loadDownloadedModels() async {
    final models = await _downloadedModelsService.getDownloadedModels();
    setState(() {
      _downloadedModels = models;
      _isLoading = false;
    });
  }

  Future<void> _deleteModel(DownloadedModelInfo modelInfo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Model'),
        content: Text('Are you sure you want to delete "${modelInfo.displayName}"?\n\nThis will free up ${modelInfo.formattedSize} of storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _downloadedModelsService.deleteDownloadedModel(modelInfo.filename);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${modelInfo.displayName} deleted successfully')),
          );
        }
        await _loadDownloadedModels(); // Refresh the list
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete model')),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information & Agreements'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Section
            _buildSection(
              title: 'About Gemira',
              icon: Icons.info_outline,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gemira is a privacy-first local AI chat application that runs language models directly on your device. No data is sent to external servers.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Version: 1.0.0 (Build 1)',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Copyright Section
            _buildSection(
              title: 'Copyright & Licensing',
              icon: Icons.copyright,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flutter Gemma Plugin',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('© 2024 DenisovAV and Contributors'),
                  const Text('Licensed under MIT License'),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => _launchUrl('https://github.com/DenisovAV/flutter_gemma'),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('View Source Code'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'AI Models',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('Models used in this application are subject to their respective licensing terms'),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => _launchUrl('https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct'),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Qwen2.5 Model Info'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Section
            _buildSection(
              title: 'Privacy & Data Handling',
              icon: Icons.privacy_tip,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shield, 
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Local Processing Only',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gemira processes all AI requests locally on your device. Your conversations and data never leave your device or get sent to external servers.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Data We Collect:'),
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• None - all processing is local'),
                        Text('• Model files are stored locally'),
                        Text('• Chat history remains on device'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Downloaded Models Section
            _buildSection(
              title: 'Downloaded Models',
              icon: Icons.storage,
              content: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _downloadedModels.isEmpty
                      ? const Text(
                          'No models downloaded yet. Download models from the model selection screen to see them here.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total storage used: ${_downloadedModelsService.formatFileSize(_downloadedModels.fold<int>(0, (sum, model) => sum + model.fileSize))}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...(_downloadedModels.map((modelInfo) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  Icons.smart_toy,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(
                                  modelInfo.displayName,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Size: ${modelInfo.formattedSize}'),
                                    Text(
                                      'Downloaded: ${_formatDate(modelInfo.lastModified)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteModel(modelInfo),
                                  tooltip: 'Delete model',
                                ),
                              ),
                            ))),
                          ],
                        ),
            ),
            
            const SizedBox(height: 24),
            
            // Terms of Use Section
            _buildSection(
              title: 'Terms of Use',
              icon: Icons.description,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'By using Gemira, you agree to:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Use the application responsibly and ethically'),
                  const Text('2. Comply with all applicable laws and regulations'),
                  const Text('3. Respect the intellectual property rights of model creators and other contributors'),
                  const Text('4. Understand that AI responses may not always be accurate'),
                  const Text('5. Take responsibility for your use of AI-generated content'),
                  const SizedBox(height: 12),
                  const Text(
                    'Disclaimer:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'This application is provided "as is" without warranty of any kind. The developers are not responsible for any damages arising from the use of this application.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // LICENSE Section
            _buildSection(
              title: 'License',
              icon: Icons.article,
              content: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MIT License',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Copyright (c) 2024 Sasha Denisov\n\n'
                      'Permission is hereby granted, free of charge, to any person obtaining a copy '
                      'of this software and associated documentation files (the "Software"), to deal '
                      'in the Software without restriction, including without limitation the rights '
                      'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
                      'copies of the Software, and to permit persons to whom the Software is '
                      'furnished to do so, subject to the following conditions:\n\n'
                      'The above copyright notice and this permission notice shall be included in all '
                      'copies or substantial portions of the Software.\n\n'
                      'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
                      'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
                      'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE '
                      'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER '
                      'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, '
                      'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE '
                      'SOFTWARE.',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact Section - COMMENTED OUT
            /*
            _buildSection(
              title: 'Contact & Support',
              icon: Icons.contact_support,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('For questions or support regarding:'),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _launchUrl('https://github.com/DenisovAV/flutter_gemma/issues'),
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Report Issues'),
                  ),
                  TextButton.icon(
                    onPressed: () => _launchUrl('https://github.com/DenisovAV/flutter_gemma/discussions'),
                    icon: const Icon(Icons.forum),
                    label: const Text('Community Discussions'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            */
            
            const SizedBox(height: 32),
            
            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Gemira v1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Built with Flutter & Open Source AI',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
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

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Handle error - could show a snackbar or dialog
      print('Could not launch $url');
    }
  }
} 