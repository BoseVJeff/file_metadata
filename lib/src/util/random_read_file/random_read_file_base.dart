import 'dart:typed_data';

abstract interface class RandomReadFileBase {
  /// The current position of the cursor.
  Future<int> position();

  /// Synchronously gets the position of the cursor.
  ///
  /// This is mostly intended for use in debugging contexts where using an async function can be difficult to call and handle.
  ///
  /// Perfer using [position] instead.
  int positionSync();

  /// Set cursor to the specified position.
  ///
  /// This positon should be the offset from the start of the file.
  Future<void> setPosition(int position);

  /// Closes the file and frees resources.
  ///
  /// This will free the underlying resources.
  ///
  /// No guarantees are made on the behaviour of any methods called on this instance after the [close] method has been called.
  Future<void> close();

  /// Reads [count] bytes from the file and moves the cursor past the end of the bytes read.
  Future<Uint8List> read(int count);

  /// Size (in bytes) of the data in the file.
  Future<int> length();

  /// Path of the file that the data is being read from.
  ///
  /// If this class is constructed using raw bytes and does not have a filename assigned in the constructor, then this will return an empty string.
  String get path;
}
