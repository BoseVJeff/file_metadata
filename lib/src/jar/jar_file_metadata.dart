import 'package:file_metadata/src/util/random_read_file.dart';
import 'package:file_metadata/src/zip/zip_file_metadata.dart';

class JarFileMetadata extends ZipFileMetadata {
  JarFileMetadata(
    super.eocdSignature,
    super.currentDiskIndex,
    super.socdDiskIndex,
    super.centralDirectoriesOnDisk,
    super.centralDirectoriesTotalCount,
    super.eocdComment,
    super.centralDirectories,
  );

  static Future<ZipFileMetadata> fromFile(RandomReadFile file) async {
    ZipFileMetadata metadata = await ZipFileMetadata.fromFile(file);
    return JarFileMetadata(
      metadata.eocdSignature,
      metadata.currentDiskIndex,
      metadata.socdDiskIndex,
      metadata.centralDirectoriesOnDisk,
      metadata.centralDirectoriesTotalCount,
      metadata.eocdComment,
      metadata.centralDirectories,
    );
  }
}
