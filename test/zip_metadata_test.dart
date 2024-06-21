import 'dart:io';

import 'package:file_metadata/src/zip/zip_metadata.dart';
import 'package:test/test.dart';

void main() {
  test('Misc', () async {
    ZipMetadata zipMetadata = ZipMetadata(
      File(r"C:\Users\jeffb\Downloads\cmake-3.29.5-windows-x86_64.zip"),
    );
    await zipMetadata.getMetadataFromFile();
  });
}
