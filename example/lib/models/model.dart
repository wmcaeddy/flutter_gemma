import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';

enum Model {
  // Qwen2.5-0.5B-Instruct (~500MB) - CPU variant
  qwen25_0_5BCpu(
    url:
        'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct/resolve/main/Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    filename: 'Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'Qwen2.5 0.5B Instruct (CPU)',
    licenseUrl: 'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.general,
    temperature: 0.7,
    topK: 40,
    topP: 0.9,
    downloadSizeBytes: 500000000, // ~500MB
  ),
  
  // Qwen2.5-0.5B-Instruct (~500MB) - GPU variant
  qwen25_0_5BGpu(
    url:
        'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct/resolve/main/Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    filename: 'Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'Qwen2.5 0.5B Instruct (GPU)',
    licenseUrl: 'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct',
    needsAuth: false,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.general,
    temperature: 0.7,
    topK: 40,
    topP: 0.9,
    downloadSizeBytes: 500000000, // ~500MB
  );

  const Model({
    required this.url,
    required this.filename,
    required this.displayName,
    required this.licenseUrl,
    required this.needsAuth,
    required this.preferredBackend,
    required this.modelType,
    this.localModel = false,
    this.temperature = 0.8,
    this.topK = 1,
    this.topP,
    required this.downloadSizeBytes,
  });

  final String url;
  final String filename;
  final String displayName;
  final String licenseUrl;
  final bool needsAuth;
  final bool localModel;
  final PreferredBackend preferredBackend;
  final ModelType modelType;
  final double temperature;
  final int topK;
  final double? topP;
  final int downloadSizeBytes;

  String get formattedSize {
    if (downloadSizeBytes >= 1000000000) {
      return '${(downloadSizeBytes / 1000000000).toStringAsFixed(1)} GB';
    } else {
      return '${(downloadSizeBytes / 1000000).toStringAsFixed(0)} MB';
    }
  }

  String get backendType {
    return preferredBackend == PreferredBackend.gpu ? 'GPU' : 'CPU';
  }

  static List<Model> get allModelsBySize {
    final models = Model.values.toList();
    models.sort((a, b) => a.downloadSizeBytes.compareTo(b.downloadSizeBytes));
    return models;
  }
}
