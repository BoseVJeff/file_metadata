import 'dart:typed_data';

import '../util/random_read_file.dart';

import '../base/file_metadata.dart';

/// The DOS header for a standard Win32 file.
///
/// Note that the properties use the standard names as in the MS docs, converted to lower camel case per dart conventions.
class ImageDosHeader implements FileMetadata {
  // Ref: Blog series @ https://0xrick.github.io/win-internals/pe1/
  @override
  Uint8List get magicBytes => Uint8List.fromList([0x5A, 0x4D]);

  // MZ
  static const int dosHeaderBytes = 0x4D5A;

  /// Magic number
  ///
  /// This is the "magic number" of an EXE file.  The first byte is 0x4d and the second is 0x5a.
  final int eMagic;

  /// Bytes on last page of file.
  ///
  /// The number of bytes in the last block of the file that are actually used.
  /// If zero, it means the entire last block is used (i.e. effectively 512).
  final int eCblp;

  /// Pages in file
  ///
  /// Number of blocks in the file that are part of the EXE file.
  /// If [02-03] is non-zero, only that much of the last block is used.
  final int eCp;

  /// Relocations.
  ///
  /// Number of relocation entries stored after the header.
  /// May be zero.
  final int eCrlc;

  /// Size of header in paragraphs.
  ///
  /// The program's data begins just after the header, and this field can be used to calculate the appropriate file offset.
  /// The header includes the relocation entries.
  ///
  /// Note that some OSs and/or programs may fail if the header is not a multiple of 512 bytes.
  final int eCparhdr;

  /// Minimum extra paragraphs needed.
  ///
  /// Number of paragraphs of additional memory that the program will need.
  /// This is the equivalent of the BSS size in a Unix program.
  ///
  /// The program can't be loaded if there isn't at least this much memory available to it.
  final int eMinalloc;

  /// Maximum extra paragraphs needed.
  ///
  /// Maximum number of paragraphs of additional memory.
  ///
  /// Normally, the OS reserves all the remaining conventional memory for your program, but you can limit it with this field.
  final int eMaxAlloc;

  /// Initial (relative) SS value.
  ///
  /// This value is added to the segment the program was loaded at, and the result is used to initialize the SS register.
  final int eSS;

  /// Initial SP value.
  ///
  /// Initial value of the SP register.
  final int eSp;

  /// Checksum.
  ///
  /// Word checksum.
  /// If set properly, the 16-bit sum of all words in the file should be zero.
  /// Usually, this isn't filled in.
  final int eCsum;

  /// Initial IP value.
  ///
  /// Initial value of the IP register.
  final int eIp;

  /// Initial (relative) CS value.
  ///
  /// Initial value of the CS register, relative to the segment the program was loaded at.
  final int eCs;

  /// File address of relocation table.
  ///
  /// Offset of the first relocation item in the file.
  final int eLfarlc;

  /// Overlay number.
  ///
  /// Overlay number.
  /// Normally zero, meaning that it's the main program.
  final int eOvno;

  /// Reserved words.
  ///
  /// reserved.
  final Uint16List eRes1;

  /// OEM Identifier (for [eOeminfo]).
  final int eOemid;

  /// OEM information ([eOemid] specific)
  final int eOeminfo;

  /// Reserved words.
  final Uint16List eRes2;

  /// File address of new exe header.
  final int eLfanew;

