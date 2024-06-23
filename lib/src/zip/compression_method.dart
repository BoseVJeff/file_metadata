// Taken from section 4.4.5 of spec version 6.3.10 @ https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT

enum CompressionMethod {
  uncompressed(0),
  strunk(1),
  reducedWithFactor1(2),
  reducedWithFactor2(3),
  reducedWithFactor3(4),
  reducedWithFactor4(5),
  imploded(6),

  /// Reserved
  tokenizingCompressionAlgorithmReserved(7),
  deflated(8),
  deflated64(9),

  /// pkwareDataCompressionLibraryImploding
  ibmTerseOld(10),

  /// Reserved
  pkwareReserved(11),
  bzip2(12),

  /// Reserved
  pkwareReserved2(13),
  lzma(14),

  /// Reserved
  pkwareReserved3(15),
  ibmZOsCpmsc(16),
  pkwareReserved4(17),
  ibmTerseNew(18),
  ibmLz77(19),
  @Deprecated("Use method 93 for ZSTD")
  deprecratedZstd(20),
  zStandard(93),
  mp3(94),
  xz(95),
  jpegVariant(96),
  wavPackCompressedData(97),
  ppmdv1r1(98),
  aexEncryptionMarker(99),
  unknown(-1),
  ;

  final int id;

  const CompressionMethod(this.id);

  factory CompressionMethod.fromId(int typeId) {
    return CompressionMethod.values.firstWhere(
      (method) => method.id == typeId,
      orElse: () => CompressionMethod.unknown,
    );
  }
}
