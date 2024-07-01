import 'dart:convert';
import 'dart:typed_data';

import 'package:file_metadata/src/util/random_read_file.dart';

import '../base/file_metadata.dart';
import 'file_type.dart';
import 'gguf_metadata_value_types.dart';
import 'parser.dart';
import 'tensor.dart';
import 'tensor_types.dart';

class GgufFileMetadata implements FileMetadata {
  /// The magic bytes.
  ///
  /// These are the first 4 bytes of the file.
  @override
  final Uint8List magicBytes;

  /// The magic bytes encoded as a UTF-8 String
  ///
  /// Remember to check that this is equal to `GGUF` for a valid GGUF model file.
  String get magicString => utf8.decode(magicBytes, allowMalformed: false);

  /// The version of GGUF the file was created with.
  ///
  /// At the time of writing, the latest version is `3`.
  final int ggufVersion;

  /// The `tensor_count` of the model.
  final int tensorCount;

  /// The number of metadata key-value pairs
  final int metadataKvCount;

  /// Metadata key-value pairs.
  final Map<String, Object> kvPairs;

  /// The byte alignment width
  ///
  /// This must be a multiple of 8 according to the docs.
  /// The default value used here is `32//8=4` as mentioned in the docs.
  final int alignment;

  /// The info for all tensors in the file.
  ///
  /// This contains tensor information and the tensor offsets where they can be loaded from.
  ///
  /// Note that the offsets are from `tensor_data` as mentioned in the docs.
  final List<Tensor> tensors;

  /// The file type.
  ///
  /// This is an indicator of what type of data the file usually contains.
  ///
  /// For a list of all possible file types, look at the values of [FileType].
  FileType get fileType => FileType.fromId(
        (kvPairs["general.file_type"] as int?) ?? -1,
      );

  const GgufFileMetadata(
    this.magicBytes,
    this.ggufVersion,
    this.tensorCount,
    this.metadataKvCount, {
    this.alignment = 8,
    this.kvPairs = const {},
    this.tensors = const [],
  });

  static Future<GgufFileMetadata> fromFile(
    RandomReadFile file,
  ) async {
    // Using a reusable variable to reduce memory useage
    Uint8List bytes;
    try {
      // Getting and setting the magic bytes
      bytes = await file.read(4);
      Uint8List magicBytes = bytes;

      // Getting the GGUF version bytes
      bytes = await file.read(4);
      int ggufVersion = bytes.buffer.asUint32List().first;

      // Getting the tensor count
      bytes = await file.read(8);
      int tensorCount = bytes.buffer.asUint64List().first;

      // Getting the kv pair count
      bytes = await file.read(8);
      int metadataKvCount = bytes.buffer.asUint64List().first;

      Map<String, Object> kvPairs = {};

      List<Tensor> tensors = [];

      int alignment = 8;

      for (var i = 0; i < metadataKvCount; i++) {
        // Get length of the key string
        bytes = await file.read(8);
        int keyLength = bytes.buffer.asUint64List().first;
        // print("Key length $keyLength");
        bytes = await file.read(keyLength);
        String key = utf8.decode(bytes);
        // TODO: Add this print alongwith all of the other prints into a logger instead.
        // print(
        //   "Key: $key at ${randomAccessFile.positionSync().toRadixString(16)}",
        // );
        // Get type of value
        bytes = await file.read(4);
        int typeId = bytes.buffer.asUint32List().first;
        GgufMetadataValueType type = GgufMetadataValueType.fromId(typeId);
        Object value;
        switch (type) {
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT8:
            value = await Parser.getUint8Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT8:
            value = await Parser.getInt8Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT16:
            value = await Parser.getUint16Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT16:
            value = await Parser.getInt16Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT32:
            value = await Parser.getUint32Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT32:
            value = await Parser.getInt32Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT32:
            value = await Parser.getFloat32Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_BOOL:
            value = await Parser.getBooleanValue(file);
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_STRING:
            value = await Parser.getUtf8String(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_ARRAY:
            value = await Parser.getArray(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT64:
            value = await Parser.getUint64Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT64:
            value = await Parser.getInt64Value(file);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT64:
            value = await Parser.getFloat64Value(file);
            break;
        }
        kvPairs.addAll({key: value});
      }

      alignment = (kvPairs["general.alignment"] as int?) ?? 8;

      // Next section contains information about all tensors and their offsets in the file
      //   print("Getting tensor info...");
      for (int k = 0; k < tensorCount; k++) {
        String name = await Parser.getUtf8String(file);
        int dimensionCount = await Parser.getUint32Value(file);
        List<int> dimensions = [];
        for (int d = 0; d < dimensionCount; d++) {
          dimensions.add(await Parser.getUint64Value(file));
        }
        TensorType tensorType = TensorType.fromId(
          await Parser.getUint32Value(file),
        );
        int offset = await Parser.getUint64Value(file);

        tensors.add(
          Tensor(name, dimensionCount, dimensions, tensorType, offset),
        );
      }
      //   print("End of tensor position: ${randomAccessFile.positionSync()}");
      // B40CB(HEX) for phi-3-mini-4k-instruct-q_4
      // 1302743(DEC) for deepseek-coder-6.7b-instruct
      // 6042510(DEC) for gemma-2b-it-q8_0

      // For details on unpacking quantised weights, see https://github.com/ggerganov/llama.cpp/pull/1684#issue-1739619305

      return GgufFileMetadata(
        magicBytes,
        ggufVersion,
        tensorCount,
        metadataKvCount,
        alignment: alignment,
        kvPairs: kvPairs,
        tensors: tensors,
      );
    } on UnimplementedError catch (_) {
      print("Byte Position at Error: ${await file.position()}");
      // print(s);
      rethrow;
    } on UnknownGgmlMetadataValueType catch (e) {
      print("Unknown type: ${e.id}");
      rethrow;
    } finally {
      file.close();
    }
  }
}
