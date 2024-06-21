class EocdRecord {
  final int signature;
  final int diskIndex;
  final int centralDirectoryStartDiskIndex;
  final int centralDirectoryRecordOnDiskCount;
  final int centralDirectoryRecordTotalCount;
  final int centralDirectorySize;
  final int centralDirectoryStartOffset;
  final String comment;

  const EocdRecord(
    this.signature,
    this.diskIndex,
    this.centralDirectoryStartDiskIndex,
    this.centralDirectoryRecordOnDiskCount,
    this.centralDirectoryRecordTotalCount,
    this.centralDirectorySize,
    this.centralDirectoryStartOffset,
    this.comment,
  );
}
