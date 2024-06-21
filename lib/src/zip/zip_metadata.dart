import 'dart:io';
import 'dart:typed_data';

import 'zip_file_metadata.dart';
import 'package:path/path.dart';

import 'zip_filename_metadata.dart';

import '../file_metadata_base.dart';

class ZipMetadata extends FileMetadataBase {
  ZipMetadata(super.file);

  /// The EoCD marker.
  ///
  /// This is actually 0x[50, 4B, 05, 06] in the file.
  /// The reason we use the digits in reverse order is because we check for these bytes from the end of file(?).
  /// Therefore, the bytes that we obtain are also reversed.
  static const int _eocdMarker = 0x06054B50;

  @override
  Future<ZipFileMetadata> getMetadataFromFile() async {
    RandomAccessFile file = await super.file.open(mode: FileMode.read);

    try {
      // Finding End of Central Directory (EoCD)

      // The offset is max comment length + param size away from end of file
      const int maxEocdOffset = 0xffff + 22;
      // const int maxEocdOffset = 22;
      // File length
      final int fileLength = await file.length();
      // Since this is a small range, read the entire span into memory and find the marker.
      await file.setPosition((await file.length()) - maxEocdOffset);
      Uint8List bytes = await file.read(maxEocdOffset);
      int eocdOffset = -1;
      // Read backwards for marker
      for (var i = maxEocdOffset - 4; i >= 0; i--) {
        Uint8List scannedBytes = bytes.sublist(i, i + 4);
        int mark = scannedBytes.buffer.asUint32List().first;
        // print(scannedBytes);
        if (mark == _eocdMarker) {
          eocdOffset = fileLength - maxEocdOffset + i;
          break;
        }
      }
      if (eocdOffset == -1) {
        // Offset not found, terminate immediately
        // TODO: Convert this into a proper exception
        throw Exception("No EoCD marker found!");
      }
      // We've found the offset
      print(eocdOffset.toRadixString(16));

      await file.setPosition(eocdOffset);

      return ZipFileMetadata();
    } finally {
      await file.close();
    }
  }

  @override
  ZipFilenameMetadata getMetadataFromPath() => ZipFilenameMetadata(
        basename(super.file.path),
      );
}
