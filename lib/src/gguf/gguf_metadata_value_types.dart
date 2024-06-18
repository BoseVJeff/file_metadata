// ignore_for_file: constant_identifier_names

// Ripped straight from https://github.com/ggerganov/ggml/blob/master/docs/gguf.md#file-structure
enum GgufMetadataValueType {
  /// The value is a 8-bit unsigned integer.
  GGUF_METADATA_VALUE_TYPE_UINT8(0),

  /// The value is a 8-bit signed integer.
  GGUF_METADATA_VALUE_TYPE_INT8(1),

  /// The value is a 16-bit unsigned little-endian integer.
  GGUF_METADATA_VALUE_TYPE_UINT16(2),

  /// The value is a 16-bit signed little-endian integer.
  GGUF_METADATA_VALUE_TYPE_INT16(3),

  /// The value is a 32-bit unsigned little-endian integer.
  GGUF_METADATA_VALUE_TYPE_UINT32(4),

  /// The value is a 32-bit signed little-endian integer.
  GGUF_METADATA_VALUE_TYPE_INT32(5),

  /// The value is a 32-bit IEEE754 floating point number.
  GGUF_METADATA_VALUE_TYPE_FLOAT32(6),

  /// The value is a boolean.
  ///
  /// 1-byte value where 0 is false and 1 is true.
  ///
  /// Anything else is invalid, and should be treated as either the model being invalid or the reader being buggy.
  GGUF_METADATA_VALUE_TYPE_BOOL(7),

  /// The value is a UTF-8 non-null-terminated string, with length prepended.
  GGUF_METADATA_VALUE_TYPE_STRING(8),

  /// The value is an array of other values, with the length and type prepended.
  ///
  /// Arrays can be nested, and the length of the array is the number of elements in the array, not the number of bytes.
  GGUF_METADATA_VALUE_TYPE_ARRAY(9),

  /// The value is a 64-bit unsigned little-endian integer.
  GGUF_METADATA_VALUE_TYPE_UINT64(10),

  /// The value is a 64-bit signed little-endian integer.
  GGUF_METADATA_VALUE_TYPE_INT64(11),

  /// The value is a 64-bit IEEE754 floating point number.
  GGUF_METADATA_VALUE_TYPE_FLOAT64(12);

  final int idNum;

  const GgufMetadataValueType(this.idNum);

  /// Returns the [GgufMetadataValueType] corresponding to the relevant ID.
  ///
  /// If no matching type is found, throws an [UnknownGgmlMetadataValueType] exception.
  factory GgufMetadataValueType.fromId(int id) {
    switch (id) {
      case 0:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT8;
      case 1:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT8;
      case 2:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT16;
      case 3:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT16;
      case 4:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT32;
      case 5:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT32;
      case 6:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT32;
      case 7:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_BOOL;
      case 8:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_STRING;
      case 9:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_ARRAY;
      case 10:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_UINT64;
      case 11:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_INT64;
      case 12:
        return GgufMetadataValueType.GGUF_METADATA_VALUE_TYPE_FLOAT64;
      default:
        throw UnknownGgmlMetadataValueType(id);
    }
  }
}

class UnknownGgmlMetadataValueType implements Exception {
  // The ID that does not correspond to any known type.
  final int id;

  UnknownGgmlMetadataValueType(this.id);
}
