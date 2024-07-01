import 'package:file_metadata/src/base/name_metadata.dart';
import 'package:path/path.dart';

class ZipNameMetadata implements NameMetadata {
  @override
  final String filename;

  @override
  final String extension;

  const ZipNameMetadata(this.filename, this.extension);

  factory ZipNameMetadata.fromPath(String path) {
    List<String> parts = basename(path).split(".");
    String ext = parts.removeLast();
    // TODO: Investigate subtypes
    return ZipNameMetadata(parts.join("."), ext);
  }

  @override
  bool isValid() => extension.toLowerCase() == "zip";
}
