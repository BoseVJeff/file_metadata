import 'dart:io';
import 'dart:typed_data';

import 'package:file_metadata/src/util/dos_date_time.dart';
import 'package:file_metadata/src/zip/compression_method.dart';

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

  /// The Start of Central Directory marker.
  ///
  /// This is actually

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

      // EoCD Signature
      Uint8List eocdSig = await file.read(4);

      // Disk Index
      int diskIndex = (await file.read(2)).buffer.asUint16List().single;

      // Disk ID of start of central directory
      int startOfCdDiskIndex =
          (await file.read(2)).buffer.asUint16List().single;

      // Central directory record count on disk
      int cdRecordCount = (await file.read(2)).buffer.asUint16List().single;

      // Total Count of Central Directories
      int cdRecordCountTotal =
          (await file.read(2)).buffer.asUint16List().single;

      // Size of central directory (bytes)
      int cdSize = (await file.read(4)).buffer.asUint32List().single;

      // Offset to start of central directory
      int startOfCdOffset = (await file.read(4)).buffer.asUint32List().single;

      // Comment Size
      int commentSize = (await file.read(2)).buffer.asUint16List().single;

      // Comment
      // Stored as Uint8List as it can contain further metadata and thus may need to be processed further
      Uint8List eocdComment = await file.read(commentSize);

      // Check if End of Central Directory is available on this disk
      if (diskIndex != startOfCdDiskIndex) {
        throw EocdNotOnDisk(diskIndex, startOfCdDiskIndex);
      }

      await file.setPosition(startOfCdOffset);

      print(file.positionSync().hex);

      // SoCD signature
      Uint8List socdSig = await file.read(4);

      // Version made by
      int creatorVersion = (await file.read(2)).buffer.asUint16List().single;

      // Minimum version required for extraction
      int minVersion = (await file.read(2)).buffer.asUint16List().single;

      // Bit Flags
      // Storing as int as that allows for XOR and other operations
      int flags = (await file.read(2)).buffer.asUint16List().single;

      // Compression method
      CompressionMethod compressionMethod = CompressionMethod.fromId(
        (await file.read(2)).buffer.asUint16List().single,
      );

      // DateTime is computed in parts from an MS-DOS format
      // Docs: https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-dosdatetimetofiletime?redirectedfrom=MSDN
      // Last Modification Time (MS DOS)
      int time = (await file.read(2)).buffer.asUint16List().single;
      int date = (await file.read(2)).buffer.asUint16List().single;

      DateTime lastModification = DosDateTime.fromInt(date, time);

      print(lastModification);

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

class EocdNotOnDisk implements Exception {
  /// The index of the disk that this exception was thrown from.
  final int currentDiskIndex;

  /// The index of the disk where the Start of Central Directory exists
  final int expectedDiskIndex;

  const EocdNotOnDisk(this.currentDiskIndex, this.expectedDiskIndex);
}

extension Hex on int {
  String get hex => toRadixString(16);
}
