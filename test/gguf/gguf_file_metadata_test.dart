import 'dart:io';

import 'package:file_metadata/src/gguf/file_type.dart';
import 'package:file_metadata/src/gguf/gguf_file_metadata.dart';
import 'package:file_metadata/src/util/random_read_file.dart';
import 'package:test/test.dart';

void main() {
  group('Phi 3', () {
    late RandomReadFile randomReadFile;
    late GgufFileMetadata metadata;

    setUpAll(() async {
      randomReadFile = await RandomReadFile.fromPath(
      "test/phi-3-mini-4k-instruct-q_4.gguf",
      );
      metadata = await GgufFileMetadata.fromFile(randomReadFile);
    });

    tearDownAll(() async {
      await randomReadFile.close();
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
