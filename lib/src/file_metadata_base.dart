import 'dart:async';
import 'dart:typed_data';

import 'package:file_metadata/src/base/file_metadata.dart';
import 'package:file_metadata/src/base/name_metadata.dart';
import 'package:file_metadata/src/gguf/gguf_file_metadata.dart';
import 'package:file_metadata/src/util/random_read_file.dart';
import 'package:file_metadata/src/zip/zip_file_metadata.dart';
import 'package:path/path.dart';

class FileNameMetadataBase implements NameMetadata {
  final RandomReadFile file;

  const FileNameMetadataBase(this.file);

  /// Naively returns the extension.
  @override
  String get extension => basename(file.path).split(".").lastOrNull ?? "";

  /// Naively returns filename.
  @override
  String get filename {
    List<String> parts = basename(file.path).split(".");
    parts.removeLast();
    return parts.join(".");
  }

  /// In this case, it simply is true.
  @override
  bool isValid() {
    // TODO: look into implementing a proper exists check.
    return true;
  }
}

/// The entrypoint to getting a file's metadata.
///
/// Consider using this class if you don't know or care about what kind of data your file contains.
///
/// If you do know what type your file is, using the class corresponding to the type may be more useful.
class FileMetadataBase implements FileMetadata {
  final RandomReadFile file;

  const FileMetadataBase(this.file);

  /// For the basic file, this will be an empty list.
  @override
  Uint8List get magicBytes => Uint8List(0);

  /// Get all possible metadata from the file.
  ///
  /// This returns a list of all possible metadata classes that could be read from this file.
  ///
  /// To parse the data obtained from this method, consider using `list[i] is ZipFileMetadata` or something similar to check what type the metadata is.
  /// Then, promote/cast the object to the appropriate type (`list[i] as ZipFileMetadata`) to use it further.
  Future<List<FileMetadata>> getAllMetadata() async {
    // A list of all possible metadata.
    // Most metadata classes will have an static `isValid` method that will perform a quick, but incomplete check if the file can be parsed (usually by checking file header only).
    // Prefer calling that as it will allow you to fail fast in case of invalid file formats.
    // This is important as, by design, you will call multiple parsers in this method and expect most to fail.
    // Note that under NO circumstance should this method throw. It is preferable to return an empty list rather than throw an exception.
    List<FileMetadata> list = [];

    // Most file formats require a specific header (GGUF, exe, etc).
    // For these kinds of files, only one format is valid at a time i.e. these formats are mutually exclusive.
    // Therefore, once one such 'header-specific' format is found to be valid, all other such formats can be skipped over.
    // You should therefore always check this flag BEFORE attempting to call the parser for any such format.
    // If this is `true`, a header-only format has been found and therefore the search for any such formats can be skipped.
    // NOTE: Formats like `.zip` can coexist with other formats (`.zip.exe`, etc) so you should parse for those formats regardless of the value of this flag.
    bool headerFormatFound = false;

    // Prefer adding a comment explaining why `headerFormatFound` is being ignored.

    // Checking for GGUF file metadata
    if (!headerFormatFound) {
      if (await GgufFileMetadata.isValidFile(file)) {
        GgufFileMetadata? metadata;
        try {
          metadata = await GgufFileMetadata.fromFile(file);
        } catch (_) {
          metadata = null;
        }
        if (metadata != null) {
          list.add(metadata);
        }
      }
    }

    // Checking for ZIP metadata
    // This is NOT a header-only format and can coexist with other formats.
    if (await ZipFileMetadata.isValid(file)) {
      ZipFileMetadata? metadata;
      try {
        metadata = await ZipFileMetadata.fromFile(file);
      } catch (_) {
        metadata = null;
      }
      if (metadata != null) {
        list.add(metadata);
      }
    }

    return list;
  }
}
