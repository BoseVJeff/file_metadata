import 'package:file_metadata/src/zip/zip_name_metadata.dart';

class JarNameMetadata extends ZipNameMetadata {
  const JarNameMetadata(super.filename, super.extension);

  factory JarNameMetadata.fromPath(String path) {
    ZipNameMetadata metadata = ZipNameMetadata.fromPath(path);
    return JarNameMetadata(metadata.filename, metadata.extension);
  }

  @override
  bool isValid() => extension.toLowerCase() == "jar";
}
