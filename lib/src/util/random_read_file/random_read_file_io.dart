import 'dart:io';
import 'dart:typed_data';

import 'random_read_file_base.dart';

class RandomReadFile implements RandomReadFileBase {
  final RandomAccessFile? _randomAccessFile;
  final Uint8List? _bytes;
  int _idx = 0;

  RandomReadFile._(this._randomAccessFile, this._bytes);

  static Future<RandomReadFile> fromFile(File file) async {
    RandomAccessFile randomFile = await file.open(mode: FileMode.read);
    return RandomReadFile._(randomFile, null);
  }

  static RandomReadFile fromBytes(Uint8List bytes) {
    return RandomReadFile._(null, bytes);
  }

  @override
  Future<void> close() async {
    if (_randomAccessFile != null) {
      await _randomAccessFile.close();
      return;
    } else if (_bytes != null) {
      _bytes.clear();
      return;
    } else {
      throw Exception("No valid backing data found!");
    }
  }

  @override
  Future<int> position() async {
    if (_randomAccessFile != null) {
      return await _randomAccessFile.position();
    } else if (_bytes != null) {
      return _idx;
    } else {
      throw Exception("No valid backing data found!");
    }
  }

  @override
  Future<Uint8List> read(int count) async {
    Uint8List bytes;
    if (_randomAccessFile != null) {
      bytes = await _randomAccessFile.read(count);
    } else if (_bytes != null) {
      bytes = _bytes.sublist(_idx, _idx + count);
      _idx += count;
    } else {
      throw Exception("No valid backing data found!");
    }
    return bytes;
  }

  @override
  Future<void> setPosition(int position) async {
    if (_randomAccessFile != null) {
      await _randomAccessFile.setPosition(position);
    } else if (_bytes != null) {
      _idx = position;
    } else {
      throw Exception("No valid backing data found!");
    }
  }

  @override
  String get path => _randomAccessFile?.path ?? "";

  @override
  Future<int> length() async {
    if (_randomAccessFile != null) {
      return await _randomAccessFile.length();
    } else if (_bytes != null) {
      return _bytes.length;
    } else {
      throw Exception("No valid backing data found!");
    }
  }
}
