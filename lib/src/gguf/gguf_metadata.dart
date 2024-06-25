import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_metadata/src/file_metadata_base.dart';
import 'package:file_metadata/src/gguf/gguf_file_metadata.dart';
import 'package:path/path.dart';

import 'gguf_filename_metdata.dart';
import 'gguf_metadata_value_types.dart';
import 'parser.dart';
import 'tensor_types.dart';

class GgufMetadata extends FileMetadataBase {
  GgufMetadata(super.file);

  /// Regex to get model properties from the filename.
  ///
  /// This is taken directly from the docs [in this section](https://github.com/ggerganov/ggml/blob/master/docs/gguf.md#parsing-above-naming-convention).
  static RegExp fileRegex = RegExp(
    r"^(?<model_name>[A-Za-z0-9\s-]+)(?:-v(?<major>\d+)\.(?<minor>\d+))?-(?:(?<experts_count>\d+)x)?(?<parameters>\d+[A-Za-z]?)-(?<encoding_scheme>[\w_]+)(?:-(?<shard>\d{5})-of-(?<shardTotal>\d{5}))?\.gguf$",
    multiLine: false,
  );

  @override
  // TODO: implement formatname
  String get formatname => "GGUF";

  static Uint8List sig = Uint8List.fromList([0x47, 0x47, 0x55, 0x46]);

  @override
  Future<bool> isFileValid() async {
    RandomAccessFile file = await super.file.open(mode: FileMode.read);
    try {
      Uint8List bytes = await file.read(4);
      return bytes == sig;
    } finally {
      await file.close();
    }
  }

  @override
  GgufFilenameMetdata getMetadataFromPath() {
    String filename = basename(file.path);
    final RegExpMatch? match = fileRegex.firstMatch(filename);

    String modelName =
        match?.namedGroup("model_name")?.trim().replaceAll("-", " ") ?? "";

    String majorVersion = match?.namedGroup("major") ?? "0";
    String minorVersion = match?.namedGroup("minor") ?? "0";

    int? expertsCount = int.tryParse(
      match?.namedGroup("experts_count") ?? "",
      radix: 10,
    );

    String parameterCount = match?.namedGroup("parameters") ?? "";

    String encodingScheme = match?.namedGroup("encoding_scheme") ?? "";

    int? shardIndex = int.tryParse(
      match?.namedGroup("shard") ?? "",
      radix: 10,
    );

    int? shardTotal = int.tryParse(
      match?.namedGroup("shardTotal") ?? "",
      radix: 10,
    );

    return GgufFilenameMetdata(
      filename,
      modelName,
      majorVersion,
      minorVersion,
      expertsCount,
      parameterCount,
      encodingScheme,
      shardIndex,
      shardTotal,
    );
  }

  @override
  Future<GgufFileMetadata> getMetadataFromFile() async {
    RandomAccessFile randomAccessFile = await file.open(mode: FileMode.read);
    // Using a reusable variable to reduce memory useage
    Uint8List bytes;
    try {
      // Getting and setting the magic bytes
      bytes = await randomAccessFile.read(4);
      String magicString = utf8.decode(bytes, allowMalformed: false);

      // Getting the GGUF version bytes
      bytes = await randomAccessFile.read(4);
      int ggufVersion = bytes.buffer.asUint32List().first;

      // Getting the tensor count
      bytes = await randomAccessFile.read(8);
      int tensorCount = bytes.buffer.asUint64List().first;

      // Getting the kv pair count
      bytes = await randomAccessFile.read(8);
      int metadataKvCount = bytes.buffer.asUint64List().first;

      Map<String, Object> kvPairs = {};

      List<Tensor> tensors = [];

      int alignment = 8;

      for (var i = 0; i < metadataKvCount; i++) {
        // Get length of the key string
        bytes = await randomAccessFile.read(8);
        int keyLength = bytes.buffer.asUint64List().first;
        // print("Key length $keyLength");
        bytes = await randomAccessFile.read(keyLength);
        String key = utf8.decode(bytes);
        // TODO: Add this print alongwith all of the other prints into a logger instead.
        // print(
        //   "Key: $key at ${randomAccessFile.positionSync().toRadixString(16)}",
        // );
        // Get type of value
        bytes = await randomAccessFile.read(4);
        int typeId = bytes.buffer.asUint32List().first;
        GgufMetadataValueType type = GgufMetadataValueType.fromId(typeId);
        Object value;
        switch (type) {
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT8:
            value = await Parser.getUint8Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT8:
            value = await Parser.getInt8Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT16:
            value = await Parser.getUint16Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT16:
            value = await Parser.getInt16Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT32:
            value = await Parser.getUint32Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT32:
            value = await Parser.getInt32Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT32:
            value = await Parser.getFloat32Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_BOOL:
            value = await Parser.getBooleanValue(randomAccessFile);
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_STRING:
            value = await Parser.getUtf8String(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_ARRAY:
            value = await Parser.getArray(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT64:
            value = await Parser.getUint64Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT64:
            value = await Parser.getInt64Value(randomAccessFile);
            break;
          case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT64:
            value = await Parser.getFloat64Value(randomAccessFile);
            break;
        }
        kvPairs.addAll({key: value});
      }

      alignment = (kvPairs["general.alignment"] as int?) ?? 8;

      // Next section contains information about all tensors and their offsets in the file
      //   print("Getting tensor info...");
      for (int k = 0; k < tensorCount; k++) {
        String name = await Parser.getUtf8String(randomAccessFile);
        int dimensionCount = await Parser.getUint32Value(randomAccessFile);
        List<int> dimensions = [];
        for (int d = 0; d < dimensionCount; d++) {
          dimensions.add(await Parser.getUint64Value(randomAccessFile));
        }
        TensorType tensorType = TensorType.fromId(
          await Parser.getUint32Value(randomAccessFile),
        );
        int offset = await Parser.getUint64Value(randomAccessFile);

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
        magicString,
        ggufVersion,
        tensorCount,
        metadataKvCount,
        alignment: alignment,
        kvPairs: kvPairs,
        tensors: tensors,
      );
    } on UnimplementedError catch (_) {
      print("Byte Position at Error: ${await randomAccessFile.position()}");
      // print(s);
      rethrow;
    } on UnknownGgmlMetadataValueType catch (e) {
      print("Unknown type: ${e.id}");
      rethrow;
    } finally {
      randomAccessFile.close();
    }
  }
}
