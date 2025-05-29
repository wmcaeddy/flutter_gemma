import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model.dart';

class DownloadedModelsService {
  static const String _downloadedModelsKey = 'downloaded_models';

  /// Get the list of downloaded model filenames
  Future<List<String>> getDownloadedModelFilenames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_downloadedModelsKey) ?? [];
  }

  /// Add a model filename to the downloaded list
  Future<void> addDownloadedModel(String filename) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedModels = await getDownloadedModelFilenames();
    if (!downloadedModels.contains(filename)) {
      downloadedModels.add(filename);
      await prefs.setStringList(_downloadedModelsKey, downloadedModels);
    }
  }

  /// Remove a model filename from the downloaded list
  Future<void> removeDownloadedModel(String filename) async {
    final prefs = await SharedPreferences.getInstance();
    final downloadedModels = await getDownloadedModelFilenames();
    downloadedModels.remove(filename);
    await prefs.setStringList(_downloadedModelsKey, downloadedModels);
  }

  /// Get the list of downloaded models with their metadata
  Future<List<DownloadedModelInfo>> getDownloadedModels() async {
    final downloadedFilenames = await getDownloadedModelFilenames();
    final List<DownloadedModelInfo> downloadedModels = [];
    
    final directory = await getApplicationDocumentsDirectory();
    
    for (final filename in downloadedFilenames) {
      final file = File('${directory.path}/$filename');
      if (await file.exists()) {
        final fileSize = await file.length();
        final lastModified = await file.lastModified();
        
        // Find the model info from the Model enum
        final model = Model.values.cast<Model?>().firstWhere(
          (m) => m?.filename == filename,
          orElse: () => null,
        );
        
        downloadedModels.add(DownloadedModelInfo(
          filename: filename,
          fileSize: fileSize,
          lastModified: lastModified,
          model: model,
        ));
      } else {
        // Remove from list if file doesn't exist
        await removeDownloadedModel(filename);
      }
    }
    
    // Sort by last modified date (newest first)
    downloadedModels.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    
    return downloadedModels;
  }

  /// Delete a downloaded model file and remove from list
  Future<bool> deleteDownloadedModel(String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      
      if (await file.exists()) {
        await file.delete();
      }
      
      await removeDownloadedModel(filename);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting model $filename: $e');
      }
      return false;
    }
  }

  /// Get total size of all downloaded models
  Future<int> getTotalDownloadedSize() async {
    final downloadedModels = await getDownloadedModels();
    return downloadedModels.fold<int>(
      0,
      (total, model) => total + model.fileSize,
    );
  }

  /// Format file size in human-readable format
  String formatFileSize(int bytes) {
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

class DownloadedModelInfo {
  final String filename;
  final int fileSize;
  final DateTime lastModified;
  final Model? model;

  DownloadedModelInfo({
    required this.filename,
    required this.fileSize,
    required this.lastModified,
    this.model,
  });

  String get displayName => model?.displayName ?? filename;
  String get formattedSize => DownloadedModelsService().formatFileSize(fileSize);
} 