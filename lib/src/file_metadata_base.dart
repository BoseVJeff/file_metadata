import 'dart:typed_data';

import 'package:file_metadata/src/base/file_metadata.dart';
import 'package:file_metadata/src/base/name_metadata.dart';
import 'package:file_metadata/src/util/random_read_file.dart';
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

class FileMetadataBase implements FileMetadata {
  final RandomReadFile file;

  const FileMetadataBase(this.file);

  /// For the basic file, this will be an empty list.
  @override
  Uint8List get magicBytes => Uint8List(0);
}
