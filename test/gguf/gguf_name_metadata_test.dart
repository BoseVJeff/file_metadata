import 'package:file_metadata/src/gguf/gguf_name_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('Metadata from Filename', () {
    test('Mixtral', () {
      const String modelName = "Mixtral-v0.1-8x7B-Q2_K.gguf";
      GgufNameMetadata metadata = GgufNameMetadata.fromString(modelName);

      expect(metadata.modelName, equals("Mixtral"));
      expect(metadata.version, equals("v0.1"));
      expect(metadata.expertsCount, equals(8));
      expect(metadata.parameterCount, equals("7B"));
      expect(metadata.encodingScheme, equals("Q2_K"));
      expect(metadata.shardIndex, isNull);
      expect(metadata.shardTotal, isNull);

      expect(metadata.isEmpty(), isFalse);
      expect(metadata.isValid(), isTrue);

      expect(metadata.filename, equals("Mixtral-v0.1-8x7B-Q2_K"));
      expect(metadata.extension, equals("gguf"));

      expect(metadata.toString(), equals(modelName));
    });
    test('Grok', () {
      const String modelName = "Grok-v1.0-100B-Q4_0-00003-of-00009.gguf";
      GgufNameMetadata metadata = GgufNameMetadata.fromString(modelName);

      expect(metadata.modelName, equals("Grok"));
      expect(metadata.version, equals("v1.0"));
      expect(metadata.expertsCount, isNull);
      expect(metadata.parameterCount, equals("100B"));
      expect(metadata.encodingScheme, equals("Q4_0"));
      expect(metadata.shardIndex, equals(3));
      expect(metadata.shardTotal, equals(9));

      expect(metadata.isEmpty(), isFalse);
      expect(metadata.isValid(), isTrue);

      expect(metadata.filename, equals("Grok-v1.0-100B-Q4_0-00003-of-00009"));
      expect(metadata.extension, equals("gguf"));

      expect(metadata.toString(), equals(modelName));
    });
    test('Hermes', () {
      const String modelName = "Hermes-2-Pro-Llama-3-8B-F16.gguf";
      GgufNameMetadata metadata = GgufNameMetadata.fromString(modelName);

      expect(metadata.modelName, equals("Hermes 2 Pro Llama 3"));
      expect(metadata.version, equals("v0.0"));
      expect(metadata.expertsCount, isNull);
      expect(metadata.parameterCount, equals("8B"));
      expect(metadata.encodingScheme, equals("F16"));
      expect(metadata.shardIndex, isNull);
      expect(metadata.shardTotal, isNull);

      expect(metadata.isEmpty(), isFalse);
      expect(metadata.isValid(), isTrue);

      expect(metadata.filename, equals("Hermes-2-Pro-Llama-3-8B-F16"));
      expect(metadata.extension, equals("gguf"));

      expect(metadata.toString(), equals(modelName));
    });
    test('Malformed Name', () {
      const String modelName = "not-a-known-arrangement.gguf";
      GgufNameMetadata metadata = GgufNameMetadata.fromString(modelName);

      expect(metadata.modelName, isNull);
      expect(metadata.version, equals("v0.0"));
      expect(metadata.expertsCount, isNull);
      expect(metadata.parameterCount, isNull);
      expect(metadata.encodingScheme, isNull);
      expect(metadata.shardIndex, isNull);
      expect(metadata.shardTotal, isNull);

      expect(metadata.isEmpty(), isTrue);
      expect(metadata.isValid(), isFalse);

      expect(metadata.filename, equals("not-a-known-arrangement"));
      expect(metadata.extension, equals("gguf"));

      expect(metadata.toString(), equals(modelName));
    });
  });
}
