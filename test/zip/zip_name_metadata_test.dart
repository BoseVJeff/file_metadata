import 'package:file_metadata/src/zip/zip_name_metadata.dart';
import 'package:test/test.dart';

void main() {
  group('test.zip', () {
    late ZipNameMetadata metadata;
    setUp(() {
      metadata = ZipNameMetadata.fromPath("test.zip");
    });
    test('Filename', () {
      expect(metadata.filename, equals("test"));
    });
    test('Extension', () {
      expect(metadata.extension, equals("zip"));
    });
  });
  group('test.exe.zip', () {
    late ZipNameMetadata metadata;
    setUp(() {
      metadata = ZipNameMetadata.fromPath("test.exe.zip");
    });
    test('Filename', () {
      expect(metadata.filename, equals("test.exe"));
    });
    test('Extension', () {
      expect(metadata.extension, equals("zip"));
    });
  });
}
