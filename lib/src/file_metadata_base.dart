// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:mime/mime.dart';

abstract class FileMetadataBase {
  /// The target file.
  final File file;

  /// This is the default constructor.
  ///
  /// Attempt to ensure that the [file] exists before attempting to call methods that require file access.
  const FileMetadataBase(this.file);

  /// Get mime-type for file.
  ///
  /// This method will attempt to infer the mime-type purely from the file name.
  ///
  /// To get a more comprehensive result, use [FileMetaDatabase.getMimeTypeFromFile] instead.
  String? get mimeTypeFromPath => lookupMimeType(file.path);

  /// Get mime-type for file
  ///
  /// This method will open and read the file.
  ///
  /// If this is undesireable, use [FileMetadataBase.mimeTypeFromPath] instead.
  ///
  /// Throws [FileSystemException] if there is an error opening/reading the file.
  Future<String?> getMimeTypeFromFile() async {
    List<int> headerBytes = [];
    // Reading the bare minimum number of bytes that the lookup needs.
    file.openRead(0, defaultMagicNumbersMaxLength).forEach(
      (element) {
        headerBytes.addAll(element);
      },
    );
    return lookupMimeType(file.path, headerBytes: headerBytes);
  }

  /// Get all metadata possible from the filename itself.
  ///
  /// This does not attempt to open/read the file.
  FilenameMetadata getMetadataFromPath();
}

abstract class FilenameMetadata {}
