import 'package:flutter_test/flutter_test.dart';
import 'package:gemira/models/model.dart';

void main() {
  group('Model Tests', () {
    test('should include SmolLM 135M models', () {
      final allModels = Model.values;
      
      // Check that SmolLM CPU model is included
      final smolLMCpu = allModels.where((model) => 
        model.displayName == 'SmolLM 135M Instruct (CPU)').toList();
      expect(smolLMCpu.length, 1);
      
      // Check that SmolLM GPU model is included
      final smolLMGpu = allModels.where((model) => 
        model.displayName == 'SmolLM 135M Instruct (GPU)').toList();
      expect(smolLMGpu.length, 1);
      
      // Verify the models are sorted by size correctly
      final modelsBySize = Model.allModelsBySize;
      expect(modelsBySize.isNotEmpty, true);
      
      // SmolLM should be the smallest model (167MB)
      final smallestModel = modelsBySize.first;
      expect(smallestModel.downloadSizeBytes, 167000000);
      expect(smallestModel.displayName.contains('SmolLM'), true);
    });

    test('SmolLM model properties should be correct', () {
      final smolLMCpu = Model.smolLM135MCpu;
      
      expect(smolLMCpu.displayName, 'SmolLM 135M Instruct (CPU)');
      expect(smolLMCpu.downloadSizeBytes, 167000000);
      expect(smolLMCpu.needsAuth, false);
      expect(smolLMCpu.temperature, 0.2);
      expect(smolLMCpu.topK, 40);
      expect(smolLMCpu.topP, 0.9);
      expect(smolLMCpu.formattedSize, '167 MB');
      expect(smolLMCpu.filename, 'SmolLM-135M-Instruct_multi-prefill-seq_q8_ekv1280.task');
      expect(smolLMCpu.url.contains('litert-community/SmolLM-135M-Instruct'), true);
    });
  });
} 