import 'dart:io';

import 'package:file_metadata/gguf.dart';
import 'package:test/test.dart';

void main() {
  group('Metadata from Filename', () {
    test('Mixtral', () {
      const String modelName = "Mixtral-v0.1-8x7B-Q2_K.gguf";
      GgufMetadata ggufMetadata = GgufMetadata(File(modelName));
      GgufFilenameMetdata metadata = ggufMetadata.getMetadataFromPath();

      expect(metadata.modelName, equals("Mixtral"));
      expect(metadata.version, equals("v0.1"));
      expect(metadata.expertsCount, equals(8));
      expect(metadata.parameterCount, equals("7B"));
      expect(metadata.encodingScheme, equals("Q2_K"));
      expect(metadata.shardIndex, isNull);
      expect(metadata.shardTotal, isNull);
    });
    test('Grok', () {
      const String modelName = "Grok-v1.0-100B-Q4_0-00003-of-00009.gguf";
      GgufMetadata ggufMetadata = GgufMetadata(File(modelName));
      GgufFilenameMetdata metadata = ggufMetadata.getMetadataFromPath();

      expect(metadata.modelName, equals("Grok"));
      expect(metadata.version, equals("v1.0"));
      expect(metadata.expertsCount, isNull);
      expect(metadata.parameterCount, equals("100B"));
      expect(metadata.encodingScheme, equals("Q4_0"));
      expect(metadata.shardIndex, equals(3));
      expect(metadata.shardTotal, equals(9));
    });
    test('Hermes', () {
      const String modelName = "Hermes-2-Pro-Llama-3-8B-F16.gguf";
      GgufMetadata ggufMetadata = GgufMetadata(File(modelName));
      GgufFilenameMetdata metadata = ggufMetadata.getMetadataFromPath();

      expect(metadata.modelName, equals("Hermes 2 Pro Llama 3"));
      expect(metadata.version, equals("v0.0"));
      expect(metadata.expertsCount, isNull);
      expect(metadata.parameterCount, equals("8B"));
      expect(metadata.encodingScheme, equals("F16"));
      expect(metadata.shardIndex, isNull);
      expect(metadata.shardTotal, isNull);
    });
    test('Malformed Name', () {
      const String modelName = "not-a-known-arrangement.gguf";
      GgufMetadata ggufMetadata = GgufMetadata(File(modelName));
      GgufFilenameMetdata metadata = ggufMetadata.getMetadataFromPath();

      expect(metadata.modelName, equals(""));
      expect(metadata.version, equals("v0.0"));
      expect(metadata.expertsCount, isNull);
      expect(metadata.parameterCount, equals(""));
      expect(metadata.encodingScheme, equals(""));
      expect(metadata.shardIndex, isNull);
      expect(metadata.shardTotal, isNull);
    });
  });
}
