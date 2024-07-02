import 'dart:io';

import 'package:file_metadata/src/base/file_metadata.dart';
import 'package:file_metadata/src/file_metadata_base.dart';
import 'package:file_metadata/src/gguf/gguf_file_metadata.dart';
import 'package:file_metadata/src/util/random_read_file.dart';
import 'package:file_metadata/src/zip/zip_file_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('GGUF', () {
    late RandomReadFile file;
    late List<FileMetadata> metadata;
    setUp(() async {
      file = await RandomReadFile.fromFile(
        File("test/phi-3-mini-4k-instruct-q_4.gguf"),
      );
      FileMetadataBase fileMetadataBase = FileMetadataBase(file);
      metadata = await fileMetadataBase.getAllMetadata();
    });

    tearDown(() async {
      await file.close();
    });

    test('Verify Item Count', () async {
      expect(metadata.length, equals(1));
    });

    test('Verify Type', () {
      expect(metadata.first, isA<GgufFileMetadata>());
    });
  });

  group('Zip', () {
    late RandomReadFile file;
    late List<FileMetadata> metadata;
    setUp(() async {
      file = await RandomReadFile.fromFile(
        File("test/test.zip"),
      );

      FileMetadataBase fileMetadataBase = FileMetadataBase(file);
      metadata = await fileMetadataBase.getAllMetadata();
    });

    tearDown(() async {
      await file.close();
    });

    test('Verify Item Count', () async {
      expect(metadata.length, equals(1));
    });

    test('Verify Type', () {
      expect(metadata.first, isA<ZipFileMetadata>());
    });
  });
}
