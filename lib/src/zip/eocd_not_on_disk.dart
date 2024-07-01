class EocdNotOnDisk implements Exception {
  /// The index of the disk that this exception was thrown from.
  final int currentDiskIndex;

  /// The index of the disk where the Start of Central Directory exists
  final int expectedDiskIndex;

  const EocdNotOnDisk(this.currentDiskIndex, this.expectedDiskIndex);
}