  /// Offset where the DOS Image Header ends.
  ///
  /// There may be padding between this offset and start of the actual executable.
  ///
  /// Usual padding value seems to be `0x0`.
  ///
  /// Note that the executable starts at this offset and ends just before [eLfanew] (including padding).
  ///
  /// Also note that this can optionally contain a rich header.
  /// This is mostly undocumented but a brief description of how to detect,read and parse it follows.
  ///
  /// The presence of this rich header can be ascertained by the existence of the `0x68636952` (`Rich`) signature somewhere before [eLfanew].
  /// This marks the end of the rich header and is the only easily recognisable part of this entire structure.
  ///
  /// The Rich signtaure is followed by a 4 byte checksum.
  /// This is required to decrypt the data.
  ///
  /// It would be wise to remind the reader of a fact that was previously mentioned: THIS PART IS COMPLETELY OPTIONAL. IT BEING MISSING OR BROKEN DOES NOT AFFECT THE FUNCTIONALITY OF THE FILE.
  ///
  /// If the checksum is available, the rest of the header can be decoded by a simple `<data> XOR <checksum>`.
  /// The data is assembled as a series of `key1``value``key2``value2` values, each 4 bytes in length.
  /// Therefore, it would be advisable to XOR the data 4 bytes at a time and forming key-value pairs out of the resulting values.
  ///
  /// Note that the first four bytes will always decode to `0x44616353` (DanS) which is the start of the header.
  /// A good strategy could therefore involve moving backwards 4 bytes at a time and decoding values untill `DanS` is encountered.
  /// The rest of the bytes form the actual DOS stub executable itself.
  ///
  /// The first three key-value pairs seem to always be `{0:0}` padding values.
  /// The remaining key-value pairs seem to include some form of Bill-of-Materials (BoM) and other compiler-related metadata that is generated by Visual Studio.
  /// To decode these values, refer to some external documentation or implementations of some open-source applications (PE Bear, etc) that decode this header into its values.
  /// Note that these headers are tied to the version of the Visual Studio compiler that is used to build them.
  ///
  /// Refer to https://github.com/hasherezade/bearparser/blob/master/parser/pe/RichHdrWrapper.cpp for the implementaion in `baerparser`, the library that powers PE Bear.
  /// Refer to https://securelist.com/the-devils-in-the-rich-header/84348/ for an unusual example of how the data stored in these headers can be used.
  final int imageDosHeaderEndOffset;

  const ImageDosHeader(
    this.eMagic,
    this.eCblp,
    this.eCp,
    this.eCrlc,
    this.eCparhdr,
    this.eMinalloc,
    this.eMaxAlloc,
    this.eSS,
    this.eSp,
    this.eCsum,
    this.eIp,
    this.eCs,
    this.eLfarlc,
    this.eOvno,
    this.eRes1,
    this.eOemid,
    this.eOeminfo,
    this.eRes2,
    this.eLfanew,
    this.imageDosHeaderEndOffset,
  );

  static Future<ImageDosHeader> fromFile(RandomReadFile file) async {
    // The DOS section is at the start of the file.

    await file.setPosition(0);

    int headerBytes = await file.readUint16BE();

    if (headerBytes != dosHeaderBytes) {
      // TODO: Convert to proper exception subclass
      throw Exception("Invalid header bytes!");
    }

    final int bytesOnLPage = await file.readUint16();

    final int filePagesCount = await file.readUint16();

    final int relocations = await file.readUint16();

    final int headerSizeInParas = await file.readUint16();

    final int minExtraParasNeeded = await file.readUint16();

    final int maxExtraParasNeeded = await file.readUint16();

    final int initRelSsValue = await file.readUint16();

    final int initSpValue = await file.readUint16();

    final int checksum = await file.readUint16();

    final int initIpValue = await file.readUint16();

    final int initRelCsValue = await file.readUint16();

    final int relocTableFileAddr = await file.readUint16();

    final int overlayNum = await file.readUint16();

    // 4 elements, 16 bit (2 byte) each
    final Uint16List reserved1 = (await file.read(4 * 2)).buffer.asUint16List();

    final int oemId = await file.readUint16();

    final int oemInfo = await file.readUint16();

    // 10 elements, 16 bit (2 bytes) each
    final Uint16List reserved2 =
        (await file.read(10 * 2)).buffer.asUint16List();

    final int newExeHeaderFileAddr = await file.readUint32();

    return ImageDosHeader(
      headerBytes,
      bytesOnLPage,
      filePagesCount,
      relocations,
      headerSizeInParas,
      minExtraParasNeeded,
      maxExtraParasNeeded,
      initRelSsValue,
      initSpValue,
      checksum,
      initIpValue,
      initRelCsValue,
      relocTableFileAddr,
      overlayNum,
      reserved1,
      oemId,
      oemInfo,
      reserved2,
      newExeHeaderFileAddr,
      await file.position(),
    );
  }
}
