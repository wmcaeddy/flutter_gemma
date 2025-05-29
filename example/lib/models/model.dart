import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';

enum Model {
  // Qwen2.5-0.5B-Instruct (~500MB) - Smallest
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
  ),

  // TinyLlama-1.1B-Chat-v1.0 (~1.1GB)
  tinyLlama1_1BCpu(
    url:
        'https://huggingface.co/litert-community/TinyLlama-1.1B-Chat-v1.0/resolve/main/TinyLlama-1.1B-Chat-v1.0_multi-prefill-seq_q8_ekv1280.task',
    filename: 'TinyLlama-1.1B-Chat-v1.0_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'TinyLlama 1.1B Chat (CPU)',
    licenseUrl: 'https://huggingface.co/litert-community/TinyLlama-1.1B-Chat-v1.0',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.general,
    temperature: 0.7,
    topK: 40,
    topP: 0.9,
    downloadSizeBytes: 1100000000, // ~1.1GB
  ),
  tinyLlama1_1BGpu(
    url:
        'https://huggingface.co/litert-community/TinyLlama-1.1B-Chat-v1.0/resolve/main/TinyLlama-1.1B-Chat-v1.0_multi-prefill-seq_q8_ekv1280.task',
    filename: 'TinyLlama-1.1B-Chat-v1.0_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'TinyLlama 1.1B Chat (GPU)',
    licenseUrl: 'https://huggingface.co/litert-community/TinyLlama-1.1B-Chat-v1.0',
    needsAuth: false,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.general,
    temperature: 0.7,
    topK: 40,
    topP: 0.9,
    downloadSizeBytes: 1100000000, // ~1.1GB
  ),

  // Gemma3-1B-IT (~1.3GB)
  gemma3_1BCpu(
    url:
        'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task',
    filename: 'gemma3-1b-it-int4.task',
    displayName: 'Gemma3 1B IT (CPU)',
    licenseUrl: 'https://huggingface.co/litert-community/Gemma3-1B-IT',
    needsAuth: true,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
    downloadSizeBytes: 1300000000, // ~1.3GB
  ),
  gemma3_1BGpu(
    url:
        'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task',
    filename: 'gemma3-1b-it-int4.task',
    displayName: 'Gemma3 1B IT (GPU)',
    licenseUrl: 'https://huggingface.co/litert-community/Gemma3-1B-IT',
    needsAuth: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
    downloadSizeBytes: 1300000000, // ~1.3GB
  ),

  // DeepSeek-R1-Distill-Qwen-1.5B (~1.6GB)
  deepSeekR1Distill1_5BCpu(
    url:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    filename: 'DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'DeepSeek R1 Distill Qwen 1.5B (CPU)',
    licenseUrl:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.deepSeek,
    temperature: 0.6,
    topK: 40,
    topP: 0.7,
    downloadSizeBytes: 1600000000, // ~1.6GB
  ),
  deepSeekR1Distill1_5BGpu(
    url:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    filename: 'DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'DeepSeek R1 Distill Qwen 1.5B (GPU)',
    licenseUrl:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B',
    needsAuth: false,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.deepSeek,
    temperature: 0.6,
    topK: 40,
    topP: 0.7,
    downloadSizeBytes: 1600000000, // ~1.6GB
  ),

  // Gemma2-2B-IT (~2.4GB) - Largest
  gemma2_2BCpu(
    url:
        'https://huggingface.co/litert-community/Gemma2-2B-IT/resolve/main/gemma2-2b-it-int4.task',
    filename: 'gemma2-2b-it-int4.task',
    displayName: 'Gemma2 2B IT (CPU)',
    licenseUrl: 'https://huggingface.co/litert-community/Gemma2-2B-IT',
    needsAuth: true,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
    downloadSizeBytes: 2400000000, // ~2.4GB
  ),
  gemma2_2BGpu(
    url:
        'https://huggingface.co/litert-community/Gemma2-2B-IT/resolve/main/gemma2-2b-it-int4.task',
    filename: 'gemma2-2b-it-int4.task',
    displayName: 'Gemma2 2B IT (GPU)',
    licenseUrl: 'https://huggingface.co/litert-community/Gemma2-2B-IT',
    needsAuth: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
    downloadSizeBytes: 2400000000, // ~2.4GB
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
