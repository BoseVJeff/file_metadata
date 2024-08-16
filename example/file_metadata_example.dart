import 'package:file_metadata/zip.dart';

// Note that reading a file is an async operation.
void main() async {
  RandomReadFile file = await RandomReadFile.fromPath("test/test.zip");
  try {
    ZipFileMetadata metadata = await ZipFileMetadata.fromFile(file);
    for (var cd in metadata.centralDirectories) {
      print(cd.fileName);
    }
  } finally {
    await file.close();
  }
}
