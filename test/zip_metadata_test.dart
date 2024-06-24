import 'dart:io';

import 'package:file_metadata/src/zip/zip_file_metadata.dart';
import 'package:file_metadata/src/zip/zip_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('Basic', () {
    // Test file taken from https://github.com/remme123/zip_parser/blob/07d89a38b23c4acdea8e5b117e64e32fa19abf1f/test.zip
    // Corresponding crate @ https://docs.rs/zip_parser/latest/zip_parser/index.html
    ZipMetadata zipMetadata = ZipMetadata(
      File(r"test/test.zip"),
    );
    late ZipFileMetadata metadata;
    setUpAll(() async {
      metadata = await zipMetadata.getMetadataFromFile();
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
  });
  test('Misc', () async {
    ZipMetadata zipMetadata = ZipMetadata(
      File(r"test/test.zip"),
    );
    print("Reading ZIP File...");
    ZipFileMetadata zipFileMetadata = await zipMetadata.getMetadataFromFile();
    print("Disk ${zipFileMetadata.currentDiskIndex}");
    if (zipFileMetadata.currentDiskIndex == zipFileMetadata.socdDiskIndex) {
      print("Has start of Central Directory");
    } else {
      print("Does not have start of central directory");
    }
    print(
      "Central Directories on this Disk: ${zipFileMetadata.centralDirectoriesOnDisk} out of ${zipFileMetadata.centralDirectoriesTotalCount} total",
    );
    print(
      "Data for ${zipFileMetadata.centralDirectories.length} central directories read!",
    );

    print("Files:");
    for (var cd in zipFileMetadata.centralDirectories) {
      print(cd.fileName);
    }
  });
}
