import 'dart:typed_data';

import 'random_read_file_base.dart';

class RandomReadFile implements RandomReadFileBase {
  final Uint8List _bytes;
  final String _filename;
  int _idx = 0;

  RandomReadFile._(this._bytes, [this._filename = ""]);

  // TODO: In the long term, look into supporting the filesystem API on the web.
  static Future<RandomReadFile> fromFile(_) async {
    throw UnimplementedError(
      "Importing from file is not supported on this platform!",
    );
  }

  static RandomReadFile fromBytes(Uint8List bytes, [String filename = ""]) {
    return RandomReadFile._(bytes, filename);
  }

  @override
  Future<void> close() async {
    _bytes.clear();
    return;
  }

  @override
  Future<int> position() async {
    return _idx;
  }

  @override
  int positionSync() {
    return _idx;
  }

  @override
  Future<Uint8List> read(int count) async {
    Uint8List bytes;
    bytes = _bytes.sublist(_idx, _idx + count);
    _idx += count;
    return bytes;
  }

  @override
  Future<void> setPosition(int position) async {
    _idx = position;
  }

  @override
  String get path => _filename;

  @override
  Future<int> length() async {
    return _bytes.length;
  }
}
