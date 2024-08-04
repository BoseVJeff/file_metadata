// Base export

export 'random_read_file/random_read_file_no_io.dart'
    if (dart.library.io) 'random_read_file/random_read_file_io.dart';

// Utility
import 'dart:convert';
import 'dart:typed_data';

import 'random_read_file/random_read_file_no_io.dart'
    if (dart.library.io) 'random_read_file/random_read_file_io.dart';

extension BackwardsRandomRead on RandomReadFile {
  /// Reads [count] bytes backwards from the current file position.
  Future<Uint8List> readBackward(int count) async {
    // Set cursor to start of the size
    await setPosition((await position()) - count);
    Uint8List bytes = await read(count);
    // Set the cursor back to the start of the buffer.
    // This recreates the behaviour that read provides (of setting the cursor to the end of the read).
    // Note that we move the cursor back as we are reading in the backwards direction.
    await setPosition((await position()) - count);
    return bytes;
  }
}

/// Extension method to make reading data from files easier.
///
/// All methods here are focused on converting the data to the appropiate type before returning it, reducing repetitive boilerplate.
///
/// Note that all operations use the [RandomReadFile.read] method under the hood.
/// Thus, all of them will move the file position/cursor beyond the end of the data read.
extension TypedRandomRead on RandomReadFile {
  // Unsigned Integers
  // MARK: Uint

  /// Read an 8 bit unsigned integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readUint8() async => (await read(1)).buffer.asUint8List().single;

  /// Read an 8 bit unsigned integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readUint8BE() async =>
      ByteData.sublistView(await read(1)).getUint8(0);

  /// Read an 16 bit unsigned integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readUint16() async =>
      (await read(2)).buffer.asUint16List().single;

  /// Read an 16 bit unsigned integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readUint16BE() async =>
      ByteData.sublistView(await read(2)).getUint16(0, Endian.big);

  /// Read an 32 bit unsigned integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readUint32() async =>
      (await read(4)).buffer.asUint32List().single;

  /// Read an 32 bit unsigned integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readUint32BE() async =>
      ByteData.sublistView(await read(4)).getUint32(0, Endian.big);

  /// Read an 64 bit unsigned integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readUint64() async =>
      (await read(8)).buffer.asUint64List().single;

  /// Read an 64 bit unsigned integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readUint64BE() async =>
      ByteData.sublistView(await read(8)).getUint64(0, Endian.big);

  // Signed integers
  // MARK: Int

  /// Read an 8 bit signed integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readInt8() async => (await read(1)).buffer.asInt8List().single;

  /// Read an 8 bit signed integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readInt8BE() async =>
      ByteData.sublistView(await read(1)).getInt8(0);

  /// Read an 16 bit signed integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readInt16() async => (await read(2)).buffer.asInt16List().single;

  /// Read an 16 bit signed integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readInt16BE() async =>
      ByteData.sublistView(await read(16)).getInt16(0, Endian.big);

  /// Read an 32 bit signed integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readInt32() async => (await read(4)).buffer.asInt32List().single;

  /// Read an 32 bit signed integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readInt32BE() async =>
      ByteData.sublistView(await read(4)).getInt32(0, Endian.big);

  /// Read an 64 bit signed integer from the file.
  ///
  /// Note that this advances the file position.
  Future<int> readInt64() async => (await read(8)).buffer.asInt64List().single;

  /// Read an 64 bit signed integer from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<int> readInt64BE() async =>
      ByteData.sublistView(await read(8)).getInt64(0, Endian.big);

  // Floating point numbers
  // MARK: Floats

  /// Read a 32 bit floating point number from the file.
  ///
  /// Note that this advances the file position.
  Future<double> readFloat32() async =>
      (await read(4)).buffer.asFloat32List().single;

  /// Read a 32 bit floating point number from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<double> readFloat32BE() async =>
      ByteData.sublistView(await read(4)).getFloat32(0, Endian.big);

  /// Read a 64 bit floating point number from the file.
  ///
  /// Note that this advances the file position.
  Future<double> readFloat64() async =>
      (await read(8)).buffer.asFloat64List().single;

  /// Read a 64 bit floating point number from the file in big-endian order.
  ///
  /// Note that this advances the file position.
  Future<double> readFloat64BE() async =>
      ByteData.sublistView(await read(8)).getFloat64(0, Endian.big);

  // Strings
  // MARK: Strings

  /// Read a utf8 string of size `length` bytes from the file.
  ///
  /// Note that this advances the file position.
  Future<String> readUtf8String(int length) async =>
      utf8.decode(await read(length));

  /// Read a utf16 string of size `length` from the file.
  ///
  /// Note that this advances the file position.
  Future<String> readUtf16String(int length) async =>
      String.fromCharCodes(await read(length));
}
