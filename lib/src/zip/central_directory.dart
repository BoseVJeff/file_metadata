import 'dart:typed_data';

import 'package:file_metadata/src/zip/compression_method.dart';

import 'extra_field.dart';

class CentralDirectory {
  final Uint8List signature;
  // TODO: Parse into proper enum/whatever to allow for comparision and other stuff
  final int creatorVersion;
  // TODO: Parse into proper enum/whatever to allow for comparision and other stuff
  final int minVersion;
  // TODO: Parse flags into proper values
  final int bitFlags;
  final CompressionMethod compressionMethod;
  final DateTime lastModified;
  final Uint8List crc32;
  final int compressedSize;
  final int uncompressedSize;
  final String fileName;
  // final Uint8List extraField;
  final List<ExtraField> extraFields;
  final String fileComment;
  final Uint8List internalFileAttributes;
  final Uint8List externalFileAttributes;

  /// From start of disk
  final int localFileHeaderOffset;

  final int diskIndexForStartOfFile;

  const CentralDirectory(
    this.signature,
    this.creatorVersion,
    this.minVersion,
    this.bitFlags,
    this.compressionMethod,
    this.lastModified,
    this.crc32,
    this.compressedSize,
    this.uncompressedSize,
    this.fileName,
    this.extraFields,
    this.fileComment,
    this.internalFileAttributes,
    this.externalFileAttributes,
    this.localFileHeaderOffset,
    this.diskIndexForStartOfFile,
  );
}
