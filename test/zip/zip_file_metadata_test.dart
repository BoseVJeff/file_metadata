import 'dart:io';

import 'package:file_metadata/src/util/random_read_file.dart';
import 'package:file_metadata/src/zip/zip_file_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('Basic', () {
    // Test file taken from https://github.com/remme123/zip_parser/blob/07d89a38b23c4acdea8e5b117e64e32fa19abf1f/test.zip
    // Corresponding crate @ https://docs.rs/zip_parser/latest/zip_parser/index.html
    late RandomReadFile file;
    late ZipFileMetadata metadata;
    setUpAll(() async {
      file = await RandomReadFile.fromPath("test/test.zip");
      metadata = await ZipFileMetadata.fromFile(file);
    });

    tearDownAll(() async {
      await file.close();
    });

    test('Disk Index', () {
      expect(metadata.currentDiskIndex, equals(0));
    });

    test('Central Directories on Disk', () {
      expect(metadata.centralDirectoriesOnDisk, equals(3));
    });

    test('Central Directories Total', () {
      expect(metadata.centralDirectoriesTotalCount, equals(3));
    });

    test('Verify all data read', () {
      expect(
        metadata.centralDirectories.length,
        equals(metadata.centralDirectoriesOnDisk),
      );
    });

    test('EoCD Comment', () {
      expect(metadata.eocdComment, equals("Zip file parsing test"));
    });
  });
  test('Misc', () async {
    print("Reading ZIP File...");
    ZipFileMetadata metadata = await ZipFileMetadata.fromFile(
      await RandomReadFile.fromPath("test/test.zip"),
    );
    print("Disk ${metadata.currentDiskIndex}");
    if (metadata.currentDiskIndex == metadata.socdDiskIndex) {
      print("Has start of Central Directory");
    } else {
      print("Does not have start of central directory");
    }
    print(
      "Central Directories on this Disk: ${metadata.centralDirectoriesOnDisk} out of ${metadata.centralDirectoriesTotalCount} total",
    );
    print(
      "Data for ${metadata.centralDirectories.length} central directories read!",
    );

    print("Files:");
    for (var cd in metadata.centralDirectories) {
      print(cd.fileName);
    }
  }, skip: true);
}
