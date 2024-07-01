import 'dart:typed_data';

abstract interface class FileMetadata {
  final Uint8List magicBytes;

  const FileMetadata(this.magicBytes);
}
