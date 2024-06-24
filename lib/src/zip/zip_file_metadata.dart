import 'dart:typed_data';

import '../file_metadata_base.dart';
import 'central_directory.dart';

class ZipFileMetadata extends FileDataMetadata {
  /// Signature of theh end of Central DIrectory
  final Uint8List eocdSignature;

  /// Index of the current disk.
  ///
  /// A zip file can span multiple files/disks.
  /// This value identifies where this file fits.
  final int currentDiskIndex;

  /// The index of the disk where the Central Directory starts from.
  final int socdDiskIndex;

  /// The number of central directory entries on disk.
  final int centralDirectoriesOnDisk;

  /// The total number of central directories in the entire archive.
  ///
  /// This includes directories not present on the current disk.
  final int centralDirectoriesTotalCount;

  /// Comment at the end of central directory.
  final String eocdComment;

  /// Central Directories on disk.
  ///
  /// Note that these are only those that are on the current disk.
  final List<CentralDirectory> centralDirectories;

  const ZipFileMetadata(
    this.eocdSignature,
    this.currentDiskIndex,
    this.socdDiskIndex,
    this.centralDirectoriesOnDisk,
    this.centralDirectoriesTotalCount,
    this.eocdComment,
    this.centralDirectories,
  );
}
