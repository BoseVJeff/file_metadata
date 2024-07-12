import 'dart:typed_data';

import 'package:file_metadata/src/pe/pe_file_metadata.dart';
import 'package:file_metadata/src/util/random_read_file.dart';
import 'package:test/test.dart';

void main() async {
  // RandomReadFile file;
  // PeFileMetadata metadata;

  // file = await RandomReadFile.fromPath(
  //   r"C:\Users\jeffb\Desktop\dbl_qr\dbl_qr.exe",
  // );
  // metadata = await PeFileMetadata.fromFile(file);

  // print("Magic: ${String.fromCharCodes(metadata.magicBytes)}");

  // print("Bytes on last page of file: ${metadata.eCblp}");

  // print("Pages in file: ${metadata.eCp}");

  group('Image DOS Header', () {
    late RandomReadFile file;
    late ImageDosHeader metadata;
    setUpAll(() async {
      file = await RandomReadFile.fromPath("test/dbl_qr.exe");
      metadata = await ImageDosHeader.fromFile(file);
    });

    test('Magic Bytes', () {
      expect(metadata.eMagic, equals(0x4D5A));
    });

    test('Bytes on Last Page of File', () {
      expect(metadata.eCblp, equals(0x90));
    });

    test('Pages in File', () {
      expect(metadata.eCp, equals(0x3));
    });

    test('Relocations', () {
      expect(metadata.eCrlc, equals(0x0));
    });

    test('Size of Header in Paragraphs', () {
      expect(metadata.eCparhdr, equals(0x4));
    });

    test('Minimum Extra Paragraphs Needed', () {
      expect(metadata.eMinalloc, equals(0x0));
    });

    test('Maximum Extra Paragraphs Needed', () {
      expect(metadata.eMaxAlloc, equals(0xFFFF));
    });

    test('Initial (Relative) SS Value', () {
      expect(metadata.eSS, equals(0x0));
    });

    test('Initial SP Value', () {
      expect(metadata.eSp, equals(0xB8));
    });

    test('Checksum', () {
      expect(metadata.eCsum, equals(0x0));
    });

    test('Initial IP Value', () {
      expect(metadata.eIp, equals(0x0));
    });

    test('Initial (Relative) CS Value', () {
      expect(metadata.eCs, equals(0x0));
    });

    test('File Address of Relocation Table', () {
      expect(metadata.eLfarlc, equals(0x40));
    });

    test('Overlay Number', () {
      expect(metadata.eOvno, equals(0x0));
    });

    test('Reserved Words 1', () {
      expect(metadata.eRes1, equals([0x0, 0x0, 0x0, 0x0]));
    });

    test('OEM Identifier', () {
      expect(metadata.eOemid, equals(0x0));
    });

    test('OEM Information', () {
      expect(metadata.eOeminfo, equals(0x0));
    });

    test('Reserved Words 2', () {
      expect(metadata.eRes2, equals(Uint16List(10)));
    });

    test('File Address of New Header', () {
      expect(metadata.eLfanew, equals(0x100));
    });

    test('End of DOS Image Header', () {
      expect(metadata.imageDosHeaderEndOffset, equals(0x40));
    });

    tearDownAll(() async {
      await file.close();
    });
  });
}
