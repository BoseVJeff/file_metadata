import 'dart:convert';

import 'package:file_metadata/src/util/random_read_file.dart';

import 'gguf_metadata_value_types.dart';

class Parser {
  const Parser._();

  static Future<int> getUint8Value(RandomReadFile file) async =>
      (await file.read(1)).buffer.asUint8List().first;

  static Future<int> getInt8Value(RandomReadFile file) async =>
      (await file.read(1)).buffer.asUint8List().first;

  static Future<int> getUint16Value(RandomReadFile file) async =>
      (await file.read(2)).buffer.asUint16List().first;

  static Future<int> getInt16Value(RandomReadFile file) async =>
      (await file.read(2)).buffer.asInt16List().first;

  static Future<int> getUint32Value(RandomReadFile file) async =>
      (await file.read(4)).buffer.asUint32List().first;

  static Future<int> getInt32Value(RandomReadFile file) async =>
      (await file.read(4)).buffer.asInt32List().first;

  static Future<int> getUint64Value(RandomReadFile file) async =>
      (await file.read(8)).buffer.asUint64List().first;

  static Future<int> getInt64Value(RandomReadFile file) async =>
      (await file.read(8)).buffer.asInt64List().first;

  static Future<double> getFloat32Value(RandomReadFile file) async =>
      (await file.read(4)).buffer.asFloat32List().first;

  static Future<double> getFloat64Value(RandomReadFile file) async =>
      (await file.read(8)).buffer.asFloat64List().first;

  static Future<bool> getBooleanValue(RandomReadFile file) async {
    int tmpVal = (await file.read(1)).buffer.asUint8List().first;
    assert(tmpVal == 0 || tmpVal == 1);
    return tmpVal == 1;
  }

  static Future<String> getUtf8String(RandomReadFile file) async {
    int length = (await file.read(8)).buffer.asUint64List().first;
    return utf8.decode(await file.read(length));
  }

  static Future<List<Object>> getArray(RandomReadFile file) async {
    final List<Object> arr = [];

    int typeId = (await file.read(4)).buffer.asUint32List().first;
    GgufMetadataValueType type = GgufMetadataValueType.fromId(typeId);

    int length = (await file.read(8)).buffer.asUint64List().first;

    switch (type) {
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_STRING:
        for (int j = 0; j < length; j++) {
          String value = await Parser.getUtf8String(file);
          arr.add(value);
        }
        break;

      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT8:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getUint8Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT8:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getInt8Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT16:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getUint16Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT16:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getInt16Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT32:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getUint32Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT32:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getInt32Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT32:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getFloat32Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_BOOL:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getBooleanValue(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_ARRAY:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getArray(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT64:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getUint64Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT64:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getInt64Value(file));
        }
        break;
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT64:
        for (int j = 0; j < length; j++) {
          arr.add(await Parser.getFloat64Value(file));
        }
        break;
    }

    return arr;
  }
}
