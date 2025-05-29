import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/pigeon.g.dart';

enum Model {
  gemma3GpuLocalAsset(
    // model file should be pre-downloaded and placed in the assets folder
    url: 'assets/gemma3-1b-it-int4.task',
    filename: 'gemma3-1b-it-int4.task',
    displayName: 'Gemma3 1B IT (GPU / Local)',
    licenseUrl: '',
    needsAuth: false,
    localModel: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 40,
    topP: 0.95,
  ),
  gemma3Gpu(
    url:
        'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task',
    filename: 'gemma3-1b-it-int4.task',
    displayName: 'Gemma3 1B IT (GPU / Remote)',
    licenseUrl: 'https://huggingface.co/litert-community/Gemma3-1B-IT',
    needsAuth: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
  ),
  gemma3Cpu(
    url:
        'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task',
    filename: 'gemma3-1b-it-int4.task',
    displayName: 'Gemma3 1B IT (CPU / Remote)',
    licenseUrl: 'https://huggingface.co/litert-community/Gemma3-1B-IT',
    needsAuth: true,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
  ),

  gemma3nLocalAsset(
    // model file should be pre-downloaded and placed in the assets folder
    url: 'assets/gemma-3n-E2B-it-int4.task',
    filename: 'gemma-3n-E2B-it-int4.task',
    displayName: 'Gemma 3 Nano E2B IT (Local Asset)',
    licenseUrl: '',
    needsAuth: false,
    localModel: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.1,
    topK: 5,
    topP: 0.95,
  ),

  // New Gemma 3n E4B models
  gemma3nE4BGpu(
    url:
        'https://huggingface.co/google/gemma-3n-E4B-it-litert-preview/resolve/main/gemma-3n-E4B-it-int4.task',
    filename: 'gemma-3n-E4B-it-int4.task',
    displayName: 'Gemma 3n E4B IT (GPU / Remote)',
    licenseUrl: 'https://huggingface.co/google/gemma-3n-E4B-it-litert-preview',
    needsAuth: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.6,
    topK: 1,
    topP: 0.9,
  ),
  gemma3nE4BCpu(
    url:
        'https://huggingface.co/google/gemma-3n-E4B-it-litert-preview/resolve/main/gemma-3n-E4B-it-int4.task',
    filename: 'gemma-3n-E4B-it-int4.task',
    displayName: 'Gemma 3n E4B IT (CPU / Remote)',
    licenseUrl: 'https://huggingface.co/google/gemma-3n-E4B-it-litert-preview',
    needsAuth: true,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.6,
    topK: 1,
    topP: 0.9,
  ),

  // New Gemma 3n E2B models
  gemma3nE2BGpu(
    url:
        'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
    filename: 'gemma-3n-E2B-it-int4.task',
    displayName: 'Gemma 3n E2B IT (GPU / Remote)',
    licenseUrl: 'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview',
    needsAuth: true,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.6,
    topK: 4,
    topP: 0.9,
  ),
  gemma3nE2BCpu(
    url:
        'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
    filename: 'gemma-3n-E2B-it-int4.task',
    displayName: 'Gemma 3n E2B IT (CPU / Remote)',
    licenseUrl: 'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview',
    needsAuth: true,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.gemmaIt,
    temperature: 0.6,
    topK: 1,
    topP: 0.9,
  ),

  deepseek(
    url:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/deepseek_q8_ekv1280.task',
    filename: 'deepseek_q8_ekv1280.task',
    displayName: 'DeepSeek Q8 EKV1280 (CPU / Remote)',
    licenseUrl: '',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.deepSeek,
    temperature: 0.6,
    topK: 40,
    topP: 0.7,
  ),

  // New Qwen-based model entry
  qwenDistill1_5B(
    url:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    filename: 'DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'Qwen 1.5B Distill (CPU / Remote)',
    licenseUrl:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.deepSeek,
    temperature: 0.6,
    topK: 40,
    topP: 0.7,
  ),

  qwenDistill1_5BGpu(
    url:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    filename: 'DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'Qwen 1.5B Distill (GPU / Remote)',
    licenseUrl:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B',
    needsAuth: false,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.deepSeek,
    temperature: 0.6,
    topK: 40,
    topP: 0.7,
  ),

  // SmolLM-135M - Very small and efficient model
  smolLM135MCpu(
    url:
        'https://huggingface.co/litert-community/SmolLM-135M-Instruct/resolve/main/SmolLM-135M-Instruct_multi-prefill-seq_q8_ekv1280.task',
    filename: 'SmolLM-135M-Instruct_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'SmolLM 135M (CPU / Remote)',
    licenseUrl: 'https://huggingface.co/litert-community/SmolLM-135M-Instruct',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.general,
    temperature: 0.2,
    topK: 40,
    topP: 0.9,
  ),

  smolLM135MGpu(
    url:
        'https://huggingface.co/litert-community/SmolLM-135M-Instruct/resolve/main/SmolLM-135M-Instruct_multi-prefill-seq_q8_ekv1280.task',
    filename: 'SmolLM-135M-Instruct_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'SmolLM 135M (GPU / Remote)',
    licenseUrl: 'https://huggingface.co/litert-community/SmolLM-135M-Instruct',
    needsAuth: false,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.general,
    temperature: 0.2,
    topK: 40,
    topP: 0.9,
  ),

  // Qwen2.5-0.5B - Small but capable model
  qwen25_05BCpu(
    url:
        'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct/resolve/main/Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    filename: 'Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'Qwen2.5 0.5B (CPU / Remote)',
    licenseUrl: 'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct',
    needsAuth: false,
    preferredBackend: PreferredBackend.cpu,
    modelType: ModelType.general,
    temperature: 0.7,
    topK: 50,
    topP: 0.9,
  ),

  qwen25_05BGpu(
    url:
        'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct/resolve/main/Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    filename: 'Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task',
    displayName: 'Qwen2.5 0.5B (GPU / Remote)',
    licenseUrl: 'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct',
    needsAuth: false,
    preferredBackend: PreferredBackend.gpu,
    modelType: ModelType.general,
    temperature: 0.7,
    topK: 50,
    topP: 0.9,
  );

  // Define fields for the enum
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
  final double topP;

  // Constructor for the enum
  const Model({
    required this.url,
    required this.filename,
    required this.displayName,
    required this.licenseUrl,
    required this.needsAuth,
    this.localModel = false,
    required this.preferredBackend,
    required this.modelType,
    required this.temperature,
    required this.topK,
    required this.topP,
  });
}
