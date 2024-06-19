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

      expect(metadata.fileName, equals("Mixtral-v0.1-8x7B-Q2_K"));
      expect(metadata.fileExtension, equals("gguf"));
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

      expect(metadata.fileName, equals("Grok-v1.0-100B-Q4_0-00003-of-00009"));
      expect(metadata.fileExtension, equals("gguf"));
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

      expect(metadata.fileName, equals("Hermes-2-Pro-Llama-3-8B-F16"));
      expect(metadata.fileExtension, equals("gguf"));
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

      expect(metadata.fileName, equals("not-a-known-arrangement"));
      expect(metadata.fileExtension, equals("gguf"));
    });
  });

  group('Phi 3 from File', () {
    GgufMetadata ggufMetadata = GgufMetadata(
      File("test/phi-3-mini-4k-instruct-q_4.gguf"),
    );
    // Not parsing the filename here as it is not a known format.
    // late GgufFilenameMetdata pathMetdata;
    late GgufFileMetadata metadata;

    setUpAll(() async {
      // pathMetdata = ggufMetadata.getMetadataFromPath();
      metadata = await ggufMetadata.getMetadataFromFile();
    });

    test('Magic String', () {
      expect(metadata.magicString, equals("GGUF"));
    });

    test('GGUF Version', () {
      expect(metadata.ggufVersion, equals(3));
    });

    test('Tensor Count', () {
      expect(metadata.tensorCount, equals(195));
    });

    test('Metadata K/V Count', () {
      // Test that the described number is as expected
      expect(metadata.metadataKvCount, equals(24));
      // Test that the actual number of K/V pairs obtained match the declared numbers
      expect(metadata.kvPairs.length, equals(metadata.metadataKvCount));
    });

    // Specific K/V values

    test('Architecture', () {
      expect(metadata.kvPairs["general.architecture"], equals("phi3"));
    });

    test('Name', () {
      expect(metadata.kvPairs["general.name"], equals("Phi3"));
    });

    test('Context Length', () {
      expect(metadata.kvPairs["phi3.context_length"], equals(4096));
    });

    test('Embedding Length', () {
      expect(metadata.kvPairs["phi3.embedding_length"], equals(3072));
    });

    test('Feed Forward Length', () {
      expect(metadata.kvPairs["phi3.feed_forward_length"], equals(8192));
    });

    test('Block Count', () {
      expect(metadata.kvPairs["phi3.block_count"], equals(32));
    });

    test('Attention Head Count', () {
      expect(metadata.kvPairs["phi3.attention.head_count"], equals(32));
    });

    test('Attention Head K/V Count', () {
      expect(metadata.kvPairs["phi3.attention.head_count_kv"], equals(32));
    });

    test('Attention Layer Norm RMS Epsilon', () {
      expect(
        metadata.kvPairs["phi3.attention.layer_norm_rms_epsilon"],
        equals(0.000009999999747378752),
      );
    });

    test('Rope Dimension Count', () {
      expect(metadata.kvPairs["phi3.rope.dimension_count"], equals(96));
    });

    test('File Type', () {
      expect(metadata.fileType, equals(FileType.MOSTLY_Q4_K_M));
    });

    test('Tokeniser Model Name', () {
      expect(metadata.kvPairs["tokenizer.ggml.model"], equals("llama"));
    });

    test('Tokeniser Model Pre', () {
      expect(metadata.kvPairs["tokenizer.ggml.pre"], equals("default"));
    });

    test('Token Count and Scores', () {
      // Verify number of tokens
      expect(
        (metadata.kvPairs["tokenizer.ggml.tokens"] as List).length,
        equals(32064),
      );

      // Verify that each token has a corresponding score
      expect(
        (metadata.kvPairs["tokenizer.ggml.scores"] as List).length,
        equals(32064),
      );

      // Verify that each token has a corressponding type
      expect(
        (metadata.kvPairs["tokenizer.ggml.token_type"] as List).length,
        equals(32064),
      );
    });

    test('BoS Token', () {
      expect(
        (metadata.kvPairs["tokenizer.ggml.bos_token_id"] as int),
        equals(1),
      );
    });

    test('EoS Token', () {
      expect(
        (metadata.kvPairs["tokenizer.ggml.eos_token_id"] as int),
        equals(32000),
      );
    });

    test('Unknown Token', () {
      expect(
        (metadata.kvPairs["tokenizer.ggml.unknown_token_id"] as int),
        equals(0),
      );
    });

    test('Padding Token', () {
      expect(
        (metadata.kvPairs["tokenizer.ggml.padding_token_id"] as int),
        equals(32000),
      );
    });

    test('Add BoS Token?', () {
      expect(
        (metadata.kvPairs["tokenizer.ggml.add_bos_token"] as bool),
        isTrue,
      );
    });

    test('Add EoS Token?', () {
      expect(
        (metadata.kvPairs["tokenizer.ggml.add_eos_token"] as bool),
        isFalse,
      );
    });

    test('Chat Template', () {
      expect(
        (metadata.kvPairs["tokenizer.chat_template"] as String),
        equals(
          "{{ bos_token }}{% for message in messages %}{% if (message['role'] == 'user') %}{{'<|user|>' + '\n' + message['content'] + '<|end|>' + '\n' + '<|assistant|>' + '\n'}}{% elif (message['role'] == 'assistant') %}{{message['content'] + '<|end|>' + '\n'}}{% endif %}{% endfor %}",
        ),
      );
    });
  });
}
