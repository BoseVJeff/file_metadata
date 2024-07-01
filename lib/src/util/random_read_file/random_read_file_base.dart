import 'dart:typed_data';

abstract interface class RandomReadFileBase {
  Future<int> position();

  Future<void> setPosition(int position);

  Future<void> close();

  Future<Uint8List> read(int count);

  Future<int> length();

  String get path;
}
