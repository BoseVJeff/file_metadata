import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'gguf_metadata_value_types.dart';

class Parser {
  const Parser._();

  static Future<int> getUint8Value(RandomAccessFile file) async =>
      (await file.read(1)).buffer.asUint8List().first;

  static Future<int> getInt8Value(RandomAccessFile file) async =>
      (await file.read(1)).buffer.asUint8List().first;

  static Future<int> getUint16Value(RandomAccessFile file) async =>
      (await file.read(2)).buffer.asUint16List().first;

  static Future<int> getInt16Value(RandomAccessFile file) async =>
      (await file.read(2)).buffer.asInt16List().first;

  static Future<int> getUint32Value(RandomAccessFile file) async =>
      (await file.read(4)).buffer.asUint32List().first;

  static Future<int> getInt32Value(RandomAccessFile file) async =>
      (await file.read(4)).buffer.asInt32List().first;

  static Future<int> getUint64Value(RandomAccessFile file) async =>
      (await file.read(8)).buffer.asUint64List().first;

  static Future<int> getInt64Value(RandomAccessFile file) async =>
      (await file.read(8)).buffer.asInt64List().first;

  static Future<double> getFloat32Value(RandomAccessFile file) async =>
      (await file.read(4)).buffer.asFloat32List().first;

  static Future<double> getFloat64Value(RandomAccessFile file) async =>
      (await file.read(8)).buffer.asFloat64List().first;

  static Future<bool> getBooleanValue(RandomAccessFile file) async {
    int tmpVal = (await file.read(1)).buffer.asUint8List().first;
    assert(tmpVal == 0 || tmpVal == 1);
    return tmpVal == 1;
  }

  static Future<String> getUtf8String(RandomAccessFile file) async {
    int length = (await file.read(8)).buffer.asUint64List().first;
    // print("Value length $length");
    return utf8.decode(await file.read(length));
  }

  static Future<List<Object>> getArray(RandomAccessFile file) async {
    final List<Object> arr = [];

    int typeId = (await file.read(4)).buffer.asUint32List().first;
    GgufMetadataValueType type = GgufMetadataValueType.fromId(typeId);

    int length = (await file.read(8)).buffer.asUint64List().first;

    switch (type) {
      case GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_STRING:
        for (int j = 0; j < length; j++) {
          // int stringLength = (await file.read(8)).buffer.asUint64List().first;
          // Uint8List stringBytes = await file.read(stringLength);
          // var decode = utf8.decode(stringBytes);
          // print(decode);
          // arr.add(decode);
          String value = await Parser.getUtf8String(file);
          // print(value);
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

    // throw UnimplementedError("Array is not implemented!");
  }
}

extension AlignPosition on RandomAccessFile {
  /// Get the next aligned position with the mentioned alignment (in Bytes).
  ///
  /// The formula is ripped straight from the docs at https://github.com/ggerganov/ggml/blob/master/docs/gguf.md#file-structure
  Future<void> alignPosition([int alignment = 8]) async {
    int offset = await position();
    await setPosition(offset + (alignment - (offset % alignment)) % alignment);
    // print(
    //   "${offset.toRadixString(16)} --> ${(await position()).toRadixString(16)}",
    // );
    return;
  }

  /// Get the next aligned position with the mentioned alignment (in Bytes).
  ///
  /// The formula is ripped straight from the docs at https://github.com/ggerganov/ggml/blob/master/docs/gguf.md#file-structure
  void alignPositionSync([int alignment = 8]) {
    int offset = positionSync();
    setPositionSync(offset + (alignment - (offset % alignment)) % alignment);
    return;
  }

  /// Read untill a specific byte is encountered
  ///
  /// Does not include the excluded bytes in the returned result.
  Future<Uint8List> readUntill(int stopByte) async {
    List<int> bytes = [];
    while (true) {
      int byte = (await read(1)).first;
      // print(byte);
      if (byte == stopByte) {
        break;
      }
      bytes.add(byte);
    }
    return Uint8List.fromList(bytes);
  }
}
